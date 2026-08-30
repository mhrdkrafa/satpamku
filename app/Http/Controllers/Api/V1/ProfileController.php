<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Profile\UpdateCandidateProfileRequest;
use App\Http\Requests\Profile\UpdateEmployerProfileRequest;
use App\Http\Resources\Api\V1\CandidateProfileResource;
use App\Http\Resources\Api\V1\EmployerProfileResource;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\CandidateProfile;
use App\Models\EmployerProfile;
use App\Models\UserProfile;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class ProfileController extends Controller
{
    /**
     * Get Candidate Profile of authenticated user.
     */
    public function showCandidate(Request $request): JsonResponse
    {
        $user = $request->user();

        if (!$user->isCandidate() && !$user->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Hanya akun satpam yang memiliki profil kandidat.',
            ], 403);
        }

        $user->load(['profile', 'candidateProfile']);

        return response()->json([
            'success' => true,
            'message' => 'Profil satpam berhasil diambil.',
            'data' => [
                'user' => new UserResource($user),
            ],
        ]);
    }

    /**
     * Update Candidate Profile of authenticated user.
     */
    public function updateCandidate(UpdateCandidateProfileRequest $request): JsonResponse
    {
        $user = $request->user();
        $validated = $request->validated();

        DB::transaction(function () use ($user, $validated) {
            // Update User base fields
            if (isset($validated['name']) || isset($validated['phone'])) {
                $user->update(array_filter([
                    'name' => $validated['name'] ?? null,
                    'phone' => $validated['phone'] ?? null,
                ]));
            }

            // Update UserProfile fields
            $userProfileData = array_filter([
                'city' => $validated['city'] ?? null,
                'address' => $validated['address'] ?? null,
                'date_of_birth' => $validated['date_of_birth'] ?? null,
                'gender' => $validated['gender'] ?? null,
                'profile_visibility' => $validated['profile_visibility'] ?? null,
            ], fn($v) => !is_null($v));

            if (!empty($userProfileData)) {
                $user->profile()->updateOrCreate(['user_id' => $user->id], $userProfileData);
            }

            // Update CandidateProfile fields
            $candidateData = array_filter([
                'headline' => $validated['headline'] ?? null,
                'summary' => $validated['summary'] ?? null,
                'preferred_city' => $validated['preferred_city'] ?? null,
                'preferred_shift' => $validated['preferred_shift'] ?? null,
                'preferred_employment_type' => $validated['preferred_employment_type'] ?? null,
                'salary_min' => $validated['salary_min'] ?? null,
                'salary_max' => $validated['salary_max'] ?? null,
                'height_cm' => $validated['height_cm'] ?? null,
                'weight_kg' => $validated['weight_kg'] ?? null,
                'has_sim' => $validated['has_sim'] ?? null,
                'sim_types' => $validated['sim_types'] ?? null,
                'available_from' => $validated['available_from'] ?? null,
                'years_experience' => $validated['years_experience'] ?? null,
                'highest_certificate_level' => $validated['highest_certificate_level'] ?? null,
            ], fn($v) => !is_null($v));

            $candidateProfile = $user->candidateProfile()->updateOrCreate(
                ['user_id' => $user->id],
                $candidateData
            );

            $candidateProfile->recalculateProfileCompletion();
        });

        $user->load(['profile', 'candidateProfile']);

        return response()->json([
            'success' => true,
            'message' => 'Profil satpam berhasil diperbarui.',
            'data' => [
                'user' => new UserResource($user),
            ],
        ]);
    }

    /**
     * Get Employer Profile of authenticated user.
     */
    public function showEmployer(Request $request): JsonResponse
    {
        $user = $request->user();

        if (!$user->isEmployer() && !$user->isAdmin()) {
            return response()->json([
                'success' => false,
                'message' => 'Hanya akun perusahaan yang memiliki profil rekruter/BUJP.',
            ], 403);
        }

        $user->load(['profile', 'employerProfile']);

        return response()->json([
            'success' => true,
            'message' => 'Profil perusahaan berhasil diambil.',
            'data' => [
                'user' => new UserResource($user),
            ],
        ]);
    }

    /**
     * Update Employer Profile of authenticated user.
     */
    public function updateEmployer(UpdateEmployerProfileRequest $request): JsonResponse
    {
        $user = $request->user();
        $validated = $request->validated();

        DB::transaction(function () use ($user, $validated) {
            if (isset($validated['name']) || isset($validated['phone'])) {
                $user->update(array_filter([
                    'name' => $validated['name'] ?? null,
                    'phone' => $validated['phone'] ?? null,
                ]));
            }

            $employerData = array_filter([
                'company_name' => $validated['company_name'] ?? null,
                'nib' => $validated['nib'] ?? null,
                'bujp_license_number' => $validated['bujp_license_number'] ?? null,
                'description' => $validated['description'] ?? null,
                'industry' => $validated['industry'] ?? null,
                'website' => $validated['website'] ?? null,
                'address' => $validated['address'] ?? null,
                'city' => $validated['city'] ?? null,
                'pic_name' => $validated['pic_name'] ?? null,
                'pic_phone' => $validated['pic_phone'] ?? null,
                'pic_position' => $validated['pic_position'] ?? null,
            ], fn($v) => !is_null($v));

            $user->employerProfile()->updateOrCreate(
                ['user_id' => $user->id],
                $employerData
            );
        });

        $user->load(['profile', 'employerProfile']);

        return response()->json([
            'success' => true,
            'message' => 'Profil perusahaan berhasil diperbarui.',
            'data' => [
                'user' => new UserResource($user),
            ],
        ]);
    }

    /**
     * Upload Avatar.
     */
    public function uploadAvatar(Request $request): JsonResponse
    {
        $request->validate([
            'avatar' => ['required', 'image', 'mimes:jpeg,png,jpg,webp', 'max:2048'],
        ]);

        $user = $request->user();
        $path = $request->file('avatar')->store('avatars', 'public');

        // Delete old avatar if exists
        if ($user->profile && $user->profile->avatar_path) {
            Storage::disk('public')->delete($user->profile->avatar_path);
        }

        $user->profile()->updateOrCreate(
            ['user_id' => $user->id],
            ['avatar_path' => $path]
        );

        $user->load('profile');

        return response()->json([
            'success' => true,
            'message' => 'Foto profil berhasil diunggah.',
            'data' => [
                'avatar_url' => Storage::disk('public')->url($path),
            ],
        ]);
    }
}
