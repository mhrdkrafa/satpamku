import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/candidate_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final profileAsync = ref.watch(candidateFullProfileProvider);

    if (!authState.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Akun Satpamku')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle_outlined, size: 64, color: Color(0xFF1B2A72)),
                const SizedBox(height: 16),
                const Text(
                  'Masuk ke Akun Anda',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Masuk atau buat akun baru untuk mengakses profil dan lamaran Anda.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AppAvatar(
            name: user?.name ?? 'Satpam',
            imageUrl: user?.avatarUrl,
            radius: 18,
          ),
        ),
        title: const Text(
          'Satpamku',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF1B2A72), size: 22),
            onPressed: () => context.push('/profile/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1B2A72), size: 24),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
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
                        Stack(
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                                    ? Image.network(
                                        user.avatarUrl!,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Center(
                                          child: Icon(Icons.person, size: 48, color: Color(0xFF1B2A72)),
                                        ),
                                      )
                                    : const Center(
                                        child: Icon(Icons.person, size: 48, color: Color(0xFF1B2A72)),
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
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user?.name ?? 'Budi Santoso',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2A72),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user?.highestCertificateLevel != null && user!.highestCertificateLevel != 'none'
                              ? 'Security Specialist • ${user.highestCertificateLevel!.toUpperCase()}'
                              : 'Senior Security Guard',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF64748B)),
                            SizedBox(width: 4),
                            Text(
                              'Jakarta Selatan, Indonesia',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 1: Profile Completion & Availability
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Profile Completion',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        Text(
                          '85%  Very Good',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 0.85,
                        minHeight: 6,
                        backgroundColor: Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1B2A72)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Availability',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.event_available, color: Color(0xFF16A34A), size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Ready to Work',
                            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 2: Certifications
              _buildSectionCard(
                title: 'Certifications',
                icon: Icons.workspace_premium_outlined,
                onAddTap: () => context.push('/profile/certifications'),
                child: Column(
                  children: [
                    _buildCertItem('Gada Pratama', 'Polda Metro Jaya • 2020', isVerified: true),
                    const SizedBox(height: 8),
                    _buildCertItem('K3 Umum', 'BNSP • 2021', isVerified: true),
                    const SizedBox(height: 8),
                    _buildCertItem('First Aid Training', 'PMI • 2022', isVerified: false),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 3: Skills
              _buildSectionCard(
                title: 'Skills',
                icon: Icons.psychology_outlined,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSkillChip(Icons.sports_kabaddi, 'Martial Arts'),
                    _buildSkillChip(Icons.videocam_outlined, 'CCTV Operation'),
                    _buildSkillChip(Icons.directions_walk, 'Patrolling'),
                    _buildSkillChip(Icons.groups_outlined, 'Crowd Control'),
                    _buildSkillChip(Icons.local_fire_department_outlined, 'Fire Safety'),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // CARD 4: Experience
              _buildSectionCard(
                title: 'Experience',
                icon: Icons.work_outline,
                onAddTap: () => context.push('/profile/experiences/add'),
                child: Column(
                  children: [
                    _buildExperienceItem(
                      title: 'Chief Security Officer',
                      company: 'PT. Garda Tama Nusantara',
                      period: '2021 - Present',
                      description:
                          'Led a team of 15 security personnel for a major commercial complex. Implemented new access control procedures resulting in a 30% reduction in unauthorized entry incidents.',
                      isCurrent: true,
                    ),
                    _buildExperienceItem(
                      title: 'Security Guard',
                      company: 'Menara Sudirman',
                      period: '2018 - 2021',
                      description:
                          'Responsible for front desk security, visitor registration, and CCTV monitoring. Handled VIP escorts and recognized as Guard of the Month twice in 2019.',
                    ),
                    _buildExperienceItem(
                      title: 'Junior Security',
                      company: 'Retail Sentosa Mas',
                      period: '2016 - 2018',
                      description: 'Assisted in daily retail store security operations, focusing on loss prevention and customer safety.',
                      isLast: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Settings & Logout Button
              ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                leading: const Icon(Icons.settings_outlined, color: Color(0xFF1B2A72)),
                title: const Text('Pengaturan & Akun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                trailing: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                onTap: () => context.push('/settings'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    VoidCallback? onAddTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: const Color(0xFF1B2A72)),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2A72),
                    ),
                  ),
                ],
              ),
              if (onAddTap != null)
                IconButton(
                  icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF1B2A72)),
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

  Widget _buildCertItem(String title, String issuer, {required bool isVerified}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Icon(Icons.badge_outlined, color: Color(0xFF1B2A72), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 2),
                Text(
                  issuer,
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                ),
                if (isVerified) ...[
                  const SizedBox(height: 2),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, size: 11, color: Color(0xFF16A34A)),
                      SizedBox(width: 4),
                      Text(
                        'Verified',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF475569)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
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
    bool isCurrent = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCurrent ? const Color(0xFF1B2A72) : const Color(0xFFCBD5E1),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 110,
                color: const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 2),
              Text(
                company,
                style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  period,
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.4),
              ),
              const SizedBox(height: 14),
            ],
          ),
        ),
      ],
    );
  }
}
