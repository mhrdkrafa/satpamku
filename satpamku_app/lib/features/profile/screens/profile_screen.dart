import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/candidate_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;
    final profileAsync = ref.watch(candidateFullProfileProvider);

    if (!authState.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Akun Satpamku')),
        body: Center(
          child: Padding(
            padding: AppSpacing.paddingScreen,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle_outlined, size: 64, color: AppColors.primaryLight),
                const SizedBox(height: AppSpacing.lg),
                Text('Masuk ke Akun Anda', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.xs),
                Text('Masuk atau buat akun baru untuk mengakses profil dan lamaran Anda.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextSecondary)),
                const SizedBox(height: AppSpacing.xl),
                ElevatedButton(
                  onPressed: () => context.push('/login'),
                  child: const Text('Masuk / Daftar'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(candidateFullProfileProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              if (user?.role == 'employer') ...[
                AppCard(
                  backgroundColor: AppColors.primary,
                  onTap: () => context.go('/employer/dashboard'),
                  child: Row(
                    children: [
                      const Icon(Icons.business_center, color: AppColors.secondary, size: 28),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Portal Perusahaan BUJP',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Kelola lowongan kerja & tinjau pelamar masuk',
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.secondaryLight),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              // User Card
              AppCard(
                child: Column(
                  children: [
                    AppAvatar(
                      name: user?.name ?? 'Satpam',
                      imageUrl: user?.avatarUrl,
                      radius: 36,
                      isVerified: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      user?.name ?? '',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user?.email ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: [
                        if (user?.highestCertificateLevel != null && user!.highestCertificateLevel != 'none')
                          AppBadge.certificate(user.highestCertificateLevel!),
                        const AppBadge(label: 'KTA Aktif', variant: AppBadgeVariant.success, isSmall: true),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Menu Options Card
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.person_outline,
                      title: 'Data Diri & Fisik',
                      subtitle: 'Tinggi badan, berat badan, SIM, kontak',
                      onTap: () => context.push('/edit-profile'),
                    ),
                    const Divider(height: 1, color: AppColors.lightBorder),
                    _buildMenuItem(
                      icon: Icons.work_outline,
                      title: 'Pengalaman Kerja',
                      subtitle: 'Riwayat penempatan pengamanan sebelumnya',
                      onTap: () => context.push('/experiences'),
                    ),
                    const Divider(height: 1, color: AppColors.lightBorder),
                    _buildMenuItem(
                      icon: Icons.verified_user_outlined,
                      title: 'Sertifikasi & KTA',
                      subtitle: 'Gada Pratama, Madya, Utama & masa berlaku',
                      onTap: () => context.push('/certifications'),
                    ),
                    const Divider(height: 1, color: AppColors.lightBorder),
                    _buildMenuItem(
                      icon: Icons.description_outlined,
                      title: 'Dokumen & CV',
                      subtitle: 'File CV, KTP, SKCK, Surat Bebas Narkoba',
                      onTap: () => context.push('/documents'),
                    ),
                    const Divider(height: 1, color: AppColors.lightBorder),
                    _buildMenuItem(
                      icon: Icons.bookmark_border,
                      title: 'Lowongan Tersimpan',
                      subtitle: 'Daftar bookmark pekerjaan yang Anda minati',
                      onTap: () => context.push('/saved-jobs'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Settings Menu
              AppCard(
                padding: EdgeInsets.zero,
                child: _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Pengaturan Akun',
                  subtitle: 'Tema, notifikasi, dan keamanan',
                  onTap: () => context.push('/settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.lightTextMuted),
      onTap: onTap,
    );
  }
}
