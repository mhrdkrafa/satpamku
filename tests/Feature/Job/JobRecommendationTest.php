<?php

use App\Models\CandidateProfile;
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
        'company_name' => 'PT Bravo Security',
    ]);

    $this->location = Location::where('type', 'city')->first();
    $this->category = JobCategory::first();

    // Job 1: Requires Gada Pratama, min height 168 cm, high salary
    $this->job1 = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => $this->category->id,
        'location_id' => $this->location->id,
        'title' => 'Satpam Gedung Perkantoran Sudirman',
        'description' => 'Patroli dan pengawasan gedung perkantoran.',
        'shift_type' => '3_shift',
        'required_certificate_level' => 'gada_pratama',
        'min_height_cm' => 168,
        'min_weight_kg' => 60,
        'salary_min' => 5200000,
        'salary_max' => 6000000,
        'status' => 'published',
        'published_at' => now(),
    ]);

    // Job 2: Requires Gada Utama (Manager), very strict
    $this->job2 = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => $this->category->id,
        'location_id' => $this->location->id,
        'title' => 'Chief Security Officer Kawasan Industri',
        'description' => 'Memimpin seluruh divisi keamanan kawasan industri.',
        'shift_type' => 'full_time',
        'required_certificate_level' => 'gada_utama',
        'min_height_cm' => 175,
        'status' => 'published',
        'published_at' => now(),
    ]);

    // Candidate with Gada Pratama, 172cm height, matching location
    $this->candidateUser = User::factory()->create(['role' => 'candidate', 'status' => 'active']);
    UserProfile::create(['user_id' => $this->candidateUser->id, 'location_id' => $this->location->id]);
    $this->candidateProfile = CandidateProfile::create([
        'user_id' => $this->candidateUser->id,
        'highest_certificate_level' => 'gada_pratama',
        'height_cm' => 172,
        'weight_kg' => 66,
        'preferred_city_id' => $this->location->id,
        'has_sim_c' => true,
    ]);
    $this->candidateToken = $this->candidateUser->createToken('cand')->plainTextToken;
});

test('candidate receives explainable recommendations with high match score on matching job', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->getJson('/api/v1/candidate/recommendations');

    $response->assertOk()
        ->assertJsonStructure([
            'success',
            'data' => [
                '*' => [
                    'id',
                    'title',
                    'match_score',
                    'match_reasons',
                    'match_breakdown',
                ],
            ],
        ]);

    $data = $response->json('data');
    expect(count($data))->toBe(2);

    // Job 1 should have higher score than Job 2
    $topJob = $data[0];
    expect($topJob['id'])->toBe($this->job1->id)
        ->and($topJob['match_score'])->toBeGreaterThanOrEqual(80)
        ->and($topJob['match_reasons'])->toContain('Ijazah Gada pratama memenuhi kualifikasi lowongan');
});
