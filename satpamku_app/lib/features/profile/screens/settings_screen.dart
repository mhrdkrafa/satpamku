import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = true;

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
        title: const Text('Keluar dari Akun?'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi Satpamku?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await ref.read(authStateProvider.notifier).logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(title: const Text('Pengaturan')),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreen,
        child: Column(
          children: [
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Notifikasi Lowongan Baru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Pemberitahuan instan saat ada lowongan sesuai kualifikasi Anda', style: TextStyle(fontSize: 12)),
                    value: _pushNotifications,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _pushNotifications = val),
                  ),
                  const Divider(height: 1, color: AppColors.lightBorder),
                  SwitchListTile(
                    title: const Text('Email Pengingat Sertifikat', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Kirim email peringatan 30 hari sebelum KTA kedaluwarsa', style: TextStyle(fontSize: 12)),
                    value: _emailAlerts,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _emailAlerts = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Syarat & Ketentuan Layanan', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.lightTextMuted),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.lightBorder),
                  ListTile(
                    title: const Text('Kebijakan Privasi & Dokumen KTA', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: AppColors.lightTextMuted),
                    onTap: () {},
                  ),
                  const Divider(height: 1, color: AppColors.lightBorder),
                  ListTile(
                    title: const Text('Tentang Satpamku v1.0.0', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Platform Rekrutmen & Karir Satpam Indonesia', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            AppButton(
              text: 'Keluar dari Akun',
              variant: AppButtonVariant.danger,
              icon: Icons.logout,
              onPressed: _handleLogout,
            ),
          ],
        ),
      ),
    );
  }
}
