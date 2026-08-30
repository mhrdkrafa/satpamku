<?php

use App\Models\User;

test('super admin exists in database after seeding', function () {
    $this->seed(\Database\Seeders\SuperAdminSeeder::class);

    $this->assertDatabaseHas('users', [
        'email' => 'superadmin@satpamku.id',
        'role' => 'super_admin',
        'status' => 'active',
    ]);
});

test('super admin can access filament admin panel', function () {
    $this->seed(\Database\Seeders\SuperAdminSeeder::class);

    $superAdmin = User::where('email', 'superadmin@satpamku.id')->first();
    expect($superAdmin)->not->toBeNull();
    expect($superAdmin->isSuperAdmin())->toBeTrue();
    expect($superAdmin->isAdmin())->toBeTrue();
    expect($superAdmin->canAccessPanel(filament()->getPanel('admin')))->toBeTrue();
});

test('candidate user cannot access filament admin panel', function () {
    $candidate = User::factory()->create([
        'role' => 'candidate',
        'status' => 'active',
    ]);

    expect($candidate->isCandidate())->toBeTrue();
    expect($candidate->isAdmin())->toBeFalse();
    expect($candidate->canAccessPanel(filament()->getPanel('admin')))->toBeFalse();
});
