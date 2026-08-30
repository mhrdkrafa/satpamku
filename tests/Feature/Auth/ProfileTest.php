<?php

use App\Models\CandidateProfile;
use App\Models\EmployerProfile;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

test('candidate can view and update their profile', function () {
    $user = User::factory()->create([
        'role' => 'candidate',
        'status' => 'active',
    ]);

    UserProfile::create(['user_id' => $user->id]);
    CandidateProfile::create(['user_id' => $user->id]);

    $token = $user->createToken('test')->plainTextToken;

    // View Profile
    $viewResponse = $this->withHeader('Authorization', "Bearer {$token}")
        ->getJson('/api/v1/profile/candidate');

    $viewResponse->assertOk()
        ->assertJson(['success' => true]);

    // Update Profile
    $updatePayload = [
        'name' => 'Budi Santoso Updated',
        'headline' => 'Chief Security Officer Berpengalaman 5 Tahun',
        'summary' => 'Berpengalaman memimpin tim sekuriti di gedung perkantoran prestisius.',
        'city' => 'Jakarta Selatan',
        'preferred_shift' => '2_shift',
        'preferred_employment_type' => 'full_time',
        'salary_min' => 5000000,
        'salary_max' => 7000000,
        'height_cm' => 175,
        'weight_kg' => 72,
        'has_sim' => true,
        'sim_types' => ['A', 'C'],
        'highest_certificate_level' => 'gada_madya',
        'years_experience' => 5,
    ];

    $updateResponse = $this->withHeader('Authorization', "Bearer {$token}")
        ->putJson('/api/v1/profile/candidate', $updatePayload);

    $updateResponse->assertOk()
        ->assertJson([
            'success' => true,
            'message' => 'Profil satpam berhasil diperbarui.',
        ]);

    $this->assertDatabaseHas('candidate_profiles', [
        'user_id' => $user->id,
        'headline' => 'Chief Security Officer Berpengalaman 5 Tahun',
        'highest_certificate_level' => 'gada_madya',
        'height_cm' => 175,
    ]);

    $user->refresh();
    expect($user->candidateProfile->profile_completion)->toBeGreaterThan(50);
});

test('employer can view and update their profile', function () {
    $user = User::factory()->create([
        'role' => 'employer',
        'status' => 'active',
    ]);

    UserProfile::create(['user_id' => $user->id]);
    EmployerProfile::create([
        'user_id' => $user->id,
        'company_name' => 'PT Awal Sejahtera',
        'slug' => 'pt-awal-sejahtera',
    ]);

    $token = $user->createToken('test')->plainTextToken;

    $updatePayload = [
        'company_name' => 'PT Awal Sejahtera Perkasa',
        'nib' => '998877665544',
        'description' => 'Penyedia jasa pengamanan terkemuka di Indonesia.',
        'industry' => 'Jasa Keamanan & Pengawalan',
        'website' => 'https://awalsejahtera.co.id',
        'address' => 'Jl. Jend. Sudirman Kav. 10, Jakarta Selatan',
        'city' => 'Jakarta Selatan',
        'pic_name' => 'Bambang Irawan',
        'pic_phone' => '081234567899',
        'pic_position' => 'Direktur Operasional',
    ];

    $response = $this->withHeader('Authorization', "Bearer {$token}")
        ->putJson('/api/v1/profile/employer', $updatePayload);

    $response->assertOk()
        ->assertJson([
            'success' => true,
            'message' => 'Profil perusahaan berhasil diperbarui.',
        ]);

    $this->assertDatabaseHas('employer_profiles', [
        'user_id' => $user->id,
        'company_name' => 'PT Awal Sejahtera Perkasa',
        'website' => 'https://awalsejahtera.co.id',
    ]);
});

test('user can upload avatar successfully', function () {
    Storage::fake('public');

    $user = User::factory()->create([
        'role' => 'candidate',
        'status' => 'active',
    ]);

    UserProfile::create(['user_id' => $user->id]);
    $token = $user->createToken('test')->plainTextToken;

    $file = UploadedFile::fake()->create('avatar.jpg', 100, 'image/jpeg');

    $response = $this->withHeader('Authorization', "Bearer {$token}")
        ->postJson('/api/v1/profile/avatar', [
            'avatar' => $file,
        ]);

    $response->assertOk()
        ->assertJson([
            'success' => true,
            'message' => 'Foto profil berhasil diunggah.',
        ]);

    $user->refresh();
    expect($user->profile->avatar_path)->not->toBeNull();
    Storage::disk('public')->assertExists($user->profile->avatar_path);
});
