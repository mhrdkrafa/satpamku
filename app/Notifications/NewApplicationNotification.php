<?php

namespace App\Notifications;

use App\Models\JobApplication;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Notification;

class NewApplicationNotification extends Notification implements ShouldQueue
{
    use Queueable;

    public function __construct(
        public JobApplication $application
    ) {}

    public function via(object $notifiable): array
    {
        return ['database'];
    }

    public function toArray(object $notifiable): array
    {
        $candidateName = $this->application->candidate->user->name ?? 'Kandidat Satpam';
        $jobTitle = $this->application->jobPost->title;
        $certLevel = $this->application->candidate->highest_certificate_level;

        return [
            'type' => 'new_application',
            'application_id' => $this->application->id,
            'job_id' => $this->application->job_post_id,
            'job_title' => $jobTitle,
            'candidate_id' => $this->application->candidate_id,
            'candidate_name' => $candidateName,
            'certificate_level' => $certLevel,
            'title' => "Pelamar Baru: {$candidateName}",
            'message' => "Kandidat {$candidateName} (Kualifikasi: {$certLevel}) baru saja melamar posisi {$jobTitle}.",
        ];
    }
}
