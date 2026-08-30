<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\Job\JobPostListResource;
use App\Models\CandidateProfile;
use App\Services\RecommendationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JobRecommendationController extends Controller
{
    public function __construct(
        protected RecommendationService $recommendationService
    ) {}

    /**
     * Get tailored job recommendations with explainable scores for authenticated candidate.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();

        $candidate = $user->candidateProfile;
        if (!$candidate) {
            $candidate = CandidateProfile::create([
                'user_id' => $user->id,
                'highest_certificate_level' => 'none',
            ]);
        }

        $limit = $request->integer('limit', 10);
        $recommendations = $this->recommendationService->getRecommendations($candidate, $limit);

        return response()->json([
            'success' => true,
            'data' => $recommendations->map(function ($job) {
                $base = (new JobPostListResource($job))->toArray(request());
                $base['match_score'] = $job->match_score;
                $base['match_reasons'] = $job->match_reasons;
                $base['match_breakdown'] = $job->match_breakdown;
                return $base;
            }),
        ]);
    }
}
