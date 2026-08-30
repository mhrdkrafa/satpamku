<?php

use App\Models\JobCategory;
use App\Models\Location;
use App\Models\User;
use Database\Seeders\TaxonomySeeder;

beforeEach(function () {
    $this->seed(TaxonomySeeder::class);
});

test('super admin can access taxonomy list in filament', function () {
    $admin = User::factory()->create([
        'role' => 'super_admin',
        'status' => 'active',
    ]);

    $this->actingAs($admin)
        ->get('/admin/locations')
        ->assertOk();

    $this->actingAs($admin)
        ->get('/admin/job-categories')
        ->assertOk();

    $this->actingAs($admin)
        ->get('/admin/facilities')
        ->assertOk();

    $this->actingAs($admin)
        ->get('/admin/certifications')
        ->assertOk();
});

test('candidate cannot access taxonomy in filament', function () {
    $candidate = User::factory()->create([
        'role' => 'candidate',
        'status' => 'active',
    ]);

    $this->actingAs($candidate)
        ->get('/admin/locations')
        ->assertForbidden();
});
