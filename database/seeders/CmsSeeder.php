<?php

namespace Database\Seeders;

use App\Models\Banner;
use App\Models\CareerArticle;
use App\Models\Faq;
use App\Models\HomepageSection;
use App\Models\SiteSetting;
use Illuminate\Database\Seeder;

class CmsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 1. Site Settings
        $settings = [
            ['group' => 'branding', 'key' => 'site_name', 'value' => 'Satpamku', 'type' => 'string'],
            ['group' => 'branding', 'key' => 'tagline', 'value' => 'Platform Rekrutmen & Karir Satpam Terpercaya di Indonesia', 'type' => 'string'],
            ['group' => 'branding', 'key' => 'logo_url', 'value' => '/images/branding/satpamku-logo.png', 'type' => 'string'],
            ['group' => 'seo', 'key' => 'meta_title', 'value' => 'Satpamku — Lowongan Kerja Satpam & Rekrutmen BUJP Resmi', 'type' => 'string'],
            ['group' => 'seo', 'key' => 'meta_description', 'value' => 'Cari lowongan kerja satpam bersertifikat Gada Pratama, Madya, Utama di seluruh Indonesia. Terhubung langsung dengan BUJP resmi.', 'type' => 'text'],
            ['group' => 'contact', 'key' => 'support_email', 'value' => 'bantuan@satpamku.id', 'type' => 'string'],
            ['group' => 'contact', 'key' => 'support_whatsapp', 'value' => '081288887777', 'type' => 'string'],
            ['group' => 'contact', 'key' => 'office_address', 'value' => 'Gedung Satpamku Tower Lt. 8, Jl. Jenderal Sudirman Kav. 52-53, Jakarta Selatan', 'type' => 'text'],
        ];

        foreach ($settings as $setting) {
            SiteSetting::updateOrCreate(['key' => $setting['key']], $setting);
        }

        // 2. Homepage Sections (ordering & visibility)
        $sections = [
            ['section_key' => 'hero_banner', 'title' => 'Banner Utama & Pencarian Cepat', 'subtitle' => 'Highlight banner dan pencarian sektor', 'is_visible' => true, 'sort_order' => 1],
            ['section_key' => 'sector_pills', 'title' => 'Sektor Pengamanan Populer', 'subtitle' => 'Pilih penempatan tugas sesuai minat', 'is_visible' => true, 'sort_order' => 2],
            ['section_key' => 'urgent_jobs', 'title' => 'Kebutuhan Cepat (Urgent Hiring)', 'subtitle' => 'Lowongan mendesak dengan penempatan segera', 'is_visible' => true, 'sort_order' => 3],
            ['section_key' => 'featured_jobs', 'title' => 'Lowongan Unggulan Terverifikasi', 'subtitle' => 'Gaji transparan dari BUJP resmi terdaftar Mabes Polri', 'is_visible' => true, 'sort_order' => 4],
            ['section_key' => 'career_resources', 'title' => 'Pusat Edukasi & Panduan Karir Satpam', 'subtitle' => 'Tips interview, info diklat Gada Pratama, dan regulasi Polri', 'is_visible' => true, 'sort_order' => 5],
            ['section_key' => 'faq_section', 'title' => 'Pertanyaan Umum (FAQ)', 'subtitle' => 'Informasi penting seputar verifikasi dan rekrutmen', 'is_visible' => true, 'sort_order' => 6],
        ];

        foreach ($sections as $sec) {
            HomepageSection::updateOrCreate(['section_key' => $sec['section_key']], $sec);
        }

        // 3. Banners
        $banners = [
            [
                'title' => 'Rekrutmen Personil Pengamanan Perbankan 2026',
                'subtitle' => 'Penempatan Jabodetabek dengan jaminan BPJS & Tunjangan Pos',
                'image_url' => 'https://images.unsplash.com/photo-1541872703-74c5e44368f9?w=800&auto=format&fit=crop',
                'target_url' => '/jobs?category=perbankan',
                'placement' => 'home_hero',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'title' => 'Pendaftaran Diklat Gada Madya Gelombang III',
                'subtitle' => 'Tingkatkan kualifikasi kepemimpinan Danru & Supervisor Security',
                'image_url' => 'https://images.unsplash.com/photo-1521737711867-e3b97375f902?w=800&auto=format&fit=crop',
                'target_url' => '/articles/panduan-lengkap-ujian-gada-madya',
                'placement' => 'home_hero',
                'sort_order' => 2,
                'is_active' => true,
            ],
        ];

        foreach ($banners as $b) {
            Banner::updateOrCreate(['title' => $b['title']], $b);
        }

        // 4. Career Articles
        $articles = [
            [
                'title' => 'Panduan Lengkap Ujian Gada Pratama dan Syarat Penerbitan KTA',
                'slug' => 'panduan-lengkap-ujian-gada-pratama',
                'excerpt' => 'Pelajari materi ujian kesamaptaan jasmani, bela diri Polri, dan tes psikologi untuk kelulusan Gada Pratama.',
                'content' => "Pendidikan dan Pelatihan Gada Pratama merupakan kualifikasi dasar wajib bagi setiap personil satuan pengamanan di Indonesia berdasarkan Peraturan Kepolisian (Perpol). Peserta akan mengikuti pelatihan 232 jam pelajaran yang mencakup keterampilan dasar tugas jaga, patroli, pengawalan, pengaturan lalin terbatas, dan penanganan tempat kejadian perkara (TKP). Setelah lulus, peserta berhak memperoleh ijazah resmi dan Kartu Tanda Anggota (KTA) yang diterbitkan Polda setempat.",
                'author_name' => 'Kombes (Purn) Suryanto',
                'category' => 'diklat_gada',
                'is_published' => true,
                'published_at' => now(),
            ],
            [
                'title' => '5 Tips Lolos Wawancara Kerja Satpam Perbankan dan Area VIP',
                'slug' => '5-tips-lolos-wawancara-satpam-perbankan',
                'excerpt' => 'Kunci sukses menjawab pertanyaan HRD perbankan: ketelitian, kesigapan sikap tampang, dan etika pelayanan prima (service excellence).',
                'content' => "Dalam seleksi pengamanan perbankan, penguji tidak hanya melihat ketahanan fisik, namun juga 'Hospitality Security' atau kemampuan melayani nasabah dengan ramah tanpa mengurangi kewaspadaan keamanan. Pastikan kerapian seragam PDH, kontak mata yang tegas namun santun, dan pemahaman terkait penanganan situasi darurat di perbankan.",
                'author_name' => 'Tim HRD BUJP Sigap',
                'category' => 'tips_karir',
                'is_published' => true,
                'published_at' => now(),
            ],
            [
                'title' => 'Regulasi Pangkat dan Jenjang Karir Satpam Berdasarkan Perpol',
                'slug' => 'regulasi-pangkat-jenjang-karir-satpam',
                'excerpt' => 'Mengenal struktur kepangkatan: Pelaksana (Gada Pratama), Supervisor (Gada Madya), dan Manajer Keamanan (Gada Utama).',
                'content' => "Profesi satpam kini diakui sebagai profesi berjenjang dengan tanda kepangkatan segitiga merah, perak, dan emas. Melalui platform Satpamku, personil berprestasi dapat dengan mudah mengajukan promosi ke jenjang Danru (Komandan Regu) hingga Chief Security.",
                'author_name' => 'Redaksi Satpamku',
                'category' => 'regulasi',
                'is_published' => true,
                'published_at' => now(),
            ],
        ];

        foreach ($articles as $art) {
            CareerArticle::updateOrCreate(['slug' => $art['slug']], $art);
        }

        // 5. FAQs
        $faqs = [
            [
                'category' => 'kandidat',
                'question' => 'Apakah melamar lowongan satpam di Satpamku dipungut biaya?',
                'answer' => 'Tidak. Pendaftaran akun kandidat dan pengiriman lamaran di Satpamku 100% GRATIS dan bebas dari calo. Perusahaan yang memungut biaya administrasi akan diblokir.',
                'sort_order' => 1,
                'is_active' => true,
            ],
            [
                'category' => 'kandidat',
                'question' => 'Bagaimana jika KTA satpam saya sudah kedaluwarsa?',
                'answer' => 'Anda tetap dapat mendaftar dan mengunggah ijazah Gada Pratama. Namun kami menyarankan segera memperbarui KTA ke Polda/BUJP terkait agar profil Anda mendapatkan lencana Terverifikasi.',
                'sort_order' => 2,
                'is_active' => true,
            ],
            [
                'category' => 'perusahaan',
                'question' => 'Apakah hanya BUJP resmi yang dapat memasang lowongan?',
                'answer' => 'Ya. Seluruh perusahaan penyedia jasa pengamanan (BUJP) maupun pengguna langsung (direct employer) wajib diverifikasi NIB dan izin operasionalnya oleh tim admin Satpamku sebelum lowongan dapat tayang.',
                'sort_order' => 3,
                'is_active' => true,
            ],
            [
                'category' => 'sertifikasi',
                'question' => 'Apa perbedaan Gada Pratama, Gada Madya, dan Gada Utama?',
                'answer' => 'Gada Pratama untuk tingkat pelaksana pengamanan lapangan, Gada Madya untuk tingkat penyelia/Komandan Regu (Danru), dan Gada Utama untuk tingkat manajer keamanan/Chief Security Officer.',
                'sort_order' => 4,
                'is_active' => true,
            ],
        ];

        foreach ($faqs as $f) {
            Faq::updateOrCreate(['question' => $f['question']], $f);
        }
    }
}
