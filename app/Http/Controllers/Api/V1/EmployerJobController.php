<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Job\ChangeJobPostStatusRequest;
use App\Http\Requests\Job\StoreJobPostRequest;
use App\Http\Requests\Job\UpdateJobPostRequest;
use App\Http\Resources\Api\V1\Job\EmployerJobPostResource;
use App\Http\Resources\Api\V1\Job\JobPostDetailResource;
use App\Models\EmployerProfile;
use App\Models\JobPost;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Gate;

class EmployerJobController extends Controller
{
    private function getEmployerProfile(Request $request): EmployerProfile
    {
        $user = $request->user();
        if (!$user->isEmployer() && !$user->isAdmin()) {
            abort(403, 'Hanya akun perusahaan atau admin yang dapat mengelola lowongan kerja.');
        }

        return $user->employerProfile ?? $user->employerProfile()->create([
            'company_name' => $user->name,
            'slug' => \Illuminate\Support\Str::slug($user->name . '-' . \Illuminate\Support\Str::random(5)),
        ]);
    }

    public function index(Request $request): JsonResponse
    {
        $employer = $this->getEmployerProfile($request);
        $query = $employer->jobPosts()->with(['category', 'position', 'location'])->latest();

        if ($request->has('status')) {
            $query->where('status', $request->query('status'));
        }

        $jobs = $query->paginate($request->integer('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => EmployerJobPostResource::collection($jobs),
            'meta' => [
                'current_page' => $jobs->currentPage(),
                'last_page' => $jobs->lastPage(),
                'per_page' => $jobs->perPage(),
                'total' => $jobs->total(),
            ],
        ]);
    }

    public function store(StoreJobPostRequest $request): JsonResponse
    {
        $employer = $this->getEmployerProfile($request);
        $validated = $request->validated();

        $job = DB::transaction(function () use ($employer, $validated, $request) {
            $status = $request->boolean('submit_for_review') ? 'review' : 'draft';

            $jobData = array_merge($validated, [
                'employer_id' => $employer->id,
                'status' => $status,
            ]);

            unset($jobData['facility_ids'], $jobData['skill_ids'], $jobData['certifications'], $jobData['submit_for_review']);

            $job = JobPost::create($jobData);

            if (!empty($validated['facility_ids'])) {
                $job->facilities()->sync($validated['facility_ids']);
            }

            if (!empty($validated['skill_ids'])) {
                $job->skills()->sync($validated['skill_ids']);
            }

            if (!empty($validated['certifications'])) {
                $syncCerts = [];
                foreach ($validated['certifications'] as $cert) {
                    $syncCerts[$cert['certification_id']] = ['is_mandatory' => $cert['is_mandatory'] ?? true];
                }
                $job->certifications()->sync($syncCerts);
            }

            return $job;
        });

        return response()->json([
            'success' => true,
            'message' => $job->status === 'review'
                ? 'Lowongan kerja berhasil dikirim untuk ditinjau admin.'
                : 'Draf lowongan kerja berhasil disimpan.',
            'data' => new JobPostDetailResource($job->fresh(['category', 'position', 'location', 'facilities', 'skills', 'certifications', 'employer'])),
        ], 201);
    }

    public function show(Request $request, JobPost $job): JsonResponse
    {
        Gate::authorize('view', $job);

        $job->load(['category', 'position', 'location', 'facilities', 'skills', 'certifications', 'employer']);

        return response()->json([
            'success' => true,
            'data' => new JobPostDetailResource($job),
        ]);
    }

    public function update(UpdateJobPostRequest $request, JobPost $job): JsonResponse
    {
        Gate::authorize('update', $job);

        $validated = $request->validated();

        DB::transaction(function () use ($job, $validated) {
            $jobData = $validated;
            unset($jobData['facility_ids'], $jobData['skill_ids'], $jobData['certifications']);

            $job->update($jobData);

            if (isset($validated['facility_ids'])) {
                $job->facilities()->sync($validated['facility_ids']);
            }

            if (isset($validated['skill_ids'])) {
                $job->skills()->sync($validated['skill_ids']);
            }

            if (isset($validated['certifications'])) {
                $syncCerts = [];
                foreach ($validated['certifications'] as $cert) {
                    $syncCerts[$cert['certification_id']] = ['is_mandatory' => $cert['is_mandatory'] ?? true];
                }
                $job->certifications()->sync($syncCerts);
            }
        });

        return response()->json([
            'success' => true,
            'message' => 'Lowongan kerja berhasil diperbarui.',
            'data' => new JobPostDetailResource($job->fresh(['category', 'position', 'location', 'facilities', 'skills', 'certifications', 'employer'])),
        ]);
    }

    public function changeStatus(ChangeJobPostStatusRequest $request, JobPost $job): JsonResponse
    {
        Gate::authorize('update', $job);

        $targetStatus = $request->input('status');
        $user = $request->user();

        // Status transition handling
        if ($targetStatus === 'published') {
            if (!$user->isAdmin()) {
                // Non-admin can only submit for review
                $job->submitForReview();
                $message = 'Lowongan diajukan untuk ditinjau admin.';
            } else {
                $job->publish($user);
                $message = 'Lowongan berhasil dipublikasikan.';
            }
        } elseif ($targetStatus === 'paused') {
            $job->pause();
            $message = 'Lowongan berhasil dijeda.';
        } elseif ($targetStatus === 'closed') {
            $job->close();
            $message = 'Lowongan berhasil ditutup.';
        } elseif ($targetStatus === 'review') {
            $job->submitForReview();
            $message = 'Lowongan diajukan untuk ditinjau admin.';
        } elseif ($targetStatus === 'rejected') {
            if (!$user->isAdmin()) {
                abort(403, 'Hanya admin yang dapat menolak lowongan.');
            }
            $job->reject($request->input('rejection_reason'), $user);
            $message = 'Lowongan ditolak.';
        } else {
            $job->update(['status' => 'draft']);
            $message = 'Lowongan disimpan sebagai draf.';
        }

        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => [
                'status' => $job->fresh()->status,
                'rejection_reason' => $job->fresh()->rejection_reason,
            ],
        ]);
    }

    public function destroy(JobPost $job): JsonResponse
    {
        Gate::authorize('delete', $job);

        $job->delete();

        return response()->json([
            'success' => true,
            'message' => 'Lowongan kerja berhasil dihapus.',
        ]);
    }
}
