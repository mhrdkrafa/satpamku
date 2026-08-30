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

    // Employer
    $this->employerUser = User::factory()->create(['role' => 'employer', 'status' => 'active']);
    UserProfile::create(['user_id' => $this->employerUser->id]);
    $this->employerProfile = EmployerProfile::create([
        'user_id' => $this->employerUser->id,
        'company_name' => 'PT Cakra Garda Nusantara',
        'slug' => 'pt-cakra-garda-nusantara',
    ]);
    $this->employerToken = $this->employerUser->createToken('emp')->plainTextToken;

    // Candidate
    $this->candidateUser = User::factory()->create(['role' => 'candidate', 'status' => 'active']);
    UserProfile::create(['user_id' => $this->candidateUser->id]);
    $this->candidateProfile = CandidateProfile::create([
        'user_id' => $this->candidateUser->id,
        'highest_certificate_level' => 'gada_pratama',
        'height_cm' => 173,
        'weight_kg' => 68,
    ]);
    $this->candidateToken = $this->candidateUser->createToken('cand')->plainTextToken;

    $this->category = JobCategory::first();
    $this->location = Location::where('type', 'city')->first();

    $this->job = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => $this->category->id,
        'location_id' => $this->location->id,
        'title' => 'Chief Security Officer Plaza Indonesia',
        'description' => 'Memimpin seluruh regu pengamanan.',
        'shift_type' => 'full_time',
        'required_certificate_level' => 'gada_madya',
        'status' => 'published',
        'published_at' => now(),
    ]);

    $this->application = JobApplication::create([
        'job_post_id' => $this->job->id,
        'candidate_id' => $this->candidateProfile->id,
        'cover_letter' => 'Saya berpengalaman memimpin regu.',
        'status' => 'submitted',
        'applied_at' => now(),
    ]);
});

test('employer can view dashboard metrics and recent applicants', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->employerToken}")
        ->getJson('/api/v1/employer/dashboard');

    $response->assertOk()
        ->assertJsonPath('data.metrics.active_jobs', 1)
        ->assertJsonPath('data.metrics.total_applicants', 1)
        ->assertJsonCount(1, 'data.recent_applicants');
});

test('employer can list applicants and filter by status', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->employerToken}")
        ->getJson('/api/v1/employer/applicants?status=submitted');

    $response->assertOk()
        ->assertJsonCount(1, 'data')
        ->assertJsonPath('data.0.status', 'submitted');
});

test('employer can view applicant dossier', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->employerToken}")
        ->getJson("/api/v1/employer/applicants/{$this->application->id}");

    $response->assertOk()
        ->assertJsonPath('data.candidate.name', $this->candidateUser->name)
        ->assertJsonPath('data.candidate.height_cm', 173);
});

test('employer can transition applicant status and schedule interview', function () {
    $interviewDate = now()->addDays(3)->format('Y-m-d H:i:s');

    $response = $this->withHeader('Authorization', "Bearer {$this->employerToken}")
        ->putJson("/api/v1/employer/applicants/{$this->application->id}/status", [
            'status' => 'interview_scheduled',
            'interview_at' => $interviewDate,
            'interview_location' => 'Kantor PT Cakra Lt. 5, Jl. Rasuna Said Kav. 10',
            'employer_notes' => 'Harap membawa KTA dan ijazah asli.',
        ]);

    $response->assertOk()
        ->assertJsonPath('data.status', 'interview_scheduled');

    $this->application->refresh();
    expect($this->application->status)->toBe('interview_scheduled')
        ->and($this->application->interview_location)->toBe('Kantor PT Cakra Lt. 5, Jl. Rasuna Said Kav. 10');
});

test('candidate cannot access employer applicant endpoints', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->getJson('/api/v1/employer/dashboard');

    $response->assertStatus(403);
});
