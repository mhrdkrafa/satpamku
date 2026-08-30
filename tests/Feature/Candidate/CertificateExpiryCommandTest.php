<?php

use App\Models\CandidateCertification;
use App\Models\CandidateProfile;
use App\Models\Certification;
use App\Models\User;
use App\Models\UserProfile;
use Database\Seeders\TaxonomySeeder;
use Illuminate\Support\Carbon;

beforeEach(function () {
    $this->seed(TaxonomySeeder::class);

    $this->candidateUser = User::factory()->create(['role' => 'candidate']);
    UserProfile::create(['user_id' => $this->candidateUser->id]);
    $this->candidateProfile = CandidateProfile::create(['user_id' => $this->candidateUser->id]);
});

test('command marks overdue certifications as expired', function () {
    $cert = Certification::first();

    // Already expired certificate
    $expiredCert = CandidateCertification::create([
        'candidate_id' => $this->candidateProfile->id,
        'certification_id' => $cert->id,
        'document_path' => 'certifications/old.pdf',
        'issued_at' => Carbon::now()->subYears(3),
        'expires_at' => Carbon::now()->subDays(5),
        'verification_status' => 'verified',
    ]);

    // Active certificate expiring in 15 days
    $expiringSoonCert = CandidateCertification::create([
        'candidate_id' => $this->candidateProfile->id,
        'certification_id' => $cert->id,
        'document_path' => 'certifications/soon.pdf',
        'issued_at' => Carbon::now()->subYears(1),
        'expires_at' => Carbon::now()->addDays(15),
        'verification_status' => 'verified',
    ]);

    $this->artisan('satpamku:check-certificate-expiry')
        ->expectsOutputToContain("Updated 1 certifications to 'expired' status.")
        ->expectsOutputToContain("Found 1 certifications expiring in the next 30 days.")
        ->assertSuccessful();

    $expiredCert->refresh();
    expect($expiredCert->verification_status)->toBe('expired');

    $expiringSoonCert->refresh();
    expect($expiringSoonCert->verification_status)->toBe('verified');
});
