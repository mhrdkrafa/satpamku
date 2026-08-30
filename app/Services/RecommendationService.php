<?php

namespace App\Services;

use App\Models\CandidateProfile;
use App\Models\JobPost;
use Illuminate\Support\Collection;

class RecommendationService
{
    private array $certLevelsHierarchy = [
        'none' => 0,
        'gada_pratama' => 1,
        'gada_madya' => 2,
        'gada_utama' => 3,
    ];

    /**
     * Calculate explainable match score (0-100) between a candidate and a job post.
     */
    public function calculateMatch(CandidateProfile $candidate, JobPost $job): array
    {
        $score = 0;
        $reasons = [];
        $breakdown = [];

        // 1. Certification Match (Max 30 Pts)
        $candLevel = $candidate->highest_certificate_level ?? 'none';
        $jobLevel = $job->required_certificate_level ?? 'none';

        $candRank = $this->certLevelsHierarchy[$candLevel] ?? 0;
        $jobRank = $this->certLevelsHierarchy[$jobLevel] ?? 0;

        if ($jobRank === 0 || $candRank >= $jobRank) {
            $score += 25;
            $breakdown['certification'] = 25;
            if ($candLevel !== 'none') {
                $reasons[] = 'Ijazah ' . ucfirst(str_replace('_', ' ', $candLevel)) . ' memenuhi kualifikasi lowongan';
            }
        } elseif ($candRank > 0 && $candRank < $jobRank) {
            $score += 10;
            $breakdown['certification'] = 10;
        } else {
            $breakdown['certification'] = 0;
        }

        // Verified certificate bonus (+5 pts)
        $hasVerifiedCert = $candidate->certifications()->where('status', 'verified')->exists();
        if ($hasVerifiedCert) {
            $score += 5;
            $breakdown['verified_cert'] = 5;
            $reasons[] = 'Memiliki sertifikat/KTA satpam terverifikasi aktif';
        }

        // 2. Location Match (Max 25 Pts)
        $candidateLocationId = $candidate->preferred_city_id ?? $candidate->preferred_location_id ?? $candidate->user?->profile?->location_id;
        if ($candidateLocationId && $candidateLocationId == $job->location_id) {
            $score += 25;
            $breakdown['location'] = 25;
            $reasons[] = 'Lokasi penempatan (' . ($job->location?->name ?? 'Kota') . ') cocok dengan domisili Anda';
        } elseif ($candidateLocationId) {
            $score += 10;
            $breakdown['location'] = 10;
        } else {
            $score += 15; // default proximity
            $breakdown['location'] = 15;
        }

        // 3. Physical Attributes Match (Max 15 Pts)
        $heightMatch = true;
        $weightMatch = true;

        if ($job->min_height_cm && $candidate->height_cm) {
            $heightMatch = $candidate->height_cm >= $job->min_height_cm;
        }
        if ($job->min_weight_kg && $candidate->weight_kg) {
            $weightMatch = $candidate->weight_kg >= $job->min_weight_kg;
        }

        if ($heightMatch && $weightMatch && ($candidate->height_cm || $candidate->weight_kg)) {
            $score += 15;
            $breakdown['physical'] = 15;
            if ($candidate->height_cm) {
                $reasons[] = "Tinggi badan ({$candidate->height_cm} cm) memenuhi standar fisik minimal";
            }
        } else {
            $breakdown['physical'] = 0;
        }

        // 4. Experience Relevance (Max 15 Pts)
        $expCount = $candidate->experiences()->count();
        if ($expCount >= 2) {
            $score += 15;
            $breakdown['experience'] = 15;
            $reasons[] = "Memiliki riwayat {$expCount} pengalaman kerja di bidang pengamanan";
        } elseif ($expCount === 1) {
            $score += 10;
            $breakdown['experience'] = 10;
            $reasons[] = 'Memiliki pengalaman tugas keamanan sebelumnya';
        } else {
            $breakdown['experience'] = 5;
            $score += 5;
        }

        // 5. Salary Compatibility (Max 10 Pts)
        if ($job->salary_min && $job->salary_min >= 4000000) {
            $score += 10;
            $breakdown['salary'] = 10;
            $reasons[] = 'Tawaran gaji kompetitif dan transparan';
        } else {
            $score += 5;
            $breakdown['salary'] = 5;
        }

        // 6. Driving License Match (Max 5 Pts)
        if ($job->requires_sim) {
            if ($candidate->has_sim_a || $candidate->has_sim_c) {
                $score += 5;
                $breakdown['license'] = 5;
                $reasons[] = 'Memiliki lisensi SIM aktif untuk mobilitas patroli';
            } else {
                $breakdown['license'] = 0;
            }
        } else {
            $score += 5;
            $breakdown['license'] = 5;
        }

        $finalScore = min(100, max(0, $score));

        return [
            'score' => $finalScore,
            'reasons' => $reasons,
            'breakdown' => $breakdown,
        ];
    }

    /**
     * Get top recommended jobs tailored for the candidate.
     */
    public function getRecommendations(CandidateProfile $candidate, int $limit = 10): Collection
    {
        $publishedJobs = JobPost::with(['employer.user.profile', 'category', 'location'])
            ->where('status', 'published')
            ->get();

        $scoredJobs = $publishedJobs->map(function (JobPost $job) use ($candidate) {
            $match = $this->calculateMatch($candidate, $job);
            $job->match_score = $match['score'];
            $job->match_reasons = $match['reasons'];
            $job->match_breakdown = $match['breakdown'];
            return $job;
        });

        return $scoredJobs->sortByDesc('match_score')->values()->take($limit);
    }
}
