<?php

namespace App\Notifications;

use App\Models\JobApplication;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class ApplicationStatusNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public JobApplication $application,
        public string $status
    ) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        $jobTitle = $this->application->jobPost->title;
        $companyName = $this->application->jobPost->employer->company_name ?? 'Perusahaan BUJP';

        $title = match ($this->status) {
            'reviewing' => "Lamaran Anda Sedang Ditinjau",
            'shortlisted' => "Selamat! Anda Masuk Daftar Kandidat Terpilih",
            'interview_scheduled' => "Undangan Interview: {$jobTitle}",
            'accepted' => "Selamat! Anda Diterima Bekerja di {$companyName}",
            'rejected' => "Status Lamaran: {$jobTitle}",
            default => "Update Status Lamaran: {$jobTitle}",
        };

        $message = match ($this->status) {
            'reviewing' => "Berkas kualifikasi dan sertifikat Anda sedang diperiksa oleh tim HRD {$companyName}.",
            'shortlisted' => "Profil Anda terpilih untuk lowongan {$jobTitle}. Tunggu kabar jadwal wawancara.",
            'interview_scheduled' => "Jadwal interview Anda telah ditentukan. Periksa rincian waktu dan lokasi pertemuan.",
            'accepted' => "Anda telah resmi dinyatakan diterima untuk posisi {$jobTitle}. Harap periksa instruksi lanjutan.",
            'rejected' => "Terima kasih atas partisipasi Anda. Saat ini kualifikasi Anda belum sesuai untuk lowongan ini.",
            default => "Status lamaran Anda telah diperbarui menjadi {$this->status}.",
        };

        return [
            'type' => 'application_status',
            'application_id' => $this->application->id,
            'job_id' => $this->application->job_post_id,
            'job_title' => $jobTitle,
            'company_name' => $companyName,
            'status' => $this->status,
            'title' => $title,
            'message' => $message,
            'interview_at' => $this->application->interview_at?->toIso8601String(),
            'interview_location' => $this->application->interview_location,
        ];
    }
}
