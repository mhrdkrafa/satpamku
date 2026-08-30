<?php

namespace App\Console\Commands;

use App\Models\CandidateCertification;
use Illuminate\Console\Command;
use Illuminate\Support\Carbon;

class CheckCertificateExpiry extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'satpamku:check-certificate-expiry';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Check expiring and expired security certifications and trigger notifications.';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $today = Carbon::today();
        $thirtyDaysAhead = $today->copy()->addDays(30);

        // 1. Mark expired certificates
        $expiredCount = CandidateCertification::whereNotNull('expires_at')
            ->where('expires_at', '<', $today)
            ->where('verification_status', '!=', 'expired')
            ->update([
                'verification_status' => 'expired',
            ]);

        $this->info("Updated {$expiredCount} certifications to 'expired' status.");

        // 2. Find certificates expiring within 30 days
        $expiringCerts = CandidateCertification::with(['candidate.user', 'certification'])
            ->whereNotNull('expires_at')
            ->whereBetween('expires_at', [$today, $thirtyDaysAhead])
            ->whereIn('verification_status', ['verified', 'pending'])
            ->get();

        $this->info("Found {$expiringCerts->count()} certifications expiring in the next 30 days.");

        foreach ($expiringCerts as $cert) {
            $daysLeft = $today->diffInDays($cert->expires_at, false);
            $candidateName = $cert->candidate?->user?->name ?? 'Candidate #' . $cert->candidate_id;
            $certName = $cert->certification?->name ?? 'Sertifikat Satpam';

            $this->line(" - Reminder: [{$candidateName}] {$certName} kadaluarsa dalam {$daysLeft} hari ({$cert->expires_at->format('Y-m-d')}).");
        }

        return Command::SUCCESS;
    }
}
