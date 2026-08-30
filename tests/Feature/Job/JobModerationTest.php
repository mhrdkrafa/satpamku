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

    $this->adminUser = User::factory()->create(['role' => 'super_admin', 'status' => 'active']);
    $this->adminToken = $this->adminUser->createToken('admin')->plainTextToken;

    $this->employerUser = User::factory()->create(['role' => 'employer', 'status' => 'active']);
    UserProfile::create(['user_id' => $this->employerUser->id]);
    $this->employerProfile = EmployerProfile::create([
        'user_id' => $this->employerUser->id,
        'company_name' => 'PT Mitra Guard',
        'slug' => 'pt-mitra-guard',
    ]);
    $this->employerToken = $this->employerUser->createToken('employer')->plainTextToken;

    $this->category = JobCategory::first();
    $this->location = Location::where('type', 'city')->first();

    $this->reviewJob = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => $this->category->id,
        'location_id' => $this->location->id,
        'title' => 'Lowongan Satpam Menunggu Review',
        'description' => 'Deskripsi pekerjaan satpam.',
        'shift_type' => '2_shift',
        'required_certificate_level' => 'gada_pratama',
        'status' => 'review',
    ]);
});

test('admin can approve and publish a job posting', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->adminToken}")
        ->putJson("/api/v1/employer/jobs/{$this->reviewJob->id}/status", [
            'status' => 'published',
        ]);

    $response->assertOk()
        ->assertJsonPath('data.status', 'published');

    $this->reviewJob->refresh();
    expect($this->reviewJob->status)->toBe('published');
    expect($this->reviewJob->moderated_by)->toBe($this->adminUser->id);
});

test('admin can reject a job posting with reason', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->adminToken}")
        ->putJson("/api/v1/employer/jobs/{$this->reviewJob->id}/status", [
            'status' => 'rejected',
            'rejection_reason' => 'Deskripsi pekerjaan tidak lengkap dan alamat penempatan belum valid.',
        ]);

    $response->assertOk()
        ->assertJsonPath('data.status', 'rejected')
        ->assertJsonPath('data.rejection_reason', 'Deskripsi pekerjaan tidak lengkap dan alamat penempatan belum valid.');

    $this->reviewJob->refresh();
    expect($this->reviewJob->status)->toBe('rejected');
});

test('candidate user cannot publish or reject jobs', function () {
    $candidateUser = User::factory()->create(['role' => 'candidate']);
    $candidateToken = $candidateUser->createToken('cand')->plainTextToken;

    $response = $this->withHeader('Authorization', "Bearer {$candidateToken}")
        ->putJson("/api/v1/employer/jobs/{$this->reviewJob->id}/status", [
            'status' => 'published',
        ]);

    $response->assertForbidden();
});
