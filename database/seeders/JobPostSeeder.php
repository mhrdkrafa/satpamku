<?php

namespace Database\Seeders;

use App\Models\EmployerProfile;
use App\Models\Facility;
use App\Models\JobCategory;
use App\Models\JobPosition;
use App\Models\JobPost;
use App\Models\Location;
use App\Models\Skill;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class JobPostSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $employers = EmployerProfile::all();
        if ($employers->isEmpty()) return;

        $sigap = $employers->where('slug', 'pt-sigap-prima-astrea')->first() ?? $employers->first();
        $bsp = $employers->where('slug', 'pt-bravo-satria-perkasa')->first() ?? $employers->first();
        $nawakara = $employers->where('slug', 'pt-nawakara-arta-kencana')->first() ?? $employers->first();
        $cakra = $employers->where('slug', 'pt-cakra-garda-nusantara')->first() ?? $employers->first();
        $sos = $employers->where('slug', 'pt-shield-on-service-tbk')->first() ?? $employers->first();
        $garda = $employers->where('slug', 'pt-garda-utama-mandiri')->first() ?? $employers->first();

        $catPerkantoran = JobCategory::where('slug', 'perkantoran-komersial')->first() ?? JobCategory::first();
        $catPerbankan = JobCategory::where('slug', 'perbankan-kas')->first() ?? $catPerkantoran;
        $catIndustri = JobCategory::where('slug', 'kawasan-industri-pabrik')->first() ?? $catPerkantoran;
        $catRetail = JobCategory::where('slug', 'mall-pusat-perbelanjaan')->first() ?? $catPerkantoran;
        $catResidensial = JobCategory::where('slug', 'residensial-perumahan')->first() ?? $catPerkantoran;
        $catVip = JobCategory::where('slug', 'vip-pengawalan-event')->first() ?? $catPerkantoran;

        $locJakarta = Location::where('slug', 'kota-jakarta-selatan')->first() ?? Location::first();
        $locBekasi = Location::where('slug', 'kota-bekasi')->first() ?? $locJakarta;
        $locSurabaya = Location::where('slug', 'kota-surabaya')->first() ?? $locJakarta;
        $locBandung = Location::where('slug', 'kota-bandung')->first() ?? $locJakarta;

        $facilities = Facility::all();
        $skills = Skill::all();

        $jobs = [
            [
                'employer' => $sigap,
                'category' => $catPerkantoran,
                'location' => $locJakarta,
                'title' => 'Satpam Gedung Perkantoran Sudirman (SCBD)',
                'description' => 'Dibutuhkan 15 personil satuan pengamanan pria untuk penempatan gedung perkantoran Grade A di kawasan SCBD Jakarta Selatan. Tugas utama mencakup pengawasan akses masuk lobi utama, pemeriksaan metal detector, dan patroli area parkir eksekutif.',
                'requirements' => "1. Pria, usia 20 - 35 tahun\n2. Tinggi badan minimal 170 cm, berat badan proporsional\n3. Memiliki ijazah Gada Pratama resmi Polri dan KTA aktif\n4. Tidak bertato, tidak bertindik, dan bebas narkoba\n5. Diutamakan memiliki SIM C / SIM A",
                'responsibilities' => "1. Melakukan pemeriksaan barang bawaan dan ID card tamu gedung\n2. Melaksanakan patroli rutin setiap 2 jam sekali dan mengisi buku mutasi jaga\n3. Mengatur kelancaran lalu lintas drop-off lobi utama\n4. Siap bertindak cepat saat situasi darurat kebakaran atau evakuasi gedung",
                'shift_type' => '3_shift',
                'placement_address' => 'Gedung SCBD Tower Lt. 1, Jl. Jend. Sudirman Kav. 52-53, Jakarta Selatan',
                'salary_min' => 5500000,
                'salary_max' => 6500000,
                'salary_is_hidden' => false,
                'experience_years_min' => 1,
                'min_height_cm' => 170,
                'min_weight_kg' => 62,
                'required_certificate_level' => 'gada_pratama',
                'requires_sim' => true,
                'is_urgent' => false,
                'is_featured' => true,
                'status' => 'published',
            ],
            [
                'employer' => $garda,
                'category' => $catIndustri,
                'location' => $locBekasi,
                'title' => 'Komandan Regu (Danru) Kawasan Industri GIIC Cikarang',
                'description' => 'Dibutuhkan Danru berpengalaman untuk memimpin 20 personil security shift di pabrik manufaktur otomotif seluas 15 hektar. Bertanggung jawab langsung kepada Chief Security.',
                'requirements' => "1. Pria, usia 27 - 42 tahun\n2. Pendidikan minimal SMA/SMK, memiliki Ijazah Gada Madya\n3. Pengalaman minimal 3 tahun sebagai Danru di kawasan industri\n4. Menguasai manajemen jadwal piket dan pembuatan Berita Acara Pemeriksaan (BAP)\n5. Memiliki SIM A aktif",
                'responsibilities' => "1. Memimpin apel serah terima jaga 2 shift (12 jam)\n2. Memastikan seluruh pos jaga, timbangan truk, dan pintu loading dock berjalan aman\n3. Melakukan investigasi awal atas laporan selisih barang logistik\n4. Membina fisik dan mental anggota regu",
                'shift_type' => '2_shift',
                'placement_address' => 'Kawasan Industri GIIC Blok C No. 8, Cikarang Pusat, Bekasi',
                'salary_min' => 6800000,
                'salary_max' => 8200000,
                'salary_is_hidden' => false,
                'experience_years_min' => 3,
                'min_height_cm' => 172,
                'min_weight_kg' => 68,
                'required_certificate_level' => 'gada_madya',
                'requires_sim' => true,
                'is_urgent' => false,
                'is_featured' => true,
                'status' => 'published',
            ],
            [
                'employer' => $nawakara,
                'category' => $catPerbankan,
                'location' => $locJakarta,
                'title' => 'Security Officer Perbankan & Kantor Kas Menteng',
                'description' => 'Penempatan kantor cabang utama bank swasta nasional. Mengutamakan sikap tampang tegap, etika pelayanan prima (service excellence), dan ketangkasan penanganan nasabah.',
                'requirements' => "1. Pria/Wanita, usia 21 - 32 tahun\n2. Tinggi min. Pria 172 cm, Wanita 165 cm\n3. Ijazah Gada Pratama dan KTA wajib aktif\n4. Ramah, komunikatif, dan berpenampilan bersih rapi\n5. Bebas catatan kriminal (SKCK aktif)",
                'responsibilities' => "1. Memberikan sambutan ramah (greeting) kepada nasabah bank\n2. Mengawasi area ATM center 24 jam\n3. Mendampingi petugas teller saat serah terima uang brankas\n4. Sigap memantau pergerakan orang mencurigakan di area banking hall",
                'shift_type' => '3_shift',
                'placement_address' => 'Jl. HOS Cokroaminoto No. 40, Menteng, Jakarta Pusat',
                'salary_min' => 5300000,
                'salary_max' => 6200000,
                'salary_is_hidden' => false,
                'experience_years_min' => 1,
                'min_height_cm' => 172,
                'min_weight_kg' => 65,
                'required_certificate_level' => 'gada_pratama',
                'requires_sim' => false,
                'is_urgent' => true,
                'is_featured' => true,
                'status' => 'published',
            ],
            [
                'employer' => $cakra,
                'category' => $catRetail,
                'location' => $locJakarta,
                'title' => 'Satpam Mall & Pusat Perbelanjaan Senayan City',
                'description' => 'URGENT HIRING! Dibutuhkan 25 personil security mall untuk persiapan event akhir pekan dan pengamanan harian pusat perbelanjaan luxury.',
                'requirements' => "1. Pria, usia 19 - 30 tahun\n2. Tinggi minimal 170 cm, berat proporsional\n3. Memiliki Ijazah Gada Pratama (Fresh graduate dipersilakan melamar)\n4. Bersedia bekerja sistem shift termasuk hari libur nasional",
                'responsibilities' => "1. Menjaga pintu akses masuk mall dan pemeriksaan x-ray/metal detector\n2. Patroli lantai pertokoan dan area food court\n3. Membantu mengarahkan pengunjung dan menangani laporan barang hilang\n4. Menjaga ketertiban di area antrean lobby utama",
                'shift_type' => '2_shift',
                'placement_address' => 'Senayan City Mall, Jl. Asia Afrika Lot 19, Jakarta Pusat',
                'salary_min' => 5100000,
                'salary_max' => 5800000,
                'salary_is_hidden' => false,
                'experience_years_min' => 0,
                'min_height_cm' => 170,
                'min_weight_kg' => 60,
                'required_certificate_level' => 'gada_pratama',
                'requires_sim' => false,
                'is_urgent' => true,
                'is_featured' => false,
                'status' => 'published',
            ],
            [
                'employer' => $cakra,
                'category' => $catPerkantoran,
                'location' => $locJakarta,
                'title' => 'Lady Guard (Satpam Wanita) Lobby Apartemen Mega Kuningan',
                'description' => 'Lowongan khusus satpam wanita (Lady Security) untuk penempatan lobi apartemen premium di kawasan kedutaan Mega Kuningan.',
                'requirements' => "1. Wanita, usia 20 - 32 tahun, berpenampilan menarik\n2. Tinggi badan minimal 165 cm\n3. Ijazah Gada Pratama dan KTA aktif\n4. Mampu berbahasa Inggris dasar untuk menyapa ekspatriat",
                'responsibilities' => "1. Menerima dan mencatat tamu serta kurir paket penghuni apartemen\n2. Melakukan pemeriksaan badan (body checking) khusus tamu wanita bila diperlukan\n3. Menangani panggilan darurat interkom penghuni unit\n4. Menjaga kerahasiaan dan privasi penghuni VIP",
                'shift_type' => 'full_time',
                'placement_address' => 'Mega Kuningan Barat Kav. E-4, Setiabudi, Jakarta Selatan',
                'salary_min' => 5400000,
                'salary_max' => 6400000,
                'salary_is_hidden' => false,
                'experience_years_min' => 1,
                'min_height_cm' => 165,
                'min_weight_kg' => 55,
                'required_certificate_level' => 'gada_pratama',
                'requires_sim' => false,
                'is_urgent' => false,
                'is_featured' => false,
                'status' => 'published',
            ],
            [
                'employer' => $bsp,
                'category' => $catPerkantoran,
                'location' => $locSurabaya,
                'title' => 'Chief Security Officer Kawasan Terpadu Surabaya Barat',
                'description' => 'Mencari Chief Security kualifikasi Gada Utama untuk memimpin operasional pengamanan mall, hotel bintang lima, dan gedung perkantoran terpadu di Surabaya Barat.',
                'requirements' => "1. Pria, usia 35 - 50 tahun (Purnawirawan TNI/Polri dipersilakan)\n2. Wajib memiliki Ijazah Gada Utama Mabes Polri\n3. Pengalaman minimal 5 tahun sebagai Chief Security kawasan skala besar\n4. Memiliki sertifikasi K3 Keamanan dan Investigasi",
                'responsibilities' => "1. Merancang dan mengevaluasi Security Plan tahunan\n2. Membawahi 4 Supervisor dan 80 personil security lapangan\n3. Menjalin koordinasi formal dengan Polrestabes Surabaya dan Koramil setempat\n4. Bertanggung jawab langsung kepada General Manager Building",
                'shift_type' => 'full_time',
                'placement_address' => 'Mayjen Sungkono No. 89, Surabaya Barat, Jawa Timur',
                'salary_min' => 11000000,
                'salary_max' => 15000000,
                'salary_is_hidden' => false,
                'experience_years_min' => 5,
                'min_height_cm' => 175,
                'min_weight_kg' => 70,
                'required_certificate_level' => 'gada_utama',
                'requires_sim' => true,
                'is_urgent' => false,
                'is_featured' => true,
                'status' => 'published',
            ],
            [
                'employer' => $sos,
                'category' => $catIndustri,
                'location' => $locJakarta,
                'title' => 'Patroli Mobile & Kawasan Pergudangan Marunda',
                'description' => 'Petugas patroli mobile menggunakan sepeda motor dinas untuk pemantauan perimeter pergudangan kontainer logistik Marunda.',
                'requirements' => "1. Pria, usia 21 - 35 tahun\n2. Tinggi min. 168 cm, fisik prima\n3. Wajib memiliki SIM C aktif\n4. Memiliki Ijazah Gada Pratama",
                'responsibilities' => "1. Patroli rutin memutari perimeter pagar gudang 20 hektar\n2. Pengecekan segel kontainer dan pintu gembok gudang\n3. Pencatatan log book pos portal pintu barat dan timur",
                'shift_type' => '3_shift',
                'placement_address' => 'Kawasan Berikat Nusantara (KBN) Marunda, Jakarta Utara',
                'salary_min' => 5100000,
                'salary_max' => 5600000,
                'salary_is_hidden' => false,
                'experience_years_min' => 1,
                'min_height_cm' => 168,
                'min_weight_kg' => 60,
                'required_certificate_level' => 'gada_pratama',
                'requires_sim' => true,
                'is_urgent' => false,
                'is_featured' => false,
                'status' => 'published',
            ],
            [
                'employer' => $bsp,
                'category' => $catResidensial,
                'location' => $locJakarta,
                'title' => 'Hospitality Security Cluster Perumahan Mewah BSD',
                'description' => 'Pengamanan cluster perumahan elit dengan penekanan pada keramahan pelayanan penghuni, pengawasan CCTV boom gate, dan patroli lingkungan.',
                'requirements' => "1. Pria, usia 20 - 35 tahun\n2. Tinggi badan minimal 170 cm\n3. Memiliki Ijazah Gada Pratama\n4. Memiliki SIM C untuk patroli sepeda motor listrik",
                'responsibilities' => "1. Pengecekan kartu akses masuk penghuni dan tamu cluster\n2. Pengawalan tamu VIP penghuni hingga ke rumah tujuan\n3. Patroli komplek perumahan setiap 1 jam sekali",
                'shift_type' => '2_shift',
                'placement_address' => 'Cluster Greenwich Park, BSD City, Tangerang Selatan',
                'salary_min' => 5200000,
                'salary_max' => 6000000,
                'salary_is_hidden' => false,
                'experience_years_min' => 1,
                'min_height_cm' => 170,
                'min_weight_kg' => 62,
                'required_certificate_level' => 'gada_pratama',
                'requires_sim' => true,
                'is_urgent' => false,
                'is_featured' => false,
                'status' => 'published',
            ],
            [
                'employer' => $nawakara,
                'category' => $catVip,
                'location' => $locJakarta,
                'title' => 'Pengawal VIP & Event Pengamanan Khusus',
                'description' => 'Dibutuhkan personil security berpostur tegap dengan keahlian bela diri Polri untuk penugasan pengawalan pejabat, ekspatriat, dan event internasional.',
                'requirements' => "1. Pria, usia 23 - 38 tahun\n2. Tinggi badan minimal 175 cm, fisik terlatih\n3. Ijazah Gada Madya / Gada Pratama + Sertifikat Bela Diri\n4. Memiliki SIM A dan SIM C aktif",
                'responsibilities' => "1. Pengawalan melekat (close protection) tamu VIP selama kegiatan\n2. Sterilisasi lokasi pertemuan dan rute perjalanan\n3. Koordinasi dengan tim voorijder dan keamanan lokal",
                'shift_type' => 'event',
                'placement_address' => 'Hotel Fairmont, Jl. Asia Afrika No. 8, Jakarta Pusat',
                'salary_min' => 7500000,
                'salary_max' => 10000000,
                'salary_is_hidden' => false,
                'experience_years_min' => 2,
                'min_height_cm' => 175,
                'min_weight_kg' => 72,
                'required_certificate_level' => 'gada_madya',
                'requires_sim' => true,
                'is_urgent' => true,
                'is_featured' => true,
                'status' => 'published',
            ],
        ];

        foreach ($jobs as $data) {
            $job = JobPost::updateOrCreate(
                [
                    'employer_id' => $data['employer']->id,
                    'title' => $data['title'],
                ],
                [
                    'category_id' => $data['category']->id,
                    'location_id' => $data['location']->id,
                    'slug' => Str::slug($data['title']) . '-' . Str::random(5),
                    'description' => $data['description'],
                    'requirements' => $data['requirements'],
                    'responsibilities' => $data['responsibilities'],
                    'shift_type' => $data['shift_type'],
                    'placement_address' => $data['placement_address'],
                    'salary_min' => $data['salary_min'],
                    'salary_max' => $data['salary_max'],
                    'salary_is_hidden' => $data['salary_is_hidden'],
                    'experience_years_min' => $data['experience_years_min'],
                    'min_height_cm' => $data['min_height_cm'],
                    'min_weight_kg' => $data['min_weight_kg'],
                    'required_certificate_level' => $data['required_certificate_level'],
                    'requires_sim' => $data['requires_sim'],
                    'is_urgent' => $data['is_urgent'],
                    'is_featured' => $data['is_featured'],
                    'status' => $data['status'],
                    'published_at' => now()->subDays(rand(1, 10)),
                ]
            );

            // Attach 3-4 facilities
            if ($facilities->isNotEmpty()) {
                $job->facilities()->syncWithoutDetaching($facilities->take(4)->pluck('id'));
            }

            // Attach skills
            if ($skills->isNotEmpty()) {
                $job->skills()->syncWithoutDetaching($skills->take(3)->pluck('id'));
            }
        }
    }
}
