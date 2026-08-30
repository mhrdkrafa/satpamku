<?php

use App\Models\CandidateProfile;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

beforeEach(function () {
    Storage::fake('private_documents');

    $this->candidateUser = User::factory()->create([
        'role' => 'candidate',
        'status' => 'active',
    ]);
    $this->userProfile = UserProfile::create([
        'user_id' => $this->candidateUser->id,
        'profile_visibility' => 'public',
    ]);
    $this->candidateProfile = CandidateProfile::create(['user_id' => $this->candidateUser->id]);
    $this->token = $this->candidateUser->createToken('test')->plainTextToken;
});

test('candidate can upload CV and document to private disk', function () {
    $file = UploadedFile::fake()->create('cv_satpam_budi.pdf', 800, 'application/pdf');

    $response = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->postJson('/api/v1/candidate/documents', [
            'type' => 'cv',
            'title' => 'Curriculum Vitae 2024',
            'document' => $file,
        ]);

    $response->assertStatus(201)
        ->assertJson([
            'success' => true,
            'message' => 'Dokumen berhasil diunggah.',
        ]);

    $docId = $response->json('data.id');
    $doc = $this->candidateProfile->documents()->find($docId);

    Storage::disk('private_documents')->assertExists($doc->path);

    // Download document by owner
    $download = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->get("/api/v1/candidate/documents/{$docId}/file");

    $download->assertOk();
});

test('candidate can update visibility and view full resume', function () {
    // 1. Update visibility to employers_only
    $visResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->putJson('/api/v1/candidate/visibility', [
            'profile_visibility' => 'employers_only',
        ]);

    $visResponse->assertOk()
        ->assertJsonPath('data.profile_visibility', 'employers_only');

    // 2. View resume
    $resumeResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->getJson('/api/v1/candidate/resume');

    $resumeResponse->assertOk()
        ->assertJsonStructure([
            'data' => [
                'id',
                'name',
                'email',
                'experiences',
                'skills',
                'certifications',
                'documents',
            ],
        ]);
});
