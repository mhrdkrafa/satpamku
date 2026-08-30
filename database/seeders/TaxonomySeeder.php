<?php

namespace Database\Seeders;

use App\Models\Certification;
use App\Models\Facility;
use App\Models\JobCategory;
use App\Models\JobPosition;
use App\Models\Location;
use App\Models\Skill;
use Illuminate\Database\Seeder;

class TaxonomySeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $this->seedLocations();
        $this->seedCategoriesAndPositions();
        $this->seedFacilities();
        $this->seedSkills();
        $this->seedCertifications();
    }

    private function seedLocations(): void
    {
        $provinces = [
            'DKI Jakarta' => [
                'Jakarta Selatan', 'Jakarta Pusat', 'Jakarta Barat', 'Jakarta Timur', 'Jakarta Utara',
            ],
            'Jawa Barat' => [
                'Kota Bandung', 'Kota Bekasi', 'Kota Bogor', 'Kota Depok', 'Kabupaten Bekasi', 'Kabupaten Bogor', 'Kabupaten Karawang',
            ],
            'Banten' => [
                'Kota Tangerang', 'Kota Tangerang Selatan', 'Kabupaten Tangerang', 'Kota Serang', 'Kota Cilegon',
            ],
            'Jawa Tengah' => [
                'Kota Semarang', 'Kota Surakarta (Solo)', 'Kabupaten Banyumas', 'Kota Magelang',
            ],
            'Jawa Timur' => [
                'Kota Surabaya', 'Kota Malang', 'Kabupaten Sidoarjo', 'Kabupaten Gresik',
            ],
            'Bali' => [
                'Kota Denpasar', 'Kabupaten Badung', 'Kabupaten Gianyar',
            ],
            'Sumatera Utara' => [
                'Kota Medan', 'Kota Binjai', 'Kabupaten Deli Serdang',
            ],
        ];

        foreach ($provinces as $provinceName => $cities) {
            $province = Location::firstOrCreate(
                ['slug' => \Illuminate\Support\Str::slug($provinceName)],
                [
                    'name' => $provinceName,
                    'type' => 'province',
                    'is_active' => true,
                ]
            );

            foreach ($cities as $cityName) {
                Location::firstOrCreate(
                    ['slug' => \Illuminate\Support\Str::slug($cityName)],
                    [
                        'parent_id' => $province->id,
                        'name' => $cityName,
                        'type' => 'city',
                        'is_active' => true,
                    ]
                );
            }
        }
    }

    private function seedCategoriesAndPositions(): void
    {
        $categories = [
            [
                'name' => 'Retail',
                'description' => 'Keamanan untuk mall, pusat perbelanjaan, supermarket, dan toko retail modern.',
                'icon' => 'storefront',
                'sort_order' => 1,
                'positions' => [
                    'Danru Retail (Mall)',
                    'Anggota Satpam Retail',
                    'Loss Prevention Officer',
                    'Security Counter & Kasir',
                ],
            ],
            [
                'name' => 'Residensial',
                'description' => 'Keamanan untuk kawasan perumahan, cluster, apartemen, dan kondominium.',
                'icon' => 'home_work',
                'sort_order' => 2,
                'positions' => [
                    'Chief Security Apartemen',
                    'Danru Residensial',
                    'Security Perumahan / Cluster',
                    'Operator Gate & Palang Otomatis',
                ],
            ],
            [
                'name' => 'VIP',
                'description' => 'Pengawalan pribadi, pengamanan eksekutif, dan transportasi barang berharga.',
                'icon' => 'star',
                'sort_order' => 3,
                'positions' => [
                    'Anggota Satpam VIP',
                    'Pengawal Pribadi (Bodyguard)',
                    'Executive Protection Officer',
                    'Security Kawalan Uang & Logistik',
                ],
            ],
            [
                'name' => 'Event',
                'description' => 'Pengamanan konser musik, eksibisi, konferensi, dan acara temporer.',
                'icon' => 'festival',
                'sort_order' => 4,
                'positions' => [
                    'Crowd Control Officer',
                    'Security Konser & Pameran',
                    'Steward Acara Olahraga',
                ],
            ],
            [
                'name' => 'Industri',
                'description' => 'Keamanan untuk pabrik, pergudangan, kawasan industri, dan logistik.',
                'icon' => 'factory',
                'sort_order' => 5,
                'positions' => [
                    'Chief Security Kawasan Industri',
                    'Danru Pabrik & Gudang',
                    'Security Pos Timbangan & Bongkar Muat',
                    'Patroli Area Pabrik',
                ],
            ],
            [
                'name' => 'Perkantoran',
                'description' => 'Keamanan untuk gedung perkantoran korporat dan instansi bisnis.',
                'icon' => 'business',
                'sort_order' => 6,
                'positions' => [
                    'Chief Security Officer Perkantoran',
                    'Front Desk Security',
                    'Security Gedung Bertingkat',
                    'Operator CCTV Perkantoran',
                ],
            ],
            [
                'name' => 'Perbankan',
                'description' => 'Keamanan untuk kantor cabang bank, ATM center, dan kantor kas.',
                'icon' => 'account_balance',
                'sort_order' => 7,
                'positions' => [
                    'Security Kantor Cabang Bank',
                    'Security ATM Center',
                    'Cash In Transit Escort',
                ],
            ],
            [
                'name' => 'Rumah Sakit',
                'description' => 'Keamanan lingkungan medis, IGD, rawat inap, dan fasilitas kesehatan.',
                'icon' => 'local_hospital',
                'sort_order' => 8,
                'positions' => [
                    'Danru Keamanan Rumah Sakit',
                    'Security Pos IGD & Rawat Inap',
                ],
            ],
        ];

        foreach ($categories as $catData) {
            $positions = $catData['positions'];
            unset($catData['positions']);

            $category = JobCategory::firstOrCreate(
                ['slug' => \Illuminate\Support\Str::slug($catData['name'])],
                $catData
            );

            foreach ($positions as $positionName) {
                JobPosition::firstOrCreate(
                    [
                        'category_id' => $category->id,
                        'slug' => \Illuminate\Support\Str::slug($positionName),
                    ],
                    [
                        'name' => $positionName,
                        'is_active' => true,
                    ]
                );
            }
        }
    }

    private function seedFacilities(): void
    {
        $facilities = [
            ['name' => 'BPJS Kesehatan', 'type' => 'benefit', 'icon' => 'health_and_safety'],
            ['name' => 'BPJS Ketenagakerjaan', 'type' => 'benefit', 'icon' => 'account_balance'],
            ['name' => 'Seragam Lengkap Disediakan', 'type' => 'facility', 'icon' => 'styler'],
            ['name' => 'Uang Makan / Meal Allowance', 'type' => 'benefit', 'icon' => 'restaurant'],
            ['name' => 'Tempat Tinggal / Mess Disediakan', 'type' => 'facility', 'icon' => 'hotel'],
            ['name' => 'Tunjangan Hari Raya (THR)', 'type' => 'benefit', 'icon' => 'payments'],
            ['name' => 'Uang Lembur Dibayarkan', 'type' => 'benefit', 'icon' => 'schedule'],
            ['name' => 'Asuransi Jiwa & Kecelakaan', 'type' => 'benefit', 'icon' => 'shield'],
            ['name' => 'Kendaraan Operasional Patroli', 'type' => 'facility', 'icon' => 'two_wheeler'],
            ['name' => 'Pelatihan Berkala', 'type' => 'facility', 'icon' => 'school'],
        ];

        foreach ($facilities as $facility) {
            Facility::firstOrCreate(
                ['slug' => \Illuminate\Support\Str::slug($facility['name'])],
                $facility
            );
        }
    }

    private function seedSkills(): void
    {
        $skills = [
            ['name' => 'Pengendalian Akses & Pemeriksaan Tamu (Access Control)', 'category' => 'security_core'],
            ['name' => 'Pengawasan CCTV & Kontrol Panel Alarm', 'category' => 'technical'],
            ['name' => 'Patroli Keamanan & Deteksi Ancaman', 'category' => 'security_core'],
            ['name' => 'Tanggap Darurat Kebakaran & Evakuasi (Damkar)', 'category' => 'emergency'],
            ['name' => 'Pertolongan Pertama pada Kecelakaan (P3K / First Aid)', 'category' => 'emergency'],
            ['name' => 'Bela Diri Praktis & Kuncian Satpam', 'category' => 'security_core'],
            ['name' => 'Penanganan Konflik & De-eskalasi', 'category' => 'soft_skills'],
            ['name' => 'Pengaturan Lalu Lintas & Parkir (Gatur Lantas)', 'category' => 'security_core'],
            ['name' => 'Pelayanan Tamu & Hospitality', 'category' => 'soft_skills'],
            ['name' => 'Penulisan Buku Mutasi & Pembuatan Laporan Kejadian', 'category' => 'technical'],
            ['name' => 'Penggunaan Metal Detector & X-Ray Scanner', 'category' => 'technical'],
            ['name' => 'Pengemudi VIP / Defensive Driving', 'category' => 'technical'],
        ];

        foreach ($skills as $skill) {
            Skill::firstOrCreate(
                ['slug' => \Illuminate\Support\Str::slug($skill['name'])],
                $skill
            );
        }
    }

    private function seedCertifications(): void
    {
        $certs = [
            [
                'name' => 'Gada Pratama',
                'issuing_body' => 'Polda Metro Jaya / Mabes Polri',
                'description' => 'Pelatihan dasar wajib bagi setiap anggota Satpam untuk memiliki kualifikasi operasional.',
                'level' => 'pratama',
            ],
            [
                'name' => 'Gada Madya',
                'issuing_body' => 'Polda Metro Jaya / Mabes Polri',
                'description' => 'Pelatihan kepemimpinan tingkat menengah untuk Komandan Regu (Danru) dan Supervisor.',
                'level' => 'madya',
            ],
            [
                'name' => 'Gada Utama',
                'issuing_body' => 'Mabes Polri',
                'description' => 'Pelatihan tingkat manajerial untuk Chief Security Officer dan Pengelola Jasa Keamanan.',
                'level' => 'utama',
            ],
            [
                'name' => 'Ahli K3 Umum',
                'issuing_body' => 'Kementerian Ketenagakerjaan (Kemnaker) / BNSP',
                'description' => 'Sertifikasi keselamatan dan kesehatan kerja lingkungan operasional gedung dan industri.',
                'level' => 'specialized',
            ],
            [
                'name' => 'Sertifikat Petugas Peran Kebakaran (Damkar Kelas D/C)',
                'issuing_body' => 'Kemnaker / Dinas Penanggulangan Kebakaran',
                'description' => 'Kualifikasi pencegahan, pemadaman api awal, dan evakuasi kebakaran.',
                'level' => 'specialized',
            ],
            [
                'name' => 'Sertifikat First Aid & CPR',
                'issuing_body' => 'Palang Merah Indonesia (PMI) / BNSP',
                'description' => 'Kualifikasi penanganan medis darurat dan bantuan hidup dasar.',
                'level' => 'specialized',
            ],
            [
                'name' => 'Sertifikasi Satpam Perbankan (BNSP)',
                'issuing_body' => 'BNSP - Lembaga Sertifikasi Profesi (LSP)',
                'description' => 'Standar kompetensi khusus pengamanan perbankan dan transaksi keuangan.',
                'level' => 'specialized',
            ],
        ];

        foreach ($certs as $cert) {
            Certification::firstOrCreate(
                ['slug' => \Illuminate\Support\Str::slug($cert['name'])],
                $cert
            );
        }
    }
}
