<?php

namespace Database\Seeders;

use App\Models\CandidateCertification;
use App\Models\CandidateDocument;
use App\Models\CandidateProfile;
use App\Models\Certification;
use App\Models\Experience;
use App\Models\Location;
use App\Models\Skill;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class CandidateSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $cityJakarta = Location::where('slug', 'kota-jakarta-selatan')->first() ?? Location::first();
        $cityBekasi = Location::where('slug', 'kota-bekasi')->first() ?? $cityJakarta;
        $cityBandung = Location::where('slug', 'kota-bandung')->first() ?? $cityJakarta;

        $certPratama = Certification::where('level', 'gada_pratama')->first() ?? Certification::first();
        $certMadya = Certification::where('level', 'gada_madya')->first() ?? $certPratama;
        $certUtama = Certification::where('level', 'gada_utama')->first() ?? $certPratama;

        $skills = Skill::all();

        $candidates = [
            [
                'name' => 'Budi Santoso',
                'email' => 'budi.santoso@satpamku.id',
                'phone' => '081298765432',
                'headline' => 'Satpam Gada Pratama Berpengalaman 4 Tahun di Perkantoran SCBD',
                'summary' => 'Personil satuan pengamanan terlatih dengan kedisiplinan tinggi, menguasai kontrol akses lobi, patroli perimeter gedung bertingkat, dan penanganan kondisi darurat sesuai SOP Mabes Polri.',
                'certificate_level' => 'gada_pratama',
                'cert_model' => $certPratama,
                'height_cm' => 174,
                'weight_kg' => 70,
                'has_sim_c' => true,
                'has_sim_a' => true,
                'salary_min' => 5000000,
                'salary_max' => 6000000,
                'years_experience' => 4,
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'experiences' => [
                    [
                        'company_name' => 'PT Cakra Garda (Penempatan Pacific Place)',
                        'position_title' => 'Security Guard / Petugas Jaga Lobi',
                        'start_date' => '2022-03-01',
                        'is_current' => true,
                        'description' => 'Melakukan pengecekan ID card pengunjung, pemeriksaan metal detector, dan patroli berkala lantai perkantoran.',
                    ],
                    [
                        'company_name' => 'PT Bravo Satria Perkasa',
                        'position_title' => 'Anggota Regu Pengamanan',
                        'start_date' => '2020-01-10',
                        'end_date' => '2022-02-28',
                        'is_current' => false,
                        'description' => 'Pengamanan area parkir dan pengaturan lalu lintas masuk keluar kendaraan gedung perkantoran.',
                    ],
                ],
            ],
            [
                'name' => 'Bambang Supriyanto',
                'email' => 'bambang.danru@satpamku.id',
                'phone' => '081287654321',
                'headline' => 'Komandan Regu (Danru) Gada Madya — Spesialis Pengamanan Kawasan Industri',
                'summary' => 'Memiliki pengalaman 7 tahun memimpin 25 personil security shift di area pergudangan dan pabrik manufaktur. Mahir dalam manajemen piket regu, pembuatan laporan kejadian, dan investigasi internal.',
                'certificate_level' => 'gada_madya',
                'cert_model' => $certMadya,
                'height_cm' => 178,
                'weight_kg' => 76,
                'has_sim_c' => true,
                'has_sim_a' => true,
                'salary_min' => 6500000,
                'salary_max' => 8000000,
                'years_experience' => 7,
                'city_id' => $cityBekasi->id,
                'city' => $cityBekasi->name,
                'experiences' => [
                    [
                        'company_name' => 'PT Garda Utama Mandiri (Kawasan MM2100)',
                        'position_title' => 'Komandan Regu (Danru) Security',
                        'start_date' => '2021-06-01',
                        'is_current' => true,
                        'description' => 'Memimpin apel serah terima jaga 3 shift, inspeksi pos jaga, dan koordinasi dengan Polsek setempat.',
                    ],
                    [
                        'company_name' => 'PT Sigap Prima Astrea',
                        'position_title' => 'Petugas Patroli Mobile',
                        'start_date' => '2017-04-01',
                        'end_date' => '2021-05-30',
                        'is_current' => false,
                        'description' => 'Patroli berkala area pabrik 20 hektar, monitoring titik rawan dan pos jaga gerbang utama.',
                    ],
                ],
            ],
            [
                'name' => 'Siti Rahmawati',
                'email' => 'siti.ladyguard@satpamku.id',
                'phone' => '081377889900',
                'headline' => 'Lady Guard / Satpam Wanita Bersertifikat Gada Pratama — Pelayanan Prima Lobi & Mall',
                'summary' => 'Satpam wanita terlatih dengan keahlian body checking wanita, pemeriksaan barang bawaan VIP, dan komunikasi hospitality ramah tamah untuk perbankan dan pusat perbelanjaan premium.',
                'certificate_level' => 'gada_pratama',
                'cert_model' => $certPratama,
                'height_cm' => 166,
                'weight_kg' => 56,
                'has_sim_c' => true,
                'has_sim_a' => false,
                'salary_min' => 5200000,
                'salary_max' => 6000000,
                'years_experience' => 3,
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'experiences' => [
                    [
                        'company_name' => 'PT Cakra Garda Nusantara (Grand Indonesia Mall)',
                        'position_title' => 'Lady Security Officer',
                        'start_date' => '2023-01-15',
                        'is_current' => true,
                        'description' => 'Pemeriksaan keamanan pintu masuk utama, panduan informasi pengunjung, dan penanganan insiden anak hilang.',
                    ],
                ],
            ],
            [
                'name' => 'Mayor (Purn) Slamet Riyadi',
                'email' => 'slamet.chief@satpamku.id',
                'phone' => '081199887766',
                'headline' => 'Chief Security Officer / Manager Pengamanan Kawasan Terpadu — Gada Utama',
                'summary' => 'Purnawirawan TNI-AD dengan sertifikasi Gada Utama Mabes Polri. Pengalaman 12 tahun merancang Security Risk Assessment, Standard Operating Procedure (SOP) darurat, dan koordinasi instansi militer & kepolisian.',
                'certificate_level' => 'gada_utama',
                'cert_model' => $certUtama,
                'height_cm' => 180,
                'weight_kg' => 82,
                'has_sim_c' => true,
                'has_sim_a' => true,
                'salary_min' => 10000000,
                'salary_max' => 15000000,
                'years_experience' => 12,
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'experiences' => [
                    [
                        'company_name' => 'PT Nawakara Arta Kencana',
                        'position_title' => 'Chief Security & Risk Mitigation Manager',
                        'start_date' => '2019-08-01',
                        'is_current' => true,
                        'description' => 'Membawahi 120 personil security di kawasan superblock perumahan dan komersial.',
                    ],
                ],
            ],
            [
                'name' => 'Agus Setiawan',
                'email' => 'agus.setiawan@satpamku.id',
                'phone' => '081266554433',
                'headline' => 'Satpam Perbankan & Kas — Sertifikasi Gada Pratama & Damkar',
                'summary' => 'Memiliki sertifikasi pemadam kebakaran dan First Aid (P3K). Berpengalaman 3 tahun dalam pengamanan kantor cabang bank dan pengawalan pengisian uang mesin ATM.',
                'certificate_level' => 'gada_pratama',
                'cert_model' => $certPratama,
                'height_cm' => 173,
                'weight_kg' => 67,
                'has_sim_c' => true,
                'has_sim_a' => true,
                'salary_min' => 5000000,
                'salary_max' => 5800000,
                'years_experience' => 3,
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'experiences' => [
                    [
                        'company_name' => 'PT Sigap Prima Astrea (Bank Permata)',
                        'position_title' => 'Petugas Keamanan Kantor Cabang',
                        'start_date' => '2023-05-01',
                        'is_current' => true,
                        'description' => 'Pemeriksaan nasabah, pembukaan dan penguncian brankas cabang, serta pengawasan lobi banking hall.',
                    ],
                ],
            ],
            [
                'name' => 'Rudi Hermawan',
                'email' => 'rudi.danru@satpamku.id',
                'phone' => '081244332211',
                'headline' => 'Supervisor Security Gada Madya — CCTV Monitoring & Access Control',
                'summary' => 'Mahir mengoperasikan Command Center CCTV, alarm kebakaran addressable, dan sistem gate otomatis biometrik.',
                'certificate_level' => 'gada_madya',
                'cert_model' => $certMadya,
                'height_cm' => 176,
                'weight_kg' => 74,
                'has_sim_c' => true,
                'has_sim_a' => true,
                'salary_min' => 6000000,
                'salary_max' => 7500000,
                'years_experience' => 5,
                'city_id' => $cityBandung->id,
                'city' => $cityBandung->name,
                'experiences' => [
                    [
                        'company_name' => 'PT Shield-On Service (Trans Studio Mall Bandung)',
                        'position_title' => 'Supervisor CCTV & Access Control',
                        'start_date' => '2022-01-01',
                        'is_current' => true,
                        'description' => 'Monitoring 180 titik kamera CCTV, penanganan insiden pencurian, dan koordinasi tim patroli lapangan.',
                    ],
                ],
            ],
        ];

        foreach ($candidates as $cand) {
            $user = User::firstOrCreate(
                ['email' => $cand['email']],
                [
                    'name' => $cand['name'],
                    'phone' => $cand['phone'],
                    'password' => Hash::make('Password123!'),
                    'role' => 'candidate',
                    'status' => 'active',
                    'email_verified_at' => now(),
                ]
            );

            UserProfile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'city' => $cand['city'],
                    'gender' => str_contains(strtolower($cand['headline']), 'wanita') ? 'female' : 'male',
                ]
            );

            $sims = [];
            if ($cand['has_sim_a']) $sims[] = 'SIM A';
            if ($cand['has_sim_c']) $sims[] = 'SIM C';

            $profile = CandidateProfile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'headline' => $cand['headline'],
                    'summary' => $cand['summary'],
                    'highest_certificate_level' => $cand['certificate_level'],
                    'height_cm' => $cand['height_cm'],
                    'weight_kg' => $cand['weight_kg'],
                    'has_sim' => !empty($sims),
                    'sim_types' => $sims,
                    'preferred_city_id' => $cand['city_id'],
                    'preferred_city' => $cand['city'],
                    'preferred_shift' => '3_shift',
                    'salary_min' => $cand['salary_min'],
                    'salary_max' => $cand['salary_max'],
                    'years_experience' => $cand['years_experience'],
                    'verification_status' => 'verified',
                    'profile_completion' => 95,
                ]
            );

            // Seed Experiences
            foreach ($cand['experiences'] as $exp) {
                Experience::updateOrCreate(
                    [
                        'candidate_id' => $profile->id,
                        'employer_name' => $exp['company_name'],
                        'position' => $exp['position_title'],
                    ],
                    [
                        'start_date' => $exp['start_date'],
                        'end_date' => $exp['end_date'] ?? null,
                        'is_current' => $exp['is_current'],
                        'description' => $exp['description'],
                    ]
                );
            }

            // Seed Certifications
            CandidateCertification::updateOrCreate(
                [
                    'candidate_id' => $profile->id,
                    'certification_id' => $cand['cert_model']->id,
                ],
                [
                    'certificate_number' => 'SK/' . rand(1000, 9999) . '/POLDA-METRO/' . date('Y'),
                    'document_path' => 'certifications/dummy_cert_' . $user->id . '.pdf',
                    'issued_at' => now()->subYears(1)->format('Y-m-d'),
                    'expires_at' => now()->addYears(2)->format('Y-m-d'),
                    'verification_status' => 'verified',
                    'verified_at' => now(),
                ]
            );

            // Seed Documents
            CandidateDocument::updateOrCreate(
                [
                    'candidate_id' => $profile->id,
                    'type' => 'cv',
                ],
                [
                    'title' => 'Curriculum Vitae — ' . $cand['name'],
                    'path' => 'documents/cv_' . $user->id . '.pdf',
                    'file_size' => 1024 * 350,
                    'mime_type' => 'application/pdf',
                    'verification_status' => 'verified',
                    'verified_at' => now(),
                ]
            );

            // Attach 3-4 skills
            if ($skills->isNotEmpty()) {
                $sampleSkills = $skills->take(4)->pluck('id');
                $profile->skills()->syncWithoutDetaching($sampleSkills);
            }
        }
    }
}
