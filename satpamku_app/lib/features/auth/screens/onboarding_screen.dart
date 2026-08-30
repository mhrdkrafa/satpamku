import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'icon': Icons.shield_outlined,
      'title': 'Karir Satpam Profesional & Terverifikasi',
      'subtitle': 'Temukan ribuan peluang kerja satpam terpercaya di seluruh kota Indonesia langsung dari BUJP resmi.',
    },
    {
      'icon': Icons.verified_user_outlined,
      'title': 'Verifikasi KTA & Sertifikat Gada Resmi',
      'subtitle': 'Simpan sertifikat Gada Pratama, Madya, hingga Utama dengan aman. Dapatkan badge terverifikasi untuk dilirik employer.',
    },
    {
      'icon': Icons.track_changes_outlined,
      'title': 'Pantau Lamaran & Jadwal Interview',
      'subtitle': 'Transparansi status lamaran dari pengiriman, review berkas, hingga undangan interview langsung di genggaman Anda.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: Text(
                  'Lewati',
                  style: theme.textTheme.labelLarge?.copyWith(color: Colors.white70),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xxxl),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.secondary, width: 2),
                          ),
                          child: Icon(
                            page['icon'] as IconData,
                            size: 64,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxxl),
                        Text(
                          page['title'] as String,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          page['subtitle'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.lightTextMuted,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.secondary : Colors.white24,
                          borderRadius: AppSpacing.roundedFull,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  AppButton(
                    text: _currentPage == _pages.length - 1 ? 'Mulai Sekarang' : 'Lanjutkan',
                    variant: AppButtonVariant.secondary,
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/login');
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    text: 'Daftar Akun Baru',
                    variant: AppButtonVariant.text,
                    onPressed: () => context.push('/register'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
