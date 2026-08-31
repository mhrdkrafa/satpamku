import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../auth/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  Future<void> _handleLogout() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Keluar dari Akun?',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1B2A72)),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari akun Satpamku?',
          style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Batal', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.white)),
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

  void _showChangePasswordDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ubah Kata Sandi',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1B2A72)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPasswordController,
              obscureText: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Kata Sandi Lama',
                labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
              decoration: InputDecoration(
                labelText: 'Kata Sandi Baru',
                labelStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B2A72)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kata sandi berhasil diperbarui!'),
                  backgroundColor: Color(0xFF16A34A),
                ),
              );
            },
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _show2FaDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Keamanan & 2FA',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1B2A72)),
        ),
        content: Text(
          'Autentikasi dua faktor (2FA) melalui WhatsApp/SMS aktif untuk melindungi akun satpam Anda dari akses tidak sah.',
          style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569)),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B2A72)),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Bantuan & Dukungan Satpamku',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1B2A72)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pusat Layanan Satpamku Indonesia:',
              style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 8),
            Text('• WhatsApp CS: +62 812-8888-7287', style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569))),
            Text('• Email: support@satpamku.id', style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569))),
            Text('• Jam Operasional: 24/7 Siaga', style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569))),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B2A72)),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Ketentuan & Privasi',
          style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1B2A72)),
        ),
        content: SingleChildScrollView(
          child: Text(
            'Satpamku berkomitmen menjaga privasi data KTP, KTA, SKCK, dan riwayat tugas Anda sesuai standar Perpol No. 4 Tahun 2020 dan UU Perlindungan Data Pribadi (PDP).',
            style: TextStyle(color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569), height: 1.4),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B2A72)),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Tutup', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeModeProvider);

    final bgScaffold = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final bgCard = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final textTitleColor = isDark ? Colors.white : const Color(0xFF1B2A72);
    final textSubtitleColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final iconBgColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final iconColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1B2A72);

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
            icon: Icon(Icons.notifications_none, color: textTitleColor, size: 24),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Subtitle
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textTitleColor,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your account preferences and app configurations.',
              style: TextStyle(fontSize: 13, color: textSubtitleColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),

            // SECTION 1: Account Settings
            _buildSectionHeader(Icons.person_outline, 'Account Settings', textTitleColor),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.mail_outline,
                    iconBg: iconBgColor,
                    iconColor: iconColor,
                    title: 'Email Address',
                    subtitle: user?.email ?? 'budi.santoso@satpamku.id',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email terdaftar: ${user?.email ?? "budi.santoso@satpamku.id"}')),
                      );
                    },
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildSettingTile(
                    icon: Icons.lock_outline,
                    iconBg: iconBgColor,
                    iconColor: iconColor,
                    title: 'Password',
                    subtitle: 'Ubah kata sandi akun Satpamku',
                    onTap: _showChangePasswordDialog,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildSettingTile(
                    icon: Icons.shield_outlined,
                    iconBg: iconBgColor,
                    iconColor: iconColor,
                    title: 'Security & 2FA',
                    subtitle: 'Two-factor authentication aktif',
                    onTap: _show2FaDialog,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // SECTION 2: Preferences
            _buildSectionHeader(Icons.tune, 'Preferences', textTitleColor),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.notifications_none,
                    iconBg: iconBgColor,
                    iconColor: iconColor,
                    title: 'Notifications',
                    subtitle: 'Push notifikasi lamaran & panggilan kerja',
                    onTap: () => context.push('/notifications'),
                  ),
                  Divider(height: 1, color: borderColor),

                  // Dark Mode Switch Tile
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF312E81) : const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            isDark ? Icons.dark_mode : Icons.light_mode,
                            size: 20,
                            color: isDark ? const Color(0xFF818CF8) : const Color(0xFF4F46E5),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mode Gelap (Dark Mode)',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isDark ? 'Tema gelap aktif' : 'Tema terang aktif',
                                style: TextStyle(fontSize: 11.5, color: textSubtitleColor),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isDark,
                          activeColor: const Color(0xFF818CF8),
                          activeTrackColor: const Color(0xFF312E81),
                          onChanged: (val) {
                            ref.read(themeModeProvider.notifier).setThemeMode(
                              val ? ThemeMode.dark : ThemeMode.light,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: borderColor),

                  // Language Tile
                  _buildSettingTile(
                    icon: Icons.language,
                    iconBg: iconBgColor,
                    iconColor: iconColor,
                    title: 'Language',
                    subtitle: 'Bahasa Indonesia (Default)',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Bahasa Indonesia terpilih sebagai bahasa default.')),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // SECTION 3: Support & About
            _buildSectionHeader(Icons.headset_mic_outlined, 'Support & About', textTitleColor),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: bgCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _buildSettingTile(
                    icon: Icons.help_outline,
                    iconBg: iconBgColor,
                    iconColor: iconColor,
                    title: 'Help & Support Center',
                    subtitle: 'FAQ, panduan verifikasi KTA & rekrutmen',
                    onTap: _showHelpDialog,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildSettingTile(
                    icon: Icons.description_outlined,
                    iconBg: iconBgColor,
                    iconColor: iconColor,
                    title: 'Terms & Privacy Policy',
                    subtitle: 'Ketentuan layanan & proteksi data KTA',
                    onTap: _showTermsDialog,
                  ),
                  Divider(height: 1, color: borderColor),
                  _buildSettingTile(
                    icon: Icons.logout,
                    iconColor: const Color(0xFFEF4444),
                    iconBg: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2),
                    title: 'Log Out',
                    subtitle: 'Keluar dari akun aplikasi Satpamku',
                    isDestructive: true,
                    onTap: _handleLogout,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    Color? iconColor,
    Color? iconBg,
    required String title,
    required String subtitle,
    bool isDestructive = false,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDestructive
        ? const Color(0xFFEF4444)
        : (isDark ? Colors.white : const Color(0xFF1E293B));
    final subColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg ?? (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: iconColor ?? (isDark ? Colors.white : const Color(0xFF1B2A72))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11.5, color: subColor),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: isDestructive ? const Color(0xFFEF4444) : (isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E1)),
            ),
          ],
        ),
      ),
    );
  }
}
