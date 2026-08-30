<?php

use App\Models\CandidateProfile;
use App\Models\Skill;
use App\Models\User;
use App\Models\UserProfile;
use Database\Seeders\TaxonomySeeder;

beforeEach(function () {
    $this->seed(TaxonomySeeder::class);

    $this->candidateUser = User::factory()->create([
        'role' => 'candidate',
        'status' => 'active',
    ]);
    UserProfile::create(['user_id' => $this->candidateUser->id]);
    $this->candidateProfile = CandidateProfile::create(['user_id' => $this->candidateUser->id]);
    $this->token = $this->candidateUser->createToken('test')->plainTextToken;
});

test('candidate can sync and list their skills', function () {
    $skills = Skill::take(3)->get();

    $syncPayload = [
        'skills' => [
            ['skill_id' => $skills[0]->id, 'level' => 'advanced'],
            ['skill_id' => $skills[1]->id, 'level' => 'expert'],
        ],
    ];

    $response = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->postJson('/api/v1/candidate/skills/sync', $syncPayload);

    $response->assertOk()
        ->assertJson([
            'success' => true,
            'message' => 'Keahlian satpam berhasil disimpan.',
        ])
        ->assertJsonCount(2, 'data');

    $listResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->getJson('/api/v1/candidate/skills');

    $listResponse->assertOk()
        ->assertJsonCount(2, 'data');
});
