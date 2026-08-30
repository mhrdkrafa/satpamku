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
        'company_name' => 'PT Garuda Security',
        'slug' => 'pt-garuda-security',
    ]);
    $this->employerToken = $this->employerUser->createToken('emp')->plainTextToken;

    $this->candidateUser = User::factory()->create(['role' => 'candidate', 'status' => 'active']);
    UserProfile::create(['user_id' => $this->candidateUser->id]);
    $this->candidateProfile = CandidateProfile::create([
        'user_id' => $this->candidateUser->id,
        'highest_certificate_level' => 'gada_pratama',
    ]);
    $this->candidateToken = $this->candidateUser->createToken('cand')->plainTextToken;

    $this->job = JobPost::create([
        'employer_id' => $this->employerProfile->id,
        'category_id' => JobCategory::first()->id,
        'location_id' => Location::where('type', 'city')->first()->id,
        'title' => 'Satpam Bandara Soekarno Hatta',
        'description' => 'Patroli terminal bandara.',
        'shift_type' => '3_shift',
        'required_certificate_level' => 'gada_pratama',
        'status' => 'published',
        'published_at' => now(),
    ]);
});

test('candidate application triggers notification to employer', function () {
    $response = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->postJson("/api/v1/jobs/{$this->job->id}/apply");

    $response->assertStatus(201);

    expect($this->employerUser->unreadNotifications()->count())->toBe(1);
    $notif = $this->employerUser->unreadNotifications()->first();
    expect($notif->data['type'])->toBe('new_application')
        ->and($notif->data['candidate_name'])->toBe($this->candidateUser->name);
});

test('employer status change triggers notification to candidate', function () {
    // 1. Candidate applies
    $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->postJson("/api/v1/jobs/{$this->job->id}/apply");

    $application = $this->candidateProfile->applications()->first();

    // 2. Employer schedules interview
    $this->flushHeaders();
    auth()->forgetGuards();

    $this->withHeader('Authorization', "Bearer {$this->employerToken}")
        ->putJson("/api/v1/employer/applicants/{$application->id}/status", [
            'status' => 'interview_scheduled',
            'interview_at' => now()->addDays(2)->toDateTimeString(),
            'interview_location' => 'Lobby Gedung Garuda',
        ])
        ->assertOk();

    expect($this->candidateUser->unreadNotifications()->count())->toBe(1);
    $notif = $this->candidateUser->unreadNotifications()->first();
    expect($notif->data['type'])->toBe('application_status')
        ->and($notif->data['status'])->toBe('interview_scheduled')
        ->and($notif->data['interview_location'])->toBe('Lobby Gedung Garuda');
});

test('user can list, read, and mark all notifications as read', function () {
    // Generate dummy notification
    $certType = \App\Models\Certification::first();
    $cert = \App\Models\CandidateCertification::create([
        'candidate_id' => $this->candidateProfile->id,
        'certification_id' => $certType->id,
        'certificate_level' => 'gada_pratama',
        'document_path' => 'certifications/test_cert.pdf',
        'expiry_date' => now()->addDays(20),
        'status' => 'verified',
    ]);
    $this->candidateUser->notify(new \App\Notifications\CertificateExpiryNotification(
        $cert,
        'near_expiry'
    ));

    $listResponse = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->getJson('/api/v1/notifications');

    $listResponse->assertOk()
        ->assertJsonPath('data.unread_count', 1);

    $notifId = $listResponse->json('data.items.0.id');

    // Mark single as read
    $readResponse = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->putJson("/api/v1/notifications/{$notifId}/read");

    $readResponse->assertOk();
    expect($this->candidateUser->unreadNotifications()->count())->toBe(0);

    // Mark all as read
    $markAllResponse = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->putJson('/api/v1/notifications/read-all');

    $markAllResponse->assertOk();
});

test('user can register and delete device token', function () {
    $register = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->postJson('/api/v1/device-token', [
            'fcm_token' => 'fcm_token_sample_abc123',
            'device_type' => 'android',
        ]);

    $register->assertOk()
        ->assertJsonPath('data.device_type', 'android');

    $this->assertDatabaseHas('device_tokens', [
        'user_id' => $this->candidateUser->id,
        'fcm_token' => 'fcm_token_sample_abc123',
    ]);

    $delete = $this->withHeader('Authorization', "Bearer {$this->candidateToken}")
        ->deleteJson('/api/v1/device-token', [
            'fcm_token' => 'fcm_token_sample_abc123',
        ]);

    $delete->assertOk();
    $this->assertDatabaseMissing('device_tokens', [
        'fcm_token' => 'fcm_token_sample_abc123',
    ]);
});
