# Satpamku — Flutter Component & Screen Specifications

This specification maps the approved **Google Stitch designs** for all 27 screens into Flutter Material 3 architecture, reusable widgets, data models, state management (Riverpod), and CMS contracts.

---

## 1. Architecture & Widget Design Principles

1. **Strict Separation of Concerns**:
   - UI Widgets only consume Riverpod Notifiers/Providers and dispatch user intents.
   - Repositories (`Dio` HTTP clients) handle all network requests with typed Freezed/json_serializable models.
   - Zero business logic inside build methods.
2. **Component Tokenization**:
   - Zero hardcoded colors, padding, or raw font names in widgets.
   - All styling references `SatpamkuTheme`, `AppColors`, `AppTypography`, `AppSpacing`, and `AppRadius`.
3. **Security-First Domain Requirements**:
   - Specific badges and validation for Indonesian security credentials: **Gada Pratama**, **Gada Madya**, **Gada Utama**, **K3 Umum**, **SKCK**, and **First Aid**.
   - Verified Employer Shield badges.
   - Physical requirements indicators (Height, Weight, Health, Shift type).
   - 7-Stage recruitment pipeline chips with audit trail.

---

## 2. Reusable Core Component Catalog

### 2.1 Top App Bars & Headers
- **`SatpamkuTopAppBar`**:
  - *Parameters*: `String title`, `Widget? leadingAvatar`, `List<Widget>? actions`, `bool hasScrolledUnderBorder`.
  - *Variants*:
    - Standard Candidate Header (Avatar + "Satpamku" logo in Deep Navy + Notification Bell badge).
    - Employer Header (Admin Avatar + "Satpamku" brand + Notification Bell with red dot indicator).
    - Transactional Header (Back Arrow button + Title + Share/Action button).

### 2.2 Search & Discovery Widgets
- **`JobSearchBar`**:
  - *Parameters*: `TextEditingController controller`, `VoidCallback? onTap`, `VoidCallback? onFilterTap`, `bool readOnly`.
  - *Visual*: White Level 1 surface, 1.5px outline border, leading search icon (`#455A64`), placeholder `"Cari lowongan..."`, trailing `tune` filter button (`bg-surface-container-high`).
- **`LocationSelectorPill`**:
  - *Parameters*: `String currentLocation`, `VoidCallback onTap`.
  - *Visual*: Icon `location_on`, location text (e.g. "Jakarta Selatan"), `expand_more` chevron, font `labelLg`.
- **`CategoryGrid`**:
  - *Parameters*: `List<JobCategory> categories`, `Function(JobCategory) onSelect`.
  - *Layout*: 5-column horizontal grid. Rounded 16dp container with subtle icon tint.
  - *Preset categories*: Retail (`storefront`), Residensial (`home_work`), VIP (`star`, brass gold tint), Event (`festival`), Industri (`factory`).

### 2.3 Job Cards & Badges
- **`UrgentJobCard`**:
  - *Parameters*: `Job job`, `VoidCallback onBookmark`, `VoidCallback onTap`.
  - *Visual*: Min width 260dp, horizontal carousel item.
  - *Elements*:
    - Top tag: `local_fire_department` icon + `"Dibutuhkan Segera"` (`errorContainer` bg, `onErrorContainer` text).
    - Bookmark icon button.
    - Title (`headlineSm`), Employer name (`bodyMd`, `slateGray`).
    - Chips: Location, Shift (e.g. "Shift Malam", "Rolling").
- **`StandardJobCard`**:
  - *Parameters*: `Job job`, `bool isFeatured`, `VoidCallback onApply`, `VoidCallback onSave`, `VoidCallback onTap`.
  - *Visual*: Level 1 surface (`#FFFFFF`), 8dp radius, 1px outline-variant border. If featured/recommended, 1.5px Brass Gold right border accent.
  - *Elements*:
    - Company Logo (48x48dp rounded-lg frame).
    - Job Title (`headlineSm`, Deep Navy) + Company Name with Verified Brass Shield icon.
    - Metadata Chips row: Location (`location_on`), Salary (`payments`, e.g. "Rp 5.5 - 6.5 Jt"), Shift (`schedule`).
    - Divider line (1px `outlineVariant`).
    - Footer: "Diposting X waktu lalu" (`labelSm`, `slateGray`) + Primary Action Button (`Lamar` / `Simpan`).

