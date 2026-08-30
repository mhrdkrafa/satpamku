<?php

namespace App\Filament\Widgets;

use App\Models\CandidateCertification;
use App\Models\CandidateProfile;
use App\Models\EmployerProfile;
use App\Models\JobPost;
use App\Models\User;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverviewWidget extends BaseWidget
{
    protected static ?int $sort = 1;

    protected function getStats(): array
    {
        $totalCandidates = User::where('role', 'candidate')->count();
        $verifiedCerts = CandidateCertification::where('status', 'verified')->count();
        $totalEmployers = EmployerProfile::count();
        $activeJobs = JobPost::where('status', 'published')->count();
        $pendingVerifications = CandidateCertification::where('status', 'pending')->count();

        return [
            Stat::make('Total Kandidat Satpam', $totalCandidates)
                ->description('Personil terdaftar di platform')
                ->descriptionIcon('heroicon-m-user-group')
                ->color('primary'),

            Stat::make('Sertifikasi Gada Terverifikasi', $verifiedCerts)
                ->description('Ijazah & KTA tervalidasi')
                ->descriptionIcon('heroicon-m-check-badge')
                ->color('success'),

            Stat::make('Perusahaan BUJP', $totalEmployers)
                ->description('Penyedia jasa pengamanan terdaftar')
                ->descriptionIcon('heroicon-m-building-office')
                ->color('info'),

            Stat::make('Lowongan Satpam Tayang', $activeJobs)
                ->description('Lowongan aktif dipublikasikan')
                ->descriptionIcon('heroicon-m-briefcase')
                ->color('warning'),

            Stat::make('Menunggu Verifikasi Dokumen', $pendingVerifications)
                ->description('KTA/Ijazah butuh tinjauan admin')
                ->descriptionIcon('heroicon-m-clock')
                ->color($pendingVerifications > 0 ? 'danger' : 'gray'),
        ];
    }
}
