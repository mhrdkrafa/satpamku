<?php

use App\Models\User;
use Illuminate\Support\Facades\Hash;

test('user can login with valid email and password', function () {
    $user = User::factory()->create([
        'email' => 'user@satpamku.id',
        'phone' => '081234567891',
        'password' => Hash::make('Password123!'),
        'role' => 'candidate',
        'status' => 'active',
    ]);

    $response = $this->postJson('/api/v1/auth/login', [
        'login' => 'user@satpamku.id',
        'password' => 'Password123!',
    ]);

    $response->assertOk()
        ->assertJson([
            'success' => true,
            'message' => 'Login berhasil.',
        ])
        ->assertJsonStructure([
            'data' => [
                'user' => ['id', 'email', 'role'],
                'token',
            ],
        ]);
});

test('user can login with valid phone number and password', function () {
    $user = User::factory()->create([
        'email' => 'phoneuser@satpamku.id',
        'phone' => '089988776655',
        'password' => Hash::make('Password123!'),
        'role' => 'candidate',
        'status' => 'active',
    ]);

    $response = $this->postJson('/api/v1/auth/login', [
        'login' => '089988776655',
        'password' => 'Password123!',
    ]);

    $response->assertOk()
        ->assertJson([
            'success' => true,
            'message' => 'Login berhasil.',
        ]);
});

test('login fails with invalid password', function () {
    User::factory()->create([
        'email' => 'valid@satpamku.id',
        'password' => Hash::make('CorrectPassword123!'),
    ]);

    $response = $this->postJson('/api/v1/auth/login', [
        'login' => 'valid@satpamku.id',
        'password' => 'WrongPassword!',
    ]);

    $response->assertStatus(422)
        ->assertJsonValidationErrors(['login']);
});

test('authenticated user can view me profile and logout', function () {
    $user = User::factory()->create([
        'email' => 'authme@satpamku.id',
        'role' => 'candidate',
        'status' => 'active',
    ]);

    $token = $user->createToken('test_token')->plainTextToken;

    // Test /me
    $meResponse = $this->withHeader('Authorization', "Bearer {$token}")
        ->getJson('/api/v1/auth/me');

    $meResponse->assertOk()
        ->assertJson([
            'success' => true,
            'data' => [
                'user' => [
                    'email' => 'authme@satpamku.id',
                ],
            ],
        ]);

    // Test /logout
    $logoutResponse = $this->withHeader('Authorization', "Bearer {$token}")
        ->postJson('/api/v1/auth/logout');

    $logoutResponse->assertOk()
        ->assertJson([
            'success' => true,
            'message' => 'Logout berhasil.',
        ]);

    // After logout, token should be invalid
    $this->flushHeaders();
    auth()->forgetGuards();

    $meAfterLogout = $this->withHeader('Authorization', "Bearer {$token}")
        ->getJson('/api/v1/auth/me');

    $meAfterLogout->assertStatus(401);
});

test('authenticated user can change password', function () {
    $user = User::factory()->create([
        'password' => Hash::make('OldPassword123!'),
    ]);

    $token = $user->createToken('test')->plainTextToken;

    $response = $this->withHeader('Authorization', "Bearer {$token}")
        ->putJson('/api/v1/auth/change-password', [
            'current_password' => 'OldPassword123!',
            'new_password' => 'BrandNewPassword123!',
            'new_password_confirmation' => 'BrandNewPassword123!',
        ]);

    $response->assertOk()
        ->assertJson([
            'success' => true,
            'message' => 'Kata sandi berhasil diperbarui.',
        ]);

    $user->refresh();
    expect(Hash::check('BrandNewPassword123!', $user->password))->toBeTrue();
});