### 2.4 Certification & Verification Badges
- **`CertificationBadge`**:
  - *Parameters*: `CertificationType type`, `VerificationStatus status`, `DateTime? expiresAt`.
  - *Types*: `gadaPratama`, `gadaMadya`, `gadaUtama`, `k3Umum`, `skck`, `firstAid`.
  - *Visual*: Brass Gold shield icon + verified checkmark (`successGreen`). Displays issuer and expiry warning when applicable.
- **`VerifiedEmployerBadge`**:
  - *Visual*: Brass Gold fill shield with checkmark (`#C5A059`, 16dp).

### 2.5 Application Pipeline & Status Chips
- **`ApplicationStatusChip`**:
  - *Parameters*: `ApplicationStage stage` (`submitted`, `reviewed`, `shortlisted`, `interview`, `assessment`, `offer`, `hired`, `rejected`, `withdrawn`).
  - *Styling*:
    - `submitted`: Neutral surface container (`#EDEEEF`), text `#454652`.
    - `reviewed` / `shortlisted`: Soft Primary Tint (`#E0E0FF`), text `#000767`.
    - `interview` / `assessment`: Golden Amber Tint (`#FFDEA5`), text `#5D4201`.
    - `offer` / `hired`: Pale Mint Green (`#A3F69C`), text `#005312`.
    - `rejected`: Pale Red (`#FFDAD6`), text `#93000A`.
    - `withdrawn`: Neutral slate gray.

### 2.6 Candidate CV & Document Components
- **`ProfileCompletionCard`**:
  - *Parameters*: `int percentage`, `String statusLabel`.
  - *Visual*: Deep Navy title, percentage display, linear animated progress bar (`#000666` fill on `#E1E3E4` track).
- **`CandidateCvCard`**:
  - *Parameters*: `CandidateProfile profile`, `bool showContactInfo`.
  - *Visual*: Security CV formatting. Headshot with "Ready to Work" green status dot, headline, location, verified credentials list, physical attributes row (Height, Weight, Age), experience timeline, skills chips.
- **`DocumentUploadCard`**:
  - *Parameters*: `DocumentType type`, `String? fileName`, `VerificationStatus status`, `VoidCallback onUpload`.
  - *Visual*: Outlined card with upload state, progress bar, file size validation indicator, and verification status pill.

### 2.7 Employer & Recruiter Components
- **`RecruiterBentoStats`**:
  - *Parameters*: `int activeVacancies`, `int newApplicants`, `int interviewsScheduled`, `int totalHired`.
  - *Visual*: 2x2 grid (mobile) or 4-col bento (desktop/tablet). Number count (`headlineLg`, Deep Navy), delta badge (+2 this week), background icon watermark.
- **`RecruitmentPipelineKanban`**:
  - *Parameters*: `Map<ApplicationStage, List<ApplicantSummary>> columns`, `Function(String applicantId, ApplicationStage targetStage) onStageChanged`.
  - *Visual*: Horizontal scrollable columns (Applied, Screening, Interview, Assessment, Offer, Hired) with drag-and-drop card support and count badges.
- **`ApplicantListItem`**:
  - *Parameters*: `Applicant applicant`, `VoidCallback onTap`, `VoidCallback onQuickAction`.
  - *Visual*: Avatar, full name, certification pill (e.g. "Gada Pratama Verified"), years of experience, current stage chip, rating, match score percentage.

### 2.8 Common UI State Components
- **`LoadingSkeleton`**: Shimmer placeholders with identical layout dimensions to real cards.
- **`EmptyStateWidget`**: Icon, contextual title, subtitle, and primary call-to-action button.
- **`ErrorStateWidget`**: Error icon, humanized Indonesian error message, retry button.
- **`AppBottomNavigationBar`**:
  - Candidate 5 Tabs: `Home` (`home`), `Jobs` (`work`), `Saved` (`bookmark`), `Applied` (`assignment_turned_in`), `Profile` (`person`).
  - Employer 5 Tabs: `Dashboard` (`dashboard`), `My Jobs` (`business_center`), `Applicants` (`groups`), `Messages` (`mail`), `Settings` (`settings`).

