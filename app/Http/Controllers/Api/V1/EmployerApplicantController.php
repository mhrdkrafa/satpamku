<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\Job\JobPostListResource;
use App\Models\EmployerProfile;
use App\Models\JobApplication;
use App\Models\JobPost;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class EmployerApplicantController extends Controller
{
    private function getEmployerProfile(Request $request): EmployerProfile
    {
        $user = $request->user();
        if (!$user->isEmployer() && !$user->isAdmin()) {
            abort(403, 'Hanya akun perusahaan/BUJP yang dapat mengakses manajemen pelamar.');
        }

        $profile = $user->employerProfile;
        if (!$profile) {
            $profile = EmployerProfile::create([
                'user_id' => $user->id,
                'company_name' => $user->name,
                'slug' => \Illuminate\Support\Str::slug($user->name) . '-' . time(),
            ]);
        }

        return $profile;
    }

    /**
     * Employer dashboard metrics and recent applicants.
     */
    public function dashboard(Request $request): JsonResponse
    {
        $employer = $this->getEmployerProfile($request);
        $jobIds = $employer->jobPosts()->pluck('id');

        $activeJobsCount = $employer->jobPosts()->where('status', 'published')->count();
        $totalJobsCount = $employer->jobPosts()->count();
        $totalApplicantsCount = JobApplication::whereIn('job_post_id', $jobIds)->count();
        $pendingReviewCount = JobApplication::whereIn('job_post_id', $jobIds)->whereIn('status', ['submitted', 'reviewing'])->count();
        $interviewsScheduledCount = JobApplication::whereIn('job_post_id', $jobIds)->where('status', 'interview_scheduled')->count();
        $acceptedCount = JobApplication::whereIn('job_post_id', $jobIds)->where('status', 'accepted')->count();

        $recentApplications = JobApplication::whereIn('job_post_id', $jobIds)
            ->with(['candidate.user.profile', 'candidate.certifications', 'jobPost'])
            ->latest('applied_at')
            ->limit(5)
            ->get();

        return response()->json([
            'success' => true,
            'data' => [
                'metrics' => [
                    'active_jobs' => $activeJobsCount,
                    'total_jobs' => $totalJobsCount,
                    'total_applicants' => $totalApplicantsCount,
                    'pending_review' => $pendingReviewCount,
                    'interviews_scheduled' => $interviewsScheduledCount,
                    'accepted' => $acceptedCount,
                ],
                'recent_applicants' => $recentApplications->map(function ($app) {
                    $cand = $app->candidate;
                    $user = $cand->user;
                    return [
                        'id' => $app->id,
                        'status' => $app->status,
                        'applied_at' => $app->applied_at?->toIso8601String(),
                        'job_title' => $app->jobPost->title,
                        'job_id' => $app->job_post_id,
                        'candidate_name' => $user->name,
                        'candidate_avatar' => $user->profile?->avatar_url,
                        'certificate_level' => $cand->highest_certificate_level,
                        'height_cm' => $cand->height_cm,
                        'weight_kg' => $cand->weight_kg,
                    ];
                }),
            ],
        ]);
    }

    /**
     * List applicants across all jobs or filtered by job_id and status.
     */
    public function index(Request $request): JsonResponse
    {
        $employer = $this->getEmployerProfile($request);
        $jobIds = $employer->jobPosts()->pluck('id');

        $query = JobApplication::whereIn('job_post_id', $jobIds)
            ->with(['candidate.user.profile', 'candidate.certifications', 'candidate.experiences', 'jobPost']);

        if ($request->has('job_id')) {
            $query->where('job_post_id', $request->integer('job_id'));
        }

        if ($request->has('status') && $request->query('status') !== 'all') {
            $query->where('status', $request->query('status'));
        }

        $applications = $query->latest('applied_at')->paginate($request->integer('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => $applications->map(function ($app) {
                $cand = $app->candidate;
                $user = $cand->user;
                return [
                    'id' => $app->id,
                    'status' => $app->status,
                    'applied_at' => $app->applied_at?->toIso8601String(),
                    'interview_at' => $app->interview_at?->toIso8601String(),
                    'interview_location' => $app->interview_location,
                    'rejection_reason' => $app->rejection_reason,
                    'employer_notes' => $app->employer_notes,
                    'job' => [
                        'id' => $app->jobPost->id,
                        'title' => $app->jobPost->title,
                        'location' => $app->jobPost->location?->name,
                    ],
                    'candidate' => [
                        'id' => $cand->id,
                        'name' => $user->name,
                        'email' => $user->email,
                        'phone' => $user->phone,
                        'avatar_url' => $user->profile?->avatar_url,
                        'headline' => $cand->headline,
                        'highest_certificate_level' => $cand->highest_certificate_level,
                        'height_cm' => $cand->height_cm,
                        'weight_kg' => $cand->weight_kg,
                        'has_sim_a' => $cand->has_sim_a,
                        'has_sim_b1' => $cand->has_sim_b1,
                        'has_sim_c' => $cand->has_sim_c,
                        'profile_completion' => $cand->profile_completion,
                    ],
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
     * Show applicant detail.
     */
    public function show(Request $request, JobApplication $application): JsonResponse
    {
        $employer = $this->getEmployerProfile($request);

        if ($application->jobPost->employer_id !== $employer->id && !$request->user()->isAdmin()) {
            return response()->json(['success' => false, 'message' => 'Anda tidak memiliki akses ke pelamar ini.'], 403);
        }

        $application->load([
            'candidate.user.profile',
            'candidate.certifications.certification',
            'candidate.experiences',
            'candidate.documents',
            'jobPost',
        ]);

        $cand = $application->candidate;
        $user = $cand->user;

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $application->id,
                'status' => $application->status,
                'applied_at' => $application->applied_at?->toIso8601String(),
                'interview_at' => $application->interview_at?->toIso8601String(),
                'interview_location' => $application->interview_location,
                'rejection_reason' => $application->rejection_reason,
                'employer_notes' => $application->employer_notes,
                'cover_letter' => $application->cover_letter,
                'job' => new JobPostListResource($application->jobPost),
                'candidate' => [
                    'id' => $cand->id,
                    'name' => $user->name,
                    'email' => $user->email,
                    'phone' => $user->phone,
                    'avatar_url' => $user->profile?->avatar_url,
                    'headline' => $cand->headline,
                    'summary' => $cand->summary,
                    'highest_certificate_level' => $cand->highest_certificate_level,
                    'height_cm' => $cand->height_cm,
                    'weight_kg' => $cand->weight_kg,
                    'blood_type' => $cand->blood_type,
                    'has_sim_a' => $cand->has_sim_a,
                    'has_sim_b1' => $cand->has_sim_b1,
                    'has_sim_c' => $cand->has_sim_c,
                    'profile_completion' => $cand->profile_completion,
                    'experiences' => $cand->experiences,
                    'certifications' => $cand->certifications,
                    'documents' => $cand->documents,
                ],
            ],
        ]);
    }

    /**
     * Change applicant pipeline status (reviewing, shortlisted, interview_scheduled, accepted, rejected).
     */
    public function changeStatus(Request $request, JobApplication $application): JsonResponse
    {
        $employer = $this->getEmployerProfile($request);

        if ($application->jobPost->employer_id !== $employer->id && !$request->user()->isAdmin()) {
            return response()->json(['success' => false, 'message' => 'Anda tidak memiliki akses mengubah status pelamar ini.'], 403);
        }

        $validated = $request->validate([
            'status' => ['required', 'string', 'in:submitted,reviewing,shortlisted,interview_scheduled,accepted,rejected'],
            'interview_at' => ['nullable', 'date'],
            'interview_location' => ['nullable', 'string', 'max:255'],
            'rejection_reason' => ['nullable', 'string', 'max:1000'],
            'employer_notes' => ['nullable', 'string', 'max:1000'],
        ]);

        $application->update([
            'status' => $validated['status'],
            'interview_at' => $validated['interview_at'] ?? $application->interview_at,
            'interview_location' => $validated['interview_location'] ?? $application->interview_location,
            'rejection_reason' => $validated['rejection_reason'] ?? $application->rejection_reason,
            'employer_notes' => $validated['employer_notes'] ?? $application->employer_notes,
        ]);

        // Notify candidate
        $candidateUser = $application->candidate?->user;
        if ($candidateUser) {
            $candidateUser->notify(new \App\Notifications\ApplicationStatusNotification($application, $validated['status']));
        }

        return response()->json([
            'success' => true,
            'message' => 'Status pelamar berhasil diperbarui.',
            'data' => [
                'id' => $application->id,
                'status' => $application->status,
                'interview_at' => $application->interview_at?->toIso8601String(),
                'interview_location' => $application->interview_location,
            ],
        ]);
    }
}
