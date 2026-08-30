<?php

use App\Models\EmployerProfile;
use App\Models\User;

test('employer can register successfully with valid payload', function () {
    $payload = [
        'name' => 'Hendro Prabowo',
        'email' => 'hr@guardindo.co.id',
        'phone' => '081399887766',
        'password' => 'SecurePass123!',
        'password_confirmation' => 'SecurePass123!',
        'company_name' => 'PT Guard Indonesia Raya',
        'nib' => '1234567890123',
        'bujp_license_number' => 'SIO-BUJP-2024-001',
        'pic_name' => 'Hendro Prabowo',
        'pic_position' => 'Head of Recruitment',
        'city' => 'Jakarta Pusat',
    ];

    $response = $this->postJson('/api/v1/auth/register-employer', $payload);

    $response->assertStatus(201)
        ->assertJson([
            'success' => true,
            'message' => 'Pendaftaran perusahaan/BUJP berhasil.',
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
                    'employer_profile' => [
                        'company_name',
                        'slug',
                        'nib',
                        'verification_status',
                    ],
                ],
                'token',
            ],
        ]);

    $this->assertDatabaseHas('users', [
        'email' => 'hr@guardindo.co.id',
        'role' => 'employer',
    ]);

    $this->assertDatabaseHas('employer_profiles', [
        'company_name' => 'PT Guard Indonesia Raya',
        'slug' => 'pt-guard-indonesia-raya',
        'verification_status' => 'unverified',
    ]);
});