---

## 3. Screen Specifications (27 Screens)

### 3.1 Auth & Onboarding Flow
1. **`SplashScreen`**:
   - Center brand mark: Deep Navy shield logo + "Satpamku" typography + Brass Gold tagline "Portal Karir Satpam Terpercaya".
   - Token inspection: auto-route to Home (Candidate), Dashboard (Employer), or Onboarding.
2. **`OnboardingScreen`**:
   - 3-slide visual onboarding carousel highlighting:
     - (1) Lowongan Resmi & Terverifikasi
     - (2) Verifikasi Sertifikat Gada Pratama/Madya/Utama
     - (3) Rekrutmen Cepat & Terpantau
   - Role selector prompt: "Masuk sebagai Satpam" vs "Masuk sebagai Perusahaan".
3. **`LoginScreen`**:
   - Tab switch: Satpam vs Perusahaan.
   - Form: Email / Phone, Password, Remember Me, Forgot Password.
   - Primary Deep Navy CTA button `"Masuk"`.
4. **`RegisterSatpamScreen`**:
   - Fields: Nama Lengkap, Nomor HP/WhatsApp, Email, Password, Tingkat Sertifikat Satpam (Belum Ada, Gada Pratama, Gada Madya, Gada Utama), Domisili Kota.
5. **`RegisterEmployerScreen`**:
   - Fields: Nama Perusahaan / BUJP (Badan Usaha Jasa Pengamanan), Nomor NIB/Izin Operasional, Nama PIC, Email Kantor, No. Telp Kantor, Alamat Kantor, Kota.

### 3.2 Candidate Flow
6. **`HomeScreen`**:
   - **CMS Dynamic Section Renderer**:
     - `hero`: Header greeting ("Halo, Bpk. Ahmad. Siap bertugas hari ini?").
     - `job_search`: Search bar + location selector pill.
     - `categories`: 5-column category icon grid.
     - `urgent_hiring`: Horizontal scrolling Urgent Job Cards with flame badge.
     - `recommended_jobs`: Vertical list of Standard Job Cards with Brass Gold accents.
     - `career_resources`: "Gada Pratama Training" banner card with deep navy background and gold CTA button.
7. **`JobSearchScreen`**:
   - Instant search auto-complete, recent searches history chips, popular search terms.
8. **`SearchFilterSheet`**:
   - Modal BottomSheet filter controls:
     - Lokasi (Kota / Radius KM).
     - Rentang Gaji (Slider min-max).
     - Sertifikasi Wajib (Gada Pratama, Gada Madya, Gada Utama, K3).
     - Tipe Shift (Pagi, Malam, 2-Shift, 3-Shift, Rolling).
     - Tipe Pekerjaan (Full-time, Kontrak, Event/Harian).
     - Fasilitas (BPJS, Seragam, Makan, Mess/Tempat Tinggal).
     - Hanya Perusahaan Terverifikasi (Toggle Switch).
9. **`SearchResultsScreen`**:
   - Active filter chips row + sort dropdown (Relevansi, Gaji Tertinggi, Terbit Terbaru, Jarak Terdekat).
   - Paginated job list with infinite scroll.
10. **`JobDetailScreen`**:
    - Sticky top bar with Back + Share + Bookmark.
    - Header: Company Logo, Title, Verified Badge, Location, Time posted.
    - 3-Column Quick Metrics: Gaji (Rp 5.5 - 7M/bulan), Shift (2-Shift), Tipe (Full-Time).
    - Sections: Job Description, Requirements (Gada Pratama, Min Experience, Height/Weight, SKCK), Facilities/Benefits grid (BPJS, Seragam, Mess), Employer Profile snippet.
    - Sticky Bottom Action: Prominent Deep Navy `"Lamar Sekarang"` CTA.
11. **`CompanyDetailScreen`**:
    - Cover banner, logo, verified BUJP badge, company overview, active vacancies list, company gallery/locations.
12. **`SavedJobsScreen`**:
    - List of bookmarked jobs with quick apply action and removal swipe.
