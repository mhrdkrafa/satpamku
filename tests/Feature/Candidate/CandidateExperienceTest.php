<?php

use App\Models\CandidateProfile;
use App\Models\Experience;
use App\Models\User;
use App\Models\UserProfile;

beforeEach(function () {
    $this->candidateUser = User::factory()->create([
        'role' => 'candidate',
        'status' => 'active',
    ]);
    UserProfile::create(['user_id' => $this->candidateUser->id]);
    $this->candidateProfile = CandidateProfile::create(['user_id' => $this->candidateUser->id]);
    $this->token = $this->candidateUser->createToken('test')->plainTextToken;
});

test('candidate can create, update, list, and delete experiences', function () {
    // 1. Store experience
    $storePayload = [
        'employer_name' => 'PT Central Security Guard',
        'position' => 'Komandan Regu (Danru)',
        'start_date' => '2022-01-01',
        'end_date' => '2024-01-01',
        'description' => 'Memimpin 15 personil pengamanan area mall.',
        'is_current' => false,
    ];

    $storeResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->postJson('/api/v1/candidate/experiences', $storePayload);

    $storeResponse->assertStatus(201)
        ->assertJson([
            'success' => true,
            'message' => 'Pengalaman kerja berhasil ditambahkan.',
        ]);

    $experienceId = $storeResponse->json('data.id');

    // 2. List experiences
    $listResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->getJson('/api/v1/candidate/experiences');

    $listResponse->assertOk()
        ->assertJsonCount(1, 'data');

    // 3. Update experience
    $updateResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->putJson("/api/v1/candidate/experiences/{$experienceId}", [
            'position' => 'Chief Security Officer',
            'is_current' => true,
        ]);

    $updateResponse->assertOk()
        ->assertJsonPath('data.position', 'Chief Security Officer');

    // 4. Delete experience
    $deleteResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->deleteJson("/api/v1/candidate/experiences/{$experienceId}");

    $deleteResponse->assertOk();
    $this->assertDatabaseMissing('experiences', ['id' => $experienceId]);
});

test('candidate cannot modify experience belonging to another candidate', function () {
    $otherCandidate = User::factory()->create(['role' => 'candidate']);
    $otherProfile = CandidateProfile::create(['user_id' => $otherCandidate->id]);
    $otherExp = Experience::create([
        'candidate_id' => $otherProfile->id,
        'employer_name' => 'PT Other Guard',
        'position' => 'Satpam',
        'start_date' => '2023-01-01',
    ]);

    $response = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->putJson("/api/v1/candidate/experiences/{$otherExp->id}", [
            'position' => 'Hacked Position',
        ]);

    $response->assertForbidden();
});
