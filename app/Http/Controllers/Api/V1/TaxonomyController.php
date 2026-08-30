<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\Api\V1\Taxonomy\CertificationResource;
use App\Http\Resources\Api\V1\Taxonomy\FacilityResource;
use App\Http\Resources\Api\V1\Taxonomy\JobCategoryResource;
use App\Http\Resources\Api\V1\Taxonomy\JobPositionResource;
use App\Http\Resources\Api\V1\Taxonomy\LocationResource;
use App\Http\Resources\Api\V1\Taxonomy\SkillResource;
use App\Models\Certification;
use App\Models\Facility;
use App\Models\JobCategory;
use App\Models\JobPosition;
use App\Models\Location;
use App\Models\Skill;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TaxonomyController extends Controller
{
    /**
     * Get list of active locations.
     */
    public function locations(Request $request): JsonResponse
    {
        $query = Location::active();

        if ($request->has('type')) {
            $query->where('type', $request->query('type'));
        }

        if ($request->has('parent_id')) {
            $query->where('parent_id', $request->query('parent_id'));
        }

        if ($request->boolean('tree', false)) {
            $locations = Location::active()->provinces()->with('children')->get();
        } else {
            $locations = $query->get();
        }

        return response()->json([
            'success' => true,
            'data' => LocationResource::collection($locations),
        ]);
    }

    /**
     * Get list of active job categories.
     */
    public function categories(Request $request): JsonResponse
    {
        $query = JobCategory::active();

        if ($request->boolean('with_positions', true)) {
            $query->with(['positions' => fn($q) => $q->active()]);
        }

        return response()->json([
            'success' => true,
            'data' => JobCategoryResource::collection($query->get()),
        ]);
    }

    /**
     * Get list of active job positions.
     */
    public function positions(Request $request): JsonResponse
    {
        $query = JobPosition::active();

        if ($request->has('category_id')) {
            $query->where('category_id', $request->query('category_id'));
        }

        if ($request->has('category_slug')) {
            $query->whereHas('category', fn($q) => $q->where('slug', $request->query('category_slug')));
        }

        return response()->json([
            'success' => true,
            'data' => JobPositionResource::collection($query->get()),
        ]);
    }

    /**
     * Get list of active facilities & benefits.
     */
    public function facilities(Request $request): JsonResponse
    {
        $query = Facility::active();

        if ($request->has('type')) {
            $query->where('type', $request->query('type'));
        }

        return response()->json([
            'success' => true,
            'data' => FacilityResource::collection($query->get()),
        ]);
    }

    /**
     * Get list of skills.
     */
    public function skills(Request $request): JsonResponse
    {
        $query = Skill::query();

        if ($request->has('category')) {
            $query->where('category', $request->query('category'));
        }

        return response()->json([
            'success' => true,
            'data' => SkillResource::collection($query->get()),
        ]);
    }

    /**
     * Get list of active certifications.
     */
    public function certifications(Request $request): JsonResponse
    {
        $query = Certification::active();

        if ($request->has('level')) {
            $query->where('level', $request->query('level'));
        }

        return response()->json([
            'success' => true,
            'data' => CertificationResource::collection($query->get()),
        ]);
    }

    /**
     * Bundle all active taxonomy items for fast Flutter offline cache initial sync.
     */
    public function all(): JsonResponse
    {
        return response()->json([
            'success' => true,
            'data' => [
                'locations' => LocationResource::collection(Location::active()->get()),
                'categories' => JobCategoryResource::collection(JobCategory::active()->with(['positions' => fn($q) => $q->active()])->get()),
                'facilities' => FacilityResource::collection(Facility::active()->get()),
                'skills' => SkillResource::collection(Skill::all()),
                'certifications' => CertificationResource::collection(Certification::active()->get()),
            ],
        ]);
    }
}
