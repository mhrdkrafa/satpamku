<?php

use App\Models\User;
use Database\Seeders\CmsSeeder;
use Database\Seeders\SuperAdminSeeder;
use Database\Seeders\TaxonomySeeder;

beforeEach(function () {
    $this->seed(SuperAdminSeeder::class);
    $this->seed(TaxonomySeeder::class);
    $this->seed(CmsSeeder::class);

    $this->superAdmin = User::where('email', 'superadmin@satpamku.id')->first();
    $this->candidate = User::factory()->create(['role' => 'candidate', 'status' => 'active']);
});

test('super admin can access banners in filament', function () {
    $this->actingAs($this->superAdmin)
        ->get('/admin/banners')
        ->assertSuccessful();
});

test('super admin can access career articles in filament', function () {
    $this->actingAs($this->superAdmin)
        ->get('/admin/career-articles')
        ->assertSuccessful();
});

test('super admin can access faqs in filament', function () {
    $this->actingAs($this->superAdmin)
        ->get('/admin/faqs')
        ->assertSuccessful();
});

test('candidate cannot access cms resources in filament', function () {
    $this->actingAs($this->candidate)
        ->get('/admin/banners')
        ->assertForbidden();
});
