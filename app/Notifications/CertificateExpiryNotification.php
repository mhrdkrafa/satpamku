<?php

namespace App\Notifications;

use App\Models\CandidateCertification;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class CertificateExpiryNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public CandidateCertification $certification,
        public string $alertType // 'near_expiry', 'expired'
    ) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        $certName = $this->certification->certification->name ?? 'Sertifikat Satpam';
        $expiryDate = $this->certification->expiry_date?->format('d M Y');

        if ($this->alertType === 'expired') {
            return [
                'type' => 'certificate_expired',
                'certification_id' => $this->certification->id,
                'title' => "Masa Berlaku {$certName} Telah Berakhir",
                'message' => "Sertifikat {$certName} Anda telah kedaluwarsa pada {$expiryDate}. Segera lakukan perpanjangan KTA/Ijazah.",
            ];
        }

        return [
            'type' => 'certificate_near_expiry',
            'certification_id' => $this->certification->id,
            'title' => "Peringatan Masa Berlaku {$certName}",
            'message' => "Masa berlaku sertifikat {$certName} Anda akan berakhir pada {$expiryDate}. Segera siapkan berkas perpanjangan.",
        ];
    }
}
