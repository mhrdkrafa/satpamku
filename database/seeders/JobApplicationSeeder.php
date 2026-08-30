<?php

namespace Database\Seeders;

use App\Models\CandidateProfile;
use App\Models\JobApplication;
use App\Models\JobPost;
use App\Models\SavedJob;
use Illuminate\Database\Seeder;

class JobApplicationSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $candidates = CandidateProfile::with('user')->get();
        $jobs = JobPost::with('employer')->get();

        if ($candidates->isEmpty() || $jobs->isEmpty()) return;

        $budi = $candidates->firstWhere('user.email', 'budi.santoso@satpamku.id') ?? $candidates->first();
        $bambang = $candidates->firstWhere('user.email', 'bambang.danru@satpamku.id') ?? $candidates->first();
        $siti = $candidates->firstWhere('user.email', 'siti.ladyguard@satpamku.id') ?? $candidates->first();
        $slamet = $candidates->firstWhere('user.email', 'slamet.chief@satpamku.id') ?? $candidates->first();
        $agus = $candidates->firstWhere('user.email', 'agus.setiawan@satpamku.id') ?? $candidates->first();
        $rudi = $candidates->firstWhere('user.email', 'rudi.danru@satpamku.id') ?? $candidates->first();

        $jobSudirman = $jobs->firstWhere('title', 'Satpam Gedung Perkantoran Sudirman (SCBD)') ?? $jobs[0];
        $jobDanru = $jobs->firstWhere('title', 'Komandan Regu (Danru) Kawasan Industri GIIC Cikarang') ?? $jobs[1];
        $jobBank = $jobs->firstWhere('title', 'Security Officer Perbankan & Kantor Kas Menteng') ?? $jobs[2];
        $jobMall = $jobs->firstWhere('title', 'Satpam Mall & Pusat Perbelanjaan Senayan City') ?? $jobs[3];
        $jobLady = $jobs->firstWhere('title', 'Lady Guard (Satpam Wanita) Lobby Apartemen Mega Kuningan') ?? $jobs[4];
        $jobChief = $jobs->firstWhere('title', 'Chief Security Officer Kawasan Terpadu Surabaya Barat') ?? $jobs[5];
        $jobVip = $jobs->firstWhere('title', 'Pengawal VIP & Event Pengamanan Khusus') ?? $jobs[8] ?? $jobs[0];

        $applications = [
            [
                'candidate' => $budi,
                'job' => $jobSudirman,
                'status' => 'interview_scheduled',
                'cover_letter' => 'Dengan pengalaman 4 tahun di kawasan perkantoran Sudirman dan sertifikasi Gada Pratama aktif, saya siap memberikan dedikasi penuh untuk keamanan gedung.',
                'applied_at' => now()->subDays(4),
                'interview_at' => now()->addDays(2)->setHour(9)->setMinute(0),
                'interview_location' => 'Kantor PT Sigap Prima Astrea Lt. 3, Jl. Gaya Motor II No. 1, Sunter II, Jakarta Utara',
                'employer_notes' => 'Harap mengenakan seragam PDH rapi dan membawa KTA serta ijazah asli.',
            ],
            [
                'candidate' => $budi,
                'job' => $jobMall,
                'status' => 'submitted',
                'cover_letter' => 'Saya tertarik dengan posisi satpam mall Senayan City karena lokasi dekat dengan domisili saya.',
                'applied_at' => now()->subDays(1),
            ],
            [
                'candidate' => $bambang,
                'job' => $jobDanru,
                'status' => 'accepted',
                'cover_letter' => 'Pengalaman saya 7 tahun memimpin regu pengamanan pabrik otomotif siap saya terapkan di GIIC Cikarang.',
                'applied_at' => now()->subDays(7),
                'employer_notes' => 'Kandidat sangat kompeten, hasil interview dan tes fisik memuaskan. Siap onboarding tanggal 1 bulan depan.',
            ],
            [
                'candidate' => $siti,
                'job' => $jobLady,
                'status' => 'reviewing',
                'cover_letter' => 'Sebagai Lady Guard bersertifikat Gada Pratama, saya memiliki keahlian body checking dan komunikasi hospitality yang ramah.',
                'applied_at' => now()->subDays(2),
            ],
            [
                'candidate' => $slamet,
                'job' => $jobChief,
                'status' => 'shortlisted',
                'cover_letter' => 'Purnawirawan perwira dengan Ijazah Gada Utama Mabes Polri, berpengalaman memimpin 100+ personil pengamanan terpadu.',
                'applied_at' => now()->subDays(5),
                'employer_notes' => 'Profil sangat kuat, masuk kandidat prioritas untuk tahap wawancara direksi.',
            ],
            [
                'candidate' => $agus,
                'job' => $jobBank,
                'status' => 'submitted',
                'cover_letter' => 'Memiliki sertifikasi Damkar dan pengalaman 3 tahun di cabang perbankan nasional.',
                'applied_at' => now()->subHours(12),
            ],
            [
                'candidate' => $rudi,
                'job' => $jobVip,
                'status' => 'interview_scheduled',
                'cover_letter' => 'Memiliki sertifikat Gada Madya dan pelatihan Bela Diri Polri untuk tugas pengawalan VIP.',
                'applied_at' => now()->subDays(3),
                'interview_at' => now()->addDays(3)->setHour(14)->setMinute(0),
                'interview_location' => 'Kantor PT Nawakara Arta Kencana, Jl. Pemuda No. 71, Rawamangun, Jakarta Timur',
                'employer_notes' => 'Harap membawa perlengkapan tes kesamaptaan fisik dan pakaian olahraga.',
            ],
        ];

        foreach ($applications as $app) {
            JobApplication::updateOrCreate(
                [
                    'job_post_id' => $app['job']->id,
                    'candidate_id' => $app['candidate']->id,
                ],
                [
                    'status' => $app['status'],
                    'cover_letter' => $app['cover_letter'],
                    'applied_at' => $app['applied_at'],
                    'interview_at' => $app['interview_at'] ?? null,
                    'interview_location' => $app['interview_location'] ?? null,
                    'employer_notes' => $app['employer_notes'] ?? null,
                ]
            );

            $app['job']->increment('applications_count');
        }

        // Seed Bookmarked / Saved Jobs for candidates
        if ($budi && $jobBank) {
            SavedJob::firstOrCreate(['candidate_id' => $budi->id, 'job_post_id' => $jobBank->id]);
        }
        if ($budi && $jobVip) {
            SavedJob::firstOrCreate(['candidate_id' => $budi->id, 'job_post_id' => $jobVip->id]);
        }
        if ($agus && $jobSudirman) {
            SavedJob::firstOrCreate(['candidate_id' => $agus->id, 'job_post_id' => $jobSudirman->id]);
        }
    }
}
