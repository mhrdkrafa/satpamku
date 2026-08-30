<?php

use App\Models\CandidateProfile;
use App\Models\EmployerProfile;
use App\Models\JobApplication;
use App\Models\JobCategory;
use App\Models\JobPost;
use App\Models\Location;
use App\Models\User;
use App\Models\UserProfile;
use Database\Seeders\TaxonomySeeder;

beforeEach(function () {
    $this->seed(TaxonomySeeder::class);

    $this->candidateUser = User::factory()->create(['role' => 'candidate', 'status' => 'active']);
    UserProfile::create(['user_id' => $this->candidateUser->id]);
    $this->candidateProfile = CandidateProfile::create(['user_id' => $this->candidateUser->id]);
    $this->candidateToken = $this->candidateUser->createToken('cand')->plainTextToken;

    $this->employerUser = User::factory()->create(['role' => 'employer', 'status' => 'active']);
    UserProfile::create(['user_id' => $this->employerUser->id]);
    $this->employerProfile = EmployerProfile::create([
        'user_id' => $this->employerUser->id,
        'company_name' => 'PT Jaya Mandiri Guard',
        'slug' => 'pt-jaya-mandiri-guard',
    ]);

    $this->category = JobCategory::first();
    $this->location = Location::where('type', 'city')->first();

    $this->job = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => $this->category->id,
        'location_id' => $this->location->id,
        'title' => 'Satpam Gedung Kantor Sudirman',
        'description' => 'Tugas pengamanan pintu masuk.',
        'shift_type' => 'full_time',
        'required_certificate_level' => 'gada_pratama',
        'status' => 'published',
        'published_at' => now(),
    ]);
});

test('candidate can apply to a published job', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->postJson("/api/v1/jobs/{$this->job->id}/apply", [
            'cover_letter' => 'Saya memiliki sertifikat Gada Pratama dan siap ditempatkan segera.',
        ]);

    $response->assertStatus(201)
        ->assertJson([
            'success' => true,
            'message' => 'Lamaran berhasil dikirim ke perusahaan.',
        ])
        ->assertJsonPath('data.status', 'submitted');

    $this->assertDatabaseHas('job_applications', [
        'job_post_id' => $this->job->id,
        'candidate_id' => $this->candidateProfile->id,
        'status' => 'submitted',
    ]);

    $this->job->refresh();
    expect($this->job->applications_count)->toBe(1);
});

test('candidate cannot apply twice to the same job', function () {
    JobApplication::create([
        'job_post_id' => $this->job->id,
        'candidate_id' => $this->candidateProfile->id,
        'status' => 'submitted',
    ]);

    $response = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->postJson("/api/v1/jobs/{$this->job->id}/apply");

    $response->assertStatus(422)
        ->assertJsonPath('message', 'Anda sudah pernah melamar ke lowongan ini sebelumnya.');
});

test('candidate can save, unsave, and list saved jobs', function () {
    // 1. Save
    $saveResponse = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->postJson("/api/v1/jobs/{$this->job->id}/save");

    $saveResponse->assertOk()
        ->assertJsonPath('data.is_saved', true);

    // 2. List saved jobs
    $listResponse = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->getJson('/api/v1/candidate/saved-jobs');

    $listResponse->assertOk()
        ->assertJsonCount(1, 'data');

    // 3. Unsave
    $unsaveResponse = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->postJson("/api/v1/jobs/{$this->job->id}/save");

    $unsaveResponse->assertOk()
        ->assertJsonPath('data.is_saved', false);
});

test('candidate can list their applications and withdraw', function () {
    $app = JobApplication::create([
        'job_post_id' => $this->job->id,
        'candidate_id' => $this->candidateProfile->id,
        'status' => 'submitted',
        'applied_at' => now(),
    ]);

    // List
    $list = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->getJson('/api/v1/candidate/applications');

    $list->assertOk()
        ->assertJsonCount(1, 'data');

    // Withdraw
    $withdraw = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->postJson("/api/v1/candidate/applications/{$app->id}/withdraw");

    $withdraw->assertOk()
        ->assertJsonPath('data.status', 'withdrawn');

    $app->refresh();
    expect($app->status)->toBe('withdrawn');
});
