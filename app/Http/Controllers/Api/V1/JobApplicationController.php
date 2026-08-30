<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\Job\JobPostListResource;
use App\Models\CandidateProfile;
use App\Models\JobApplication;
use App\Models\JobPost;
use App\Models\SavedJob;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class JobApplicationController extends Controller
{
    private function getCandidateProfile(Request $request): CandidateProfile
    {
        $user = $request->user();
        if (!$user->isCandidate() && !$user->isAdmin()) {
            abort(403, 'Hanya akun satpam/kandidat yang dapat melamar dan menyimpan pekerjaan.');
        }

        return $user->candidateProfile ?? $user->candidateProfile()->create(['user_id' => $user->id]);
    }

    /**
     * Apply to a published job post.
     */
    public function apply(Request $request, JobPost $job): JsonResponse
    {
        $candidate = $this->getCandidateProfile($request);

        if ($job->status !== 'published') {
            return response()->json([
                'success' => false,
                'message' => 'Lowongan ini tidak aktif atau sudah ditutup.',
            ], 422);
        }

        if (JobApplication::where('job_post_id', $job->id)->where('candidate_id', $candidate->id)->exists()) {
            return response()->json([
                'success' => false,
                'message' => 'Anda sudah pernah melamar ke lowongan ini sebelumnya.',
            ], 422);
        }

        $validated = $request->validate([
            'cover_letter' => ['nullable', 'string', 'max:2000'],
        ]);

        $application = DB::transaction(function () use ($job, $candidate, $validated) {
            $app = JobApplication::create([
                'job_post_id' => $job->id,
                'candidate_id' => $candidate->id,
                'cover_letter' => $validated['cover_letter'] ?? null,
                'status' => 'submitted',
                'applied_at' => now(),
            ]);

            $job->increment('applications_count');

            return $app;
        });

        return response()->json([
            'success' => true,
            'message' => 'Lamaran berhasil dikirim ke perusahaan.',
            'data' => [
                'id' => $application->id,
                'status' => $application->status,
                'applied_at' => $application->applied_at->toIso8601String(),
            ],
        ], 201);
    }

    /**
     * List authenticated candidate's job applications.
     */
    public function listCandidateApplications(Request $request): JsonResponse
    {
        $candidate = $this->getCandidateProfile($request);
        $query = $candidate->applications()->with(['jobPost.employer', 'jobPost.category', 'jobPost.location']);

        if ($request->has('status')) {
            $query->where('status', $request->query('status'));
        }

        $applications = $query->paginate($request->integer('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $applications->map(function ($app) {
                return [
                    'id' => $app->id,
                    'status' => $app->status,
                    'applied_at' => $app->applied_at?->toIso8601String(),
                    'interview_at' => $app->interview_at?->toIso8601String(),
                    'interview_location' => $app->interview_location,
                    'rejection_reason' => $app->rejection_reason,
                    'cover_letter' => $app->cover_letter,
                    'job' => new JobPostListResource($app->jobPost),
                ];
            }),
            'meta' => [
                'current_page' => $applications->currentPage(),
                'last_page' => $applications->lastPage(),
                'per_page' => $applications->perPage(),
                'total' => $applications->total(),
            ],
        ]);
    }

    /**
     * Show single application detail.
     */
    public function showApplication(Request $request, JobApplication $application): JsonResponse
    {
        $user = $request->user();
        if (!$user->isAdmin() && $user->candidateProfile?->id !== $application->candidate_id && $user->employerProfile?->id !== $application->jobPost->employer_id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak memiliki akses ke berkas lamaran ini.',
            ], 403);
        }

        $application->load(['jobPost.employer', 'jobPost.category', 'jobPost.location', 'jobPost.facilities', 'jobPost.skills', 'jobPost.certifications']);

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $application->id,
                'status' => $application->status,
                'applied_at' => $application->applied_at?->toIso8601String(),
                'interview_at' => $application->interview_at?->toIso8601String(),
                'interview_location' => $application->interview_location,
                'rejection_reason' => $application->rejection_reason,
                'cover_letter' => $application->cover_letter,
                'job' => new JobPostListResource($application->jobPost),
            ],
        ]);
    }

    /**
     * Candidate withdraws their application.
     */
    public function withdraw(Request $request, JobApplication $application): JsonResponse
    {
        $candidate = $this->getCandidateProfile($request);

        if ($application->candidate_id !== $candidate->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda bukan pemilik lamaran ini.',
            ], 403);
        }

        if (in_array($application->status, ['accepted', 'rejected', 'withdrawn'])) {
            return response()->json([
                'success' => false,
                'message' => 'Lamaran dengan status ini tidak dapat dibatalkan.',
            ], 422);
        }

        $application->withdraw();

        return response()->json([
            'success' => true,
            'message' => 'Lamaran pekerjaan berhasil dibatalkan.',
            'data' => [
                'id' => $application->id,
                'status' => 'withdrawn',
            ],
        ]);
    }

    /**
     * Bookmark or remove bookmark from a job post.
     */
    public function toggleSaveJob(Request $request, JobPost $job): JsonResponse
    {
        $candidate = $this->getCandidateProfile($request);

        $existing = SavedJob::where('candidate_id', $candidate->id)
            ->where('job_post_id', $job->id)
            ->first();

        if ($existing) {
            $existing->delete();
            $isSaved = false;
            $message = 'Lowongan dihapus dari daftar tersimpan.';
        } else {
            SavedJob::create([
                'candidate_id' => $candidate->id,
                'job_post_id' => $job->id,
            ]);
            $isSaved = true;
            $message = 'Lowongan berhasil disimpan.';
        }

        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => [
                'is_saved' => $isSaved,
            ],
        ]);
    }

    /**
     * List candidate's saved / bookmarked jobs.
     */
    public function listSavedJobs(Request $request): JsonResponse
    {
        $candidate = $this->getCandidateProfile($request);
        $savedJobs = $candidate->savedJobs()->with(['jobPost.employer', 'jobPost.category', 'jobPost.location'])->latest()->paginate($request->integer('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $savedJobs->map(fn($s) => new JobPostListResource($s->jobPost)),
            'meta' => [
                'current_page' => $savedJobs->currentPage(),
                'last_page' => $savedJobs->lastPage(),
                'per_page' => $savedJobs->perPage(),
                'total' => $savedJobs->total(),
            ],
        ]);
    }
}
