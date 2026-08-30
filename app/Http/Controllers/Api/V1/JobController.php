<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\Job\JobPostDetailResource;
use App\Http\Resources\Api\V1\Job\JobPostListResource;
use App\Models\JobPost;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JobController extends Controller
{
    /**
     * Public list and search of published job postings.
     */
    public function index(Request $request): JsonResponse
    {
        $query = JobPost::published()
            ->with(['employer', 'category', 'position', 'location'])
            ->filter($request->all());

        // Sorting
        $sort = $request->query('sort', 'newest');
        match ($sort) {
            'salary_desc' => $query->orderByDesc('salary_max'),
            'salary_asc' => $query->orderBy('salary_min'),
            'urgent' => $query->orderByDesc('is_urgent')->latest('published_at'),
            'popular' => $query->orderByDesc('views_count'),
            default => $query->latest('published_at'),
        };

        $jobs = $query->paginate($request->integer('per_page', 15));

        return response()->json([
            'success' => true,
            'data' => JobPostListResource::collection($jobs),
            'meta' => [
                'current_page' => $jobs->currentPage(),
                'last_page' => $jobs->lastPage(),
                'per_page' => $jobs->perPage(),
                'total' => $jobs->total(),
            ],
        ]);
    }

    /**
     * Get featured jobs for homepage banners / highlights.
     */
    public function featured(): JsonResponse
    {
        $jobs = JobPost::featured()
            ->with(['employer', 'category', 'position', 'location'])
            ->take(6)
            ->get();

        return response()->json([
            'success' => true,
            'data' => JobPostListResource::collection($jobs),
        ]);
    }

    /**
     * Get urgent hiring jobs.
     */
    public function urgent(): JsonResponse
    {
        $jobs = JobPost::urgent()
            ->with(['employer', 'category', 'position', 'location'])
            ->take(10)
            ->get();

        return response()->json([
            'success' => true,
            'data' => JobPostListResource::collection($jobs),
        ]);
    }

    /**
     * Show single published job details.
     */
    public function show(string $slug): JsonResponse
    {
        $job = JobPost::published()
            ->where('slug', $slug)
            ->with(['employer', 'category', 'position', 'location', 'facilities', 'skills', 'certifications'])
            ->first();

        if (!$job) {
            return response()->json([
                'success' => false,
                'message' => 'Lowongan kerja tidak ditemukan atau sudah ditutup.',
            ], 404);
        }

        // Increment view count
        $job->incrementViews();

        return response()->json([
            'success' => true,
            'data' => new JobPostDetailResource($job),
        ]);
    }
}
