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
        'company_name' => 'PT Satria Bhayangkara',
        'slug' => 'pt-satria-bhayangkara',
    ]);

    $this->categoryRetail = JobCategory::where('slug', 'retail')->first();
    $this->categoryVip = JobCategory::where('slug', 'vip')->first();
    $this->locationJakarta = Location::where('slug', 'jakarta-selatan')->first();
    $this->locationBandung = Location::where('slug', 'kota-bandung')->first();

    // 1. Published Job
    $this->publishedJob = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => $this->categoryRetail->id,
        'location_id' => $this->locationJakarta->id,
        'title' => 'Satpam Mall Grand Indonesia',
        'description' => 'Patroli pengamanan mall dan penanganan ketertiban.',
        'shift_type' => '2_shift',
        'salary_min' => 4500000,
        'salary_max' => 5500000,
        'required_certificate_level' => 'gada_pratama',
        'is_urgent' => true,
        'is_featured' => true,
        'status' => 'published',
        'published_at' => now(),
    ]);

    // 2. Draft Job
    $this->draftJob = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => $this->categoryVip->id,
        'location_id' => $this->locationBandung->id,
        'title' => 'Pengawal Pribadi VIP Bandung (Draft)',
        'description' => 'Pengawalan eksekutif.',
        'shift_type' => 'full_time',
        'status' => 'draft',
    ]);
});

test('public can list and filter published jobs', function () {
    $response = $this->getJson('/api/v1/jobs');

    $response->assertOk()
        ->assertJsonCount(1, 'data');

    // Draft job should not appear
    expect(collect($response->json('data'))->pluck('title'))->not->toContain('Pengawal Pribadi VIP Bandung (Draft)');

    // Filter by keyword
    $searchResponse = $this->getJson('/api/v1/jobs?q=Grand+Indonesia');
    $searchResponse->assertOk()
        ->assertJsonCount(1, 'data');

    // Filter by category
    $catResponse = $this->getJson("/api/v1/jobs?category_slug=retail");
    $catResponse->assertOk()
        ->assertJsonCount(1, 'data');

    // Filter by certificate level
    $certResponse = $this->getJson('/api/v1/jobs?certificate_level=gada_pratama');
    $certResponse->assertOk()
        ->assertJsonCount(1, 'data');
});

test('public can view single published job and view count increments', function () {
    $initialViews = $this->publishedJob->views_count;

    $response = $this->getJson("/api/v1/jobs/{$this->publishedJob->slug}");

    $response->assertOk()
        ->assertJson([
            'success' => true,
            'data' => [
                'id' => $this->publishedJob->id,
                'title' => 'Satpam Mall Grand Indonesia',
                'required_certificate_level' => 'gada_pratama',
            ],
        ]);

    $this->publishedJob->refresh();
    expect($this->publishedJob->views_count)->toBe($initialViews + 1);
});

test('featured and urgent endpoints return highlighted jobs', function () {
    $featured = $this->getJson('/api/v1/jobs/featured');
    $featured->assertOk()
        ->assertJsonCount(1, 'data');

    $urgent = $this->getJson('/api/v1/jobs/urgent');
    $urgent->assertOk()
        ->assertJsonCount(1, 'data');
});
