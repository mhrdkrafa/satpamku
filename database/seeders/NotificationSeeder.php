<?php

namespace Database\Seeders;

use App\Models\DeviceToken;
use App\Models\JobApplication;
use App\Models\User;
use App\Notifications\ApplicationStatusNotification;
use App\Notifications\CertificateExpiryNotification;
use App\Notifications\NewApplicationNotification;
use Illuminate\Database\Seeder;

class NotificationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $budiUser = User::where('email', 'budi.santoso@satpamku.id')->first();
        $bambangUser = User::where('email', 'bambang.danru@satpamku.id')->first();
        $sigapUser = User::where('email', 'hrd@sigap.co.id')->first();
        $nawakaraUser = User::where('email', 'karir@nawakara.com')->first();

        // Seed Device Tokens
        $users = User::all();
        foreach ($users as $u) {
            DeviceToken::firstOrCreate(
                [
                    'user_id' => $u->id,
                    'fcm_token' => 'fcm_token_sample_' . $u->id . '_' . md5($u->email),
                ],
                [
                    'device_type' => 'android',
                    'last_used_at' => now(),
                ]
            );
        }

        // Seed In-App Notifications
        if ($budiUser) {
            $appInterview = JobApplication::whereHas('candidate.user', fn($q) => $q->where('id', $budiUser->id))
                ->where('status', 'interview_scheduled')
                ->first();

            if ($appInterview) {
                $budiUser->notify(new ApplicationStatusNotification($appInterview, 'interview_scheduled'));
            }

            // Also send a certificate reminder if candidate has a certification
            $cert = $budiUser->candidateProfile?->certifications()->first();
            if ($cert) {
                $budiUser->notify(new CertificateExpiryNotification($cert, 'near_expiry'));
            }
        }

        if ($bambangUser) {
            $appAccepted = JobApplication::whereHas('candidate.user', fn($q) => $q->where('id', $bambangUser->id))
                ->where('status', 'accepted')
                ->first();

            if ($appAccepted) {
                $bambangUser->notify(new ApplicationStatusNotification($appAccepted, 'accepted'));
            }
        }

        if ($sigapUser) {
            $appSigap = JobApplication::whereHas('jobPost.employer.user', fn($q) => $q->where('id', $sigapUser->id))
                ->first();

            if ($appSigap) {
                $sigapUser->notify(new NewApplicationNotification($appSigap));
            }
        }
    }
}
