<?php

use App\Models\CandidateProfile;
use App\Models\Certification;
use App\Models\User;
use App\Models\UserProfile;
use Database\Seeders\TaxonomySeeder;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

beforeEach(function () {
    $this->seed(TaxonomySeeder::class);
    Storage::fake('private_documents');

    $this->candidateUser = User::factory()->create([
        'role' => 'candidate',
        'status' => 'active',
    ]);
    UserProfile::create(['user_id' => $this->candidateUser->id]);
    $this->candidateProfile = CandidateProfile::create(['user_id' => $this->candidateUser->id]);
    $this->token = $this->candidateUser->createToken('test')->plainTextToken;
});

test('candidate can upload certification to private storage and download it', function () {
    $certType = Certification::first();
    $file = UploadedFile::fake()->create('sertifikat_gada_pratama.pdf', 500, 'application/pdf');

    $uploadResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->postJson('/api/v1/candidate/certifications', [
            'certification_id' => $certType->id,
            'certificate_number' => 'GP-2024-9988',
            'issued_at' => '2023-01-10',
            'expires_at' => '2027-01-10',
            'document' => $file,
        ]);

    $uploadResponse->assertStatus(201)
        ->assertJson([
            'success' => true,
            'message' => 'Sertifikat berhasil diunggah dan menunggu verifikasi admin.',
        ]);

    $certId = $uploadResponse->json('data.id');

    // Verify file exists on private_documents disk
    $certRecord = $this->candidateProfile->certifications()->find($certId);
    expect($certRecord)->not->toBeNull();
    Storage::disk('private_documents')->assertExists($certRecord->document_path);

    // Test download by owner
    $downloadResponse = $this->withHeader('Authorization', "Bearer {$this->token}")
        ->get("/api/v1/candidate/certifications/{$certId}/file");

    $downloadResponse->assertOk();

    // Test download by unauthorized candidate
    $this->flushHeaders();
    auth()->forgetGuards();

    $strangerCandidate = User::factory()->create(['role' => 'candidate', 'status' => 'active']);
    $strangerToken = $strangerCandidate->createToken('stranger')->plainTextToken;

    $strangerResponse = $this->withHeader('Authorization', "Bearer {$strangerToken}")
        ->get("/api/v1/candidate/certifications/{$certId}/file");

    $strangerResponse->assertForbidden();
});
