<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\ChangePasswordRequest;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Requests\Auth\RegisterCandidateRequest;
use App\Http\Requests\Auth\RegisterEmployerRequest;
use App\Http\Resources\Api\V1\UserResource;
use App\Models\CandidateProfile;
use App\Models\EmployerProfile;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Register a new Candidate (Satpam) account.
     */
    public function registerCandidate(RegisterCandidateRequest $request): JsonResponse
    {
        $validated = $request->validated();

        $user = DB::transaction(function () use ($validated) {
            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'phone' => $validated['phone'],
                'password' => Hash::make($validated['password']),
                'role' => 'candidate',
                'status' => 'active',
            ]);

            UserProfile::create([
                'user_id' => $user->id,
                'city' => $validated['city'] ?? null,
                'profile_visibility' => 'employers_only',
            ]);

            CandidateProfile::create([
                'user_id' => $user->id,
                'highest_certificate_level' => $validated['highest_certificate_level'] ?? 'none',
                'preferred_city' => $validated['city'] ?? null,
                'verification_status' => 'unverified',
                'profile_completion' => 20,
            ]);

            return $user;
        });

        $user->load(['profile', 'candidateProfile']);
        $deviceName = $request->input('device_name', 'mobile_app');
        $token = $user->createToken($deviceName, ['role:candidate'])->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Pendaftaran satpam berhasil.',
            'data' => [
                'user' => new UserResource($user),
                'token' => $token,
                'token_type' => 'Bearer',
            ],
        ], 201);
    }

    /**
     * Register a new Employer (Perusahaan / BUJP) account.
     */
    public function registerEmployer(RegisterEmployerRequest $request): JsonResponse
    {
        $validated = $request->validated();

        $user = DB::transaction(function () use ($validated) {
            $user = User::create([
                'name' => $validated['name'],
                'email' => $validated['email'],
                'phone' => $validated['phone'],
                'password' => Hash::make($validated['password']),
                'role' => 'employer',
                'status' => 'active',
            ]);

            UserProfile::create([
                'user_id' => $user->id,
                'city' => $validated['city'] ?? null,
                'profile_visibility' => 'public',
            ]);

            EmployerProfile::create([
                'user_id' => $user->id,
                'company_name' => $validated['company_name'],
                'nib' => $validated['nib'] ?? null,
                'bujp_license_number' => $validated['bujp_license_number'] ?? null,
                'pic_name' => $validated['pic_name'] ?? $validated['name'],
                'pic_phone' => $validated['phone'],
                'pic_position' => $validated['pic_position'] ?? 'HR / Rekruter',
                'city' => $validated['city'] ?? null,
                'verification_status' => 'unverified',
            ]);

            return $user;
        });

        $user->load(['profile', 'employerProfile']);
        $deviceName = $request->input('device_name', 'mobile_app');
        $token = $user->createToken($deviceName, ['role:employer'])->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Pendaftaran perusahaan/BUJP berhasil.',
            'data' => [
                'user' => new UserResource($user),
                'token' => $token,
                'token_type' => 'Bearer',
            ],
        ], 201);
    }

    /**
     * Login using email or phone number.
     */
    public function login(LoginRequest $request): JsonResponse
    {
        $login = $request->input('login') ?? $request->input('username') ?? $request->input('email');
        $password = $request->input('password');

        $user = User::where('email', $login)
            ->orWhere('phone', $login)
            ->first();

        if (!$user || !Hash::check($password, $user->password)) {
            throw ValidationException::withMessages([
                'login' => ['Email/Nomor HP atau kata sandi yang Anda masukkan salah.'],
            ]);
        }

        if ($user->status === 'suspended') {
            return response()->json([
                'success' => false,
                'message' => 'Akun Anda telah dinonaktifkan. Silakan hubungi admin.',
            ], 403);
        }

        $user->load(['profile', 'candidateProfile', 'employerProfile']);
        $deviceName = $request->input('device_name', 'flutter_app');
        $token = $user->createToken($deviceName, ["role:{$user->role}"])->plainTextToken;

        return response()->json([
            'success' => true,
            'message' => 'Login berhasil.',
            'data' => [
                'user' => new UserResource($user),
                'token' => $token,
                'token_type' => 'Bearer',
            ],
        ]);
    }

    /**
     * Get the authenticated user with profiles.
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user();
        $user->load(['profile', 'candidateProfile', 'employerProfile']);

        return response()->json([
            'success' => true,
            'message' => 'Data profil berhasil diambil.',
            'data' => [
                'user' => new UserResource($user),
            ],
        ]);
    }

    /**
     * Logout and revoke current access token.
     */
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'success' => true,
            'message' => 'Logout berhasil.',
        ]);
    }

    /**
     * Change user password.
     */
    public function changePassword(ChangePasswordRequest $request): JsonResponse
    {
        $user = $request->user();
        $user->update([
            'password' => Hash::make($request->input('new_password')),
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Kata sandi berhasil diperbarui.',
        ]);
    }
}
