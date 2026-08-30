<?php

namespace Database\Seeders;

use App\Models\EmployerProfile;
use App\Models\Location;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class EmployerSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $cityJakarta = Location::where('slug', 'kota-jakarta-selatan')->first() ?? Location::first();
        $cityBekasi = Location::where('slug', 'kota-bekasi')->first() ?? $cityJakarta;
        $citySurabaya = Location::where('slug', 'kota-surabaya')->first() ?? $cityJakarta;

        $employers = [
            [
                'email' => 'hrd@sigap.co.id',
                'name' => 'PT Sigap Prima Astrea',
                'phone' => '081211112222',
                'company_name' => 'PT Sigap Prima Astrea',
                'nib' => '9120001234567',
                'bujp_license_number' => 'SI/412/II/YAN.2.14/2023',
                'logo_path' => 'https://images.unsplash.com/photo-1560179707-f14e90ef3623?w=200&auto=format&fit=crop',
                'description' => 'PT Sigap Prima Astrea adalah Badan Usaha Jasa Pengamanan (BUJP) terkemuka bagian dari Astra Group yang menyediakan layanan pengamanan profesional terpadu di sektor perbankan, otomotif, perkantoran, dan industri.',
                'industry' => 'Jasa Pengamanan & Konsultasi Keamanan',
                'website' => 'https://www.sigap.com',
                'address' => 'Jl. Gaya Motor II No. 1, Sunter II, Jakarta Utara',
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'pic_name' => 'Hendro Purnomo, S.H.',
                'pic_phone' => '081211112222',
                'pic_position' => 'Senior Recruitment Manager',
                'verification_status' => 'verified',
            ],
            [
                'email' => 'recruitment@bravosecurity.id',
                'name' => 'PT Bravo Satria Perkasa',
                'phone' => '081233334444',
                'company_name' => 'PT Bravo Satria Perkasa',
                'nib' => '8120009876543',
                'bujp_license_number' => 'SI/589/IV/YAN.2.14/2022',
                'logo_path' => 'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=200&auto=format&fit=crop',
                'description' => 'PT Bravo Satria Perkasa (BSP) melayani ratusan klien korporasi di seluruh Indonesia dengan sertifikasi ISO 9001:2015 dan pelatihan personil berstandar Mabes Polri.',
                'industry' => 'Penyedia Tenaga Pengamanan',
                'website' => 'https://www.bspguard.co.id',
                'address' => 'Gedung BSP Tower Lt. 5, Jl. Dewi Sartika No. 44, Jakarta Timur',
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'pic_name' => 'Dwi Handoko, M.M.',
                'pic_phone' => '081233334444',
                'pic_position' => 'HR Operations Head',
                'verification_status' => 'verified',
            ],
            [
                'email' => 'karir@nawakara.com',
                'name' => 'PT Nawakara Arta Kencana',
                'phone' => '081255556666',
                'company_name' => 'PT Nawakara Arta Kencana',
                'nib' => '7120005544332',
                'bujp_license_number' => 'SI/102/I/YAN.2.14/2024',
                'logo_path' => 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=200&auto=format&fit=crop',
                'description' => 'Nawakara menyediakan layanan pengamanan terintegrasi, Cash in Transit (CIT), pengawalan VIP, pengamanan instalasi vital, dan pelatihan Gada Pratama/Madya berlisensi.',
                'industry' => 'High Security & Cash Solutions',
                'website' => 'https://www.nawakara.com',
                'address' => 'Jl. Pemuda No. 71, Rawamangun, Jakarta Timur',
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'pic_name' => 'Bambang Irawan',
                'pic_phone' => '081255556666',
                'pic_position' => 'Head of Talent Acquisition',
                'verification_status' => 'verified',
            ],
            [
                'email' => 'rekrutmen@cakragarda.id',
                'name' => 'PT Cakra Garda Nusantara',
                'phone' => '081277778888',
                'company_name' => 'PT Cakra Garda Nusantara',
                'nib' => '6120003322114',
                'bujp_license_number' => 'SI/771/VIII/YAN.2.14/2023',
                'logo_path' => 'https://images.unsplash.com/photo-1554469384-e58fac16e23a?w=200&auto=format&fit=crop',
                'description' => 'Spesialis pengamanan mall, pusat perbelanjaan, hotel bintang lima, dan gedung perkantoran prestisius di kawasan SCBD dan Mega Kuningan.',
                'industry' => 'Commercial & Hospitality Security',
                'website' => 'https://www.cakragarda.id',
                'address' => 'Sudirman Square Lt. 12, Jl. Jend. Sudirman Kav. 45, Jakarta Selatan',
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'pic_name' => 'Maya Anggraeni, S.Psi',
                'pic_phone' => '081277778888',
                'pic_position' => 'HR Recruitment Specialist',
                'verification_status' => 'verified',
            ],
            [
                'email' => 'recruitment@sos.co.id',
                'name' => 'PT Shield-On Service Tbk',
                'phone' => '081299990000',
                'company_name' => 'PT Shield-On Service Tbk',
                'nib' => '5120007788991',
                'bujp_license_number' => 'SI/332/III/YAN.2.14/2023',
                'logo_path' => 'https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=200&auto=format&fit=crop',
                'description' => 'Perusahaan terbuka penyedia tenaga alih daya dan jasa pengamanan terbesar di Indonesia dengan jangkauan operasional di 34 provinsi.',
                'industry' => 'Facility Services & Security Solution',
                'website' => 'https://www.sos.co.id',
                'address' => 'Graha SOS, Jl. Danau Sunter Barat Blok A-3 No. 1, Jakarta Utara',
                'city_id' => $cityJakarta->id,
                'city' => $cityJakarta->name,
                'pic_name' => 'Agus Priyadi, S.Kom',
                'pic_phone' => '081299990000',
                'pic_position' => 'Division Head HR',
                'verification_status' => 'verified',
            ],
            [
                'email' => 'hrd@gardautama.id',
                'name' => 'PT Garda Utama Mandiri',
                'phone' => '081311223344',
                'company_name' => 'PT Garda Utama Mandiri',
                'nib' => '4120008899002',
                'bujp_license_number' => 'SI/615/VI/YAN.2.14/2023',
                'logo_path' => 'https://images.unsplash.com/photo-1577495508048-b635879837f1?w=200&auto=format&fit=crop',
                'description' => 'BUJP terpercaya di kawasan industri Cikarang, Karawang, dan Cibitung yang fokus pada pengamanan pabrik, pergudangan, dan logistik.',
                'industry' => 'Industrial Security Specialist',
                'website' => 'https://www.gardautama.id',
                'address' => 'Kawasan Industri Jababeka II, Jl. Industri Selatan Blok JJ, Bekasi',
                'city_id' => $cityBekasi->id,
                'city' => $cityBekasi->name,
                'pic_name' => 'Suryo Wicaksono',
                'pic_phone' => '081311223344',
                'pic_position' => 'Branch Manager Bekasi',
                'verification_status' => 'verified',
            ],
        ];

        foreach ($employers as $data) {
            $user = User::firstOrCreate(
                ['email' => $data['email']],
                [
                    'name' => $data['name'],
                    'phone' => $data['phone'],
                    'password' => Hash::make('Password123!'),
                    'role' => 'employer',
                    'status' => 'active',
                    'email_verified_at' => now(),
                ]
            );

            UserProfile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'avatar_path' => $data['logo_path'],
                    'address' => $data['address'],
                    'city' => $data['city'],
                ]
            );

            EmployerProfile::updateOrCreate(
                ['user_id' => $user->id],
                [
                    'company_name' => $data['company_name'],
                    'slug' => Str::slug($data['company_name']),
                    'nib' => $data['nib'],
                    'bujp_license_number' => $data['bujp_license_number'],
                    'logo_path' => $data['logo_path'],
                    'description' => $data['description'],
                    'industry' => $data['industry'],
                    'website' => $data['website'],
                    'address' => $data['address'],
                    'city_id' => $data['city_id'],
                    'city' => $data['city'],
                    'pic_name' => $data['pic_name'],
                    'pic_phone' => $data['pic_phone'],
                    'pic_position' => $data['pic_position'],
                    'verification_status' => $data['verification_status'],
                ]
            );
        }
    }
}
