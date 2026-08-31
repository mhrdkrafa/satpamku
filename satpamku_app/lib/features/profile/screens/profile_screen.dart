import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/candidate_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final profileAsync = ref.watch(candidateFullProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgScaffold = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final bgCard = isDark ? const Color(0xFF1E293B) : Colors.white;
    final bgInnerCard = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textTitleColor = isDark ? Colors.white : const Color(0xFF1B2A72);
    final textBodyColor = isDark ? const Color(0xFFCBD5E1) : const Color(0xFF1E293B);
    final textSubtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    if (!authState.isAuthenticated) {
      return Scaffold(
        backgroundColor: bgScaffold,
        appBar: AppBar(
          backgroundColor: bgCard,
          title: Text('Akun Satpamku', style: TextStyle(color: textTitleColor, fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_circle_outlined, size: 64, color: isDark ? const Color(0xFF818CF8) : const Color(0xFF1B2A72)),
                const SizedBox(height: 16),
                Text(
                  'Masuk ke Akun Anda',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textTitleColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masuk atau buat akun baru untuk mengakses profil dan lamaran Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: textSubtitleColor),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.push('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2A72),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Masuk / Daftar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgScaffold,
      appBar: AppBar(
        backgroundColor: bgCard,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AppAvatar(
            name: user?.name ?? 'Satpam',
            imageUrl: user?.avatarUrl,
            radius: 18,
          ),
        ),
        title: Text(
          'Satpamku',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textTitleColor,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: textTitleColor, size: 22),
            onPressed: () => context.push('/profile/edit'),
          ),
          IconButton(
            icon: Icon(Icons.notifications_none, color: textTitleColor, size: 24),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(candidateFullProfileProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // TOP PROFILE CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: bgCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, size: 12, color: Color(0xFF16A34A)),
                            SizedBox(width: 4),
                            Text(
                              'Verified',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        // Avatar Photo
                        InkWell(
                          onTap: () => context.push('/profile/edit'),
                          borderRadius: BorderRadius.circular(18),
                          child: Stack(
                            children: [
                              Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: borderColor, width: 2),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                                      ? Image.network(
                                          user.avatarUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Center(
                                            child: Icon(Icons.person, size: 48, color: textTitleColor),
                                          ),
                                        )
                                      : Center(
                                          child: Icon(Icons.person, size: 48, color: textTitleColor),
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF22C55E),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: bgCard, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.name ?? 'Budi Santoso',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textTitleColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user?.highestCertificateLevel != null && user!.highestCertificateLevel != 'none'
                              ? 'Security Specialist • ${user.highestCertificateLevel!.toUpperCase()}'
                              : 'Senior Security Guard',
                          style: TextStyle(
                            fontSize: 13,
                            color: textSubtitleColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: textSubtitleColor),
                            const SizedBox(width: 4),
                            Text(
                              'Jakarta Selatan, Indonesia',
                              style: TextStyle(fontSize: 12.5, color: textSubtitleColor, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Badges Row
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildProfileBadge('GADA PRATAMA', const Color(0xFFFEF3C7), const Color(0xFFD97706)),
                            _buildProfileBadge('K3 CERTIFIED', const Color(0xFFEEF2FF), const Color(0xFF4F46E5)),
                            _buildProfileBadge('AVAILABLE', const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(height: 1, color: Color(0xFFE2E8F0)),
                        const SizedBox(height: 14),

                        // Stats: Height, Weight, Experience
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('178 cm', 'HEIGHT', isDark),
                            _buildStatDivider(borderColor),
                            _buildStatItem('75 kg', 'WEIGHT', isDark),
                            _buildStatDivider(borderColor),
                            _buildStatItem('5 Years', 'EXPERIENCE', isDark),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 1: About Me
              _buildSectionCard(
                title: 'About Me',
                icon: Icons.person_outline,
                isDark: isDark,
                bgCard: bgCard,
                borderColor: borderColor,
                textTitleColor: textTitleColor,
                child: Text(
                  'Dedicated and certified security professional with over 5 years of experience in commercial building security, VIP protection, and access control. Proficient in CCTV operations, emergency protocols, and crowd control management.',
                  style: TextStyle(fontSize: 12.5, color: textSubtitleColor, height: 1.5),
                ),
              ),
              const SizedBox(height: 14),

              // CARD 2: Certifications
              _buildSectionCard(
                title: 'Certifications',
                icon: Icons.workspace_premium_outlined,
                isDark: isDark,
                bgCard: bgCard,
                borderColor: borderColor,
                textTitleColor: textTitleColor,
                onAddTap: () => context.push('/profile/certifications'),
                child: Column(
                  children: [
                    _buildCertItem('Gada Pratama', 'Polda Metro Jaya • 2020', isDark, isVerified: true),
                    const SizedBox(height: 8),
                    _buildCertItem('K3 Umum', 'BNSP • 2021', isDark, isVerified: true),
                    const SizedBox(height: 8),
                    _buildCertItem('First Aid Training', 'PMI • 2022', isDark, isVerified: false),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 3: Skills
              _buildSectionCard(
                title: 'Skills',
                icon: Icons.psychology_outlined,
                isDark: isDark,
                bgCard: bgCard,
                borderColor: borderColor,
                textTitleColor: textTitleColor,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSkillChip(Icons.sports_kabaddi, 'Bela Diri / Martial Arts', isDark),
                    _buildSkillChip(Icons.videocam_outlined, 'CCTV Operation', isDark),
                    _buildSkillChip(Icons.directions_walk, 'Patroli Keamanan', isDark),
                    _buildSkillChip(Icons.groups_outlined, 'Crowd Control', isDark),
                    _buildSkillChip(Icons.local_fire_department_outlined, 'Damkar & K3', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 4: Experience
              _buildSectionCard(
                title: 'Riwayat Tugas & Penempatan',
                icon: Icons.work_outline,
                isDark: isDark,
                bgCard: bgCard,
                borderColor: borderColor,
                textTitleColor: textTitleColor,
                onAddTap: () => context.push('/profile/experiences/add'),
                child: Column(
                  children: [
                    _buildExperienceItem(
                      title: 'Chief Security Officer',
                      company: 'PT. Garda Tama Nusantara',
                      period: '2021 - Sekarang',
                      description: 'Memimpin regu keamanan 15 personel untuk kompleks perkantoran komersial Sudirman.',
                      isDark: isDark,
                      isCurrent: true,
                    ),
                    _buildExperienceItem(
                      title: 'Security Guard / Danru',
                      company: 'Mall Kelapa Gading',
                      period: '2018 - 2021',
                      description: 'Bertanggung jawab atas akses masuk utama, penanganan tamu VIP, dan patroli rutin.',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Dokumen & Berkas Tile
              ListTile(
                tileColor: bgCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: borderColor),
                ),
                leading: Icon(Icons.folder_shared_outlined, color: textTitleColor),
                title: Text('Dokumen & Berkas (KTP, SKCK, CV)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textBodyColor)),
                subtitle: Text('Kelola berkas verifikasi dan lamaran kerja', style: TextStyle(fontSize: 11.5, color: textSubtitleColor)),
                trailing: Icon(Icons.chevron_right, color: textSubtitleColor),
                onTap: () => context.push('/profile/documents'),
              ),
              const SizedBox(height: 10),

              // Settings & Logout Button
              ListTile(
                tileColor: bgCard,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: borderColor),
                ),
                leading: Icon(Icons.settings_outlined, color: textTitleColor),
                title: Text('Pengaturan & Mode Gelap', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5, color: textBodyColor)),
                subtitle: Text('Kelola preferensi akun dan tampilan tema', style: TextStyle(fontSize: 11.5, color: textSubtitleColor)),
                trailing: Icon(Icons.chevron_right, color: textSubtitleColor),
                onTap: () => context.push('/settings'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileBadge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.bold,
          color: text,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1B2A72),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider(Color borderColor) {
    return Container(
      width: 1,
      height: 28,
      color: borderColor,
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    required bool isDark,
    required Color bgCard,
    required Color borderColor,
    required Color textTitleColor,
    VoidCallback? onAddTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: textTitleColor),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textTitleColor,
                    ),
                  ),
                ],
              ),
              if (onAddTap != null)
                IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 20, color: textTitleColor),
                  onPressed: onAddTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildCertItem(String title, String issuer, bool isDark, {required bool isVerified}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Icon(Icons.badge_outlined, color: isDark ? const Color(0xFF818CF8) : const Color(0xFF1B2A72), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E293B)),
                ),
                const SizedBox(height: 2),
                Text(
                  issuer,
                  style: TextStyle(fontSize: 11.5, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          if (isVerified)
            const Icon(Icons.verified, size: 18, color: Color(0xFF16A34A)),
        ],
      ),
    );
  }

  Widget _buildSkillChip(IconData icon, String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: isDark ? const Color(0xFF818CF8) : const Color(0xFF1B2A72)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem({
    required String title,
    required String company,
    required String period,
    required String description,
    required bool isDark,
    bool isCurrent = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E293B)),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('Aktif', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '$company • $period',
            style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF818CF8) : const Color(0xFF1B2A72), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), height: 1.35),
          ),
        ],
      ),
    );
  }
}
