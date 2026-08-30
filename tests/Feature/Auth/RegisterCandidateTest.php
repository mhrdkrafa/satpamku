<?php

use App\Models\CandidateProfile;
use App\Models\User;
use App\Models\UserProfile;

test('candidate can register successfully with valid payload', function () {
    $payload = [
        'name' => 'Budi Santoso',
        'email' => 'budi@satpamku.id',
        'phone' => '081298765432',
        'password' => 'Password123!',
        'password_confirmation' => 'Password123!',
        'highest_certificate_level' => 'gada_pratama',
        'city' => 'Jakarta Selatan',
        'device_name' => 'flutter_phone',
    ];

    $response = $this->postJson('/api/v1/auth/register-candidate', $payload);

    $response->assertStatus(201)
        ->assertJson([
            'success' => true,
            'message' => 'Pendaftaran satpam berhasil.',
        ])
        ->assertJsonStructure([
            'success',
            'message',
            'data' => [
                'user' => [
                    'id',
                    'name',
                    'email',
                    'phone',
                    'role',
                    'status',
                    'profile',
                    'candidate_profile',
                ],
                'token',
                'token_type',
            ],
        ]);

    $this->assertDatabaseHas('users', [
        'email' => 'budi@satpamku.id',
        'role' => 'candidate',
        'status' => 'active',
    ]);

    $this->assertDatabaseHas('candidate_profiles', [
        'highest_certificate_level' => 'gada_pratama',
        'preferred_city' => 'Jakarta Selatan',
        'verification_status' => 'unverified',
    ]);
});

test('candidate registration fails with duplicate email or phone', function () {
    User::factory()->create([
        'email' => 'existing@satpamku.id',
        'phone' => '081111111111',
    ]);

    $payload = [
        'name' => 'Another Candidate',
        'email' => 'existing@satpamku.id',
        'phone' => '081111111111',
        'password' => 'Password123!',
        'password_confirmation' => 'Password123!',
    ];

    $response = $this->postJson('/api/v1/auth/register-candidate', $payload);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['email', 'phone']);
});

test('candidate registration fails when password confirmation does not match', function () {
    $payload = [
        'name' => 'Candidate Mismath',
        'email' => 'mismatch@satpamku.id',
        'phone' => '081222222222',
        'password' => 'Password123!',
        'password_confirmation' => 'DifferentPassword!',
    ];

    $response = $this->postJson('/api/v1/auth/register-candidate', $payload);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['password']);
});