13. **`ApplicationStatusScreen`**:
    - Candidate list of active & completed applications.
    - Stage progress indicator (e.g. "Tahap 3 dari 7: Interview").
14. **`ApplicationDetailScreen`**:
    - Detailed vertical stepper timeline of status changes with recruiter notes, interview schedules, assessment links, and offer letters.
15. **`CandidateProfileScreen`**:
    - Bento Grid: Profile Info Card + Verification status pill + "Ready to Work" indicator + Profile Completion progress bar (85%).
    - Certifications list with verified checkmarks.
    - Experience timeline, Physical Attributes (Tinggi: 172cm, Berat: 68kg), Skills chips.
16. **`EditProfileScreen`**:
    - Multi-tab form for editing personal info, physical bio, experience, skills, and job preferences.
17. **`CertificationsScreen`**:
    - Management screen for candidate certificates (Upload document, fill certificate number, issuing Polda/BNSP, expiry date).
18. **`CvDocumentsScreen`**:
    - Secure storage manager for CV, KTP, SKCK, Surat Keterangan Sehat, and Ijazah.
19. **`NotificationsScreen`**:
    - Grouped list (Applications, Job Alerts, Reminders, System announcements) with unread indicators.
20. **`MessagesScreen`**:
    - Chat/messaging interface between candidate and verified recruiters.
21. **`SettingsScreen`**:
    - Account settings, Profile Visibility (Public / Hanya Perusahaan Terverifikasi / Private), Push Notifications toggle, Security/Password, Log out.

### 3.3 Employer Flow
22. **`EmployerDashboardScreen`**:
    - Bento grid stats (Active Vacancies, New Applicants, Interviews, Hires).
    - Quick actions: `"Pasang Lowongan Baru"`, `"Review Pelamar"`.
    - Recent applicants list & active vacancies overview.
23. **`CreateJobPostScreen`**:
    - Step-by-step form:
      - Step 1: Posisi, Kategori, Jumlah Lowongan, Tipe Pekerjaan.
      - Step 2: Lokasi Penempatan, Shift Kerja.
      - Step 3: Gaji Min-Max, Periode Gaji.
      - Step 4: Persyaratan Khusus (Tingkat Gada, Tinggi Min, Pengalaman Min, SKCK).
      - Step 5: Fasilitas (BPJS, Seragam, Makan, Mess).
      - Step 6: Review & Publish.
24. **`JobManagementScreen`**:
    - Tabbed view: Published, Draft, In Review, Paused, Closed.
    - Job actions: Edit, Pause, Close, Duplicate, View Applicants.
25. **`ApplicantListScreen`**:
    - Filterable table/card list of applicants per job post with quick status actions (Shortlist, Reject, Invite Interview).
26. **`ApplicantDetailScreen`**:
    - Complete Candidate CV view + Document preview + Private recruiter notes + Stage move action bar (Kirim Undangan Interview, Beri Penawaran, Tolak).
27. **`RecruitmentPipelineScreen`**:
    - Kanban pipeline board (Applied -> Screening -> Interview -> Assessment -> Offer -> Hired) with drag-and-drop support.

---

## 4. CMS Allowlisted Dynamic Section Renderer Contract

The Flutter Candidate Home screen maps the backend JSON configuration directly to registered native widgets:

```dart
Widget renderCmsSection(HomepageSectionModel section) {
  switch (section.type) {
    case 'hero':
      return CmsHeroGreetingSection(config: section.config);
    case 'job_search':
      return CmsSearchBarSection(config: section.config);
    case 'categories':
      return CmsCategoriesSection(config: section.config);
    case 'urgent_hiring':
      return CmsUrgentHiringSection(config: section.config);
    case 'featured_jobs':
    case 'recommended_jobs':
      return CmsFeaturedJobsSection(config: section.config);
    case 'verified_employers':
      return CmsVerifiedEmployersSection(config: section.config);
    case 'career_articles':
    case 'career_resources':
      return CmsCareerResourcesSection(config: section.config);
    case 'cta':
      return CmsCallToActionSection(config: section.config);
    default:
      return const SizedBox.shrink();
  }
}
```

*Note: The backend never sends executable Dart or CSS. The mobile client retains full control over styling, accessibility, and rendering.*
