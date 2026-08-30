import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedCertLevel = 'none';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ref.read(authStateProvider.notifier).registerCandidate(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _confirmPasswordController.text,
          highestCertificateLevel: _selectedCertLevel,
        );

    if (success && mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Daftar Akun Satpam'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingScreen,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buat Profil Karir Anda',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Lengkapi data untuk terhubung dengan perusahaan keamanan resmi.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (authState.errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.errorLight,
                      borderRadius: AppSpacing.roundedMd,
                      border: Border.all(color: AppColors.error.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            authState.errorMessage!,
                            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
                AppTextField(
                  label: 'Nama Lengkap (sesuai KTP)',
                  hint: 'Contoh: Ahmad Fauzi',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.lightTextMuted),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Nama lengkap wajib diisi.' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Nomor WhatsApp Aktif',
                  hint: '081234567890',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.lightTextMuted),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Nomor WhatsApp wajib diisi.' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Alamat Email',
                  hint: 'ahmad.fauzi@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.lightTextMuted),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Email wajib diisi.' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Tingkat Sertifikasi Gada Tertinggi',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.lightTextSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                DropdownButtonFormField<String>(
                  value: _selectedCertLevel,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.verified_user_outlined, color: AppColors.lightTextMuted),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'none', child: Text('Belum Memiliki Sertifikat (Non-Gada)')),
                    DropdownMenuItem(value: 'gada_pratama', child: Text('Gada Pratama (Kualifikasi Dasar)')),
                    DropdownMenuItem(value: 'gada_madya', child: Text('Gada Madya (Kualifikasi Penyelia)')),
                    DropdownMenuItem(value: 'gada_utama', child: Text('Gada Utama (Kualifikasi Manajer)')),
                  ],
                  onChanged: (val) => setState(() => _selectedCertLevel = val ?? 'none'),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Kata Sandi',
                  hint: 'Minimal 8 karakter',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.lightTextMuted),
                  validator: (val) => val == null || val.length < 8 ? 'Kata sandi minimal 8 karakter.' : null,
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Konfirmasi Kata Sandi',
                  hint: 'Ulangi kata sandi Anda',
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.lightTextMuted),
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return 'Konfirmasi kata sandi tidak cocok.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
                AppButton(
                  text: 'Daftar Sebagai Satpam',
                  isLoading: authState.isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah memiliki akun? ',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.lightTextSecondary),
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          'Masuk di Sini',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
