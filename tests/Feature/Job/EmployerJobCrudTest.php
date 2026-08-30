<?php

use App\Models\EmployerProfile;
use App\Models\JobCategory;
use App\Models\JobPost;
use App\Models\Location;
use App\Models\User;
use App\Models\UserProfile;
use Database\Seeders\TaxonomySeeder;

beforeEach(function () {
    $this->seed(TaxonomySeeder::class);

    $this->employerUser = User::factory()->create(['role' => 'employer', 'status' => 'active']);
    UserProfile::create(['user_id' => $this->employerUser->id]);
    $this->employerProfile = EmployerProfile::create([
        'user_id' => $this->employerUser->id,
        'company_name' => 'PT Garda Perkasa Jaya',
        'slug' => 'pt-garda-perkasa-jaya',
    ]);
    $this->token = $this->employerUser->createToken('test')->plainTextToken;

    $this->category = JobCategory::first();
    $this->location = Location::where('type', 'city')->first();
});

test('employer can create a job posting and submit for review', function () {
    $payload = [
        'category_id' => $this->category->id,
        'location_id' => $this->location->id,
        'title' => 'Dibutuhkan Komandan Regu Satpam Mall Kelapa Gading',
        'description' => 'Bertanggung jawab memimpin pengamanan mall dan kontrol pos.',
        'requirements' => 'Pria, tinggi min 170cm, sertifikat Gada Madya.',
        'shift_type' => '2_shift',
        'salary_min' => 5000000,
        'salary_max' => 6500000,
        'required_certificate_level' => 'gada_madya',
        'min_height_cm' => 170,
        'min_weight_kg' => 65,
        'is_urgent' => true,
        'submit_for_review' => true,
    ];

    $response = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->postJson('/api/v1/employer/jobs', $payload);

    $response->assertStatus(201)
        ->assertJson([
            'success' => true,
            'message' => 'Lowongan kerja berhasil dikirim untuk ditinjau admin.',
        ])
        ->assertJsonPath('data.status', 'review');

    $this->assertDatabaseHas('job_posts', [
        'title' => 'Dibutuhkan Komandan Regu Satpam Mall Kelapa Gading',
        'status' => 'review',
        'is_urgent' => true,
    ]);
});

test('employer can list, update and change status of their jobs', function () {
    $job = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => $this->category->id,
        'location_id' => $this->location->id,
        'title' => 'Satpam Bank Swasta',
        'description' => 'Penjagaan kantor kas.',
        'shift_type' => 'full_time',
        'required_certificate_level' => 'gada_pratama',
        'status' => 'published',
        'published_at' => now(),
    ]);

    // 1. List
    $listResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->getJson('/api/v1/employer/jobs');

    $listResponse->assertOk()
        ->assertJsonCount(1, 'data');

    // 2. Update
    $updateResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->putJson("/api/v1/employer/jobs/{$job->id}", [
            'title' => 'Satpam Bank Swasta Terkemuka',
        ]);

    $updateResponse->assertOk()
        ->assertJsonPath('data.title', 'Satpam Bank Swasta Terkemuka');

    // 3. Pause
    $pauseResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->putJson("/api/v1/employer/jobs/{$job->id}/status", [
            'status' => 'paused',
        ]);

    $pauseResponse->assertOk()
        ->assertJsonPath('data.status', 'paused');

    // 4. Delete
    $deleteResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->deleteJson("/api/v1/employer/jobs/{$job->id}");

    $deleteResponse->assertOk();
    $this->assertSoftDeleted('job_posts', ['id' => $job->id]);
});

test('employer cannot modify job created by another employer', function () {
    $otherEmployerUser = User::factory()->create(['role' => 'employer']);
    $otherProfile = EmployerProfile::create([
        'user_id' => $otherEmployerUser->id,
        'company_name' => 'PT Other BUJP',
        'slug' => 'pt-other-bujp',
    ]);

    $otherJob = JobPost::create([
        'employer_id' => $otherProfile->id,
        'category_id' => $this->category->id,
        'location_id' => $this->location->id,
        'title' => 'Security Mall',
        'description' => 'Job desc',
        'shift_type' => '2_shift',
        'required_certificate_level' => 'none',
        'status' => 'draft',
    ]);

    $response = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->putJson("/api/v1/employer/jobs/{$otherJob->id}", [
            'title' => 'Hijacked Title',
        ]);

    $response->assertForbidden();
});
