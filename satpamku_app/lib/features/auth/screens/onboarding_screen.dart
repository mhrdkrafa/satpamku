import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': 'Temukan Pekerjaan\nKeamanan Terbaik',
      'description':
          'Platform khusus untuk satpam profesional di Indonesia. Dapatkan akses ke lowongan terverifikasi dan tingkatkan karir Anda.',
    },
    {
      'title': 'Lowongan Resmi &\nTerverifikasi Mabes Polri',
      'description':
          'Ribuan BUJP terpercaya mencari satpam bersertifikat Gada Pratama, Madya, hingga Utama dengan gaji standar UMR ke atas.',
    },
    {
      'title': 'Rekrutmen Cepat &\nTransparan Tanpa Biaya',
      'description':
          'Lamar langsung dengan CV digital, pantau status panggilan wawancara kerja, dan dapatkan notifikasi real-time.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Stack(
        children: [
          // Top 58% Area: Satpam Guard Illustration & Header Logo
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.58,
            child: Stack(
              children: [
                // Illustration Asset
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/onboarding_guard.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFE2E8F0),
                        child: const Center(
                          child: Icon(Icons.security, size: 80, color: AppColors.primary),
                        ),
                      );
                    },
                  ),
                ),

                // Top Left Satpamku Logo
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shield,
                            color: Color(0xFF1B2A72),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Satpamku',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1B2A72),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom 44% Area: Modern White Card with Content & Actions
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 20,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Column(
                children: [
                  // Dot Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (index) {
                      final isActive = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 6,
                        width: isActive ? 24 : 6,
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFF1B2A72) : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 14),

                  // Swipeable Content Area
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _slides.length,
                      onPageChanged: (idx) => setState(() => _currentPage = idx),
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              slide['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2A72),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              slide['description']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF4A5568),
                                height: 1.4,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Primary Button: Mulai Sekarang
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.push('/register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2A72),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Mulai Sekarang',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Secondary Button: Masuk
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => context.push('/login'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF1B2A72),
                        side: const BorderSide(color: Color(0xFF1B2A72), width: 1.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Trust Badge Footer
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, size: 14, color: Color(0xFFC69214)),
                      SizedBox(width: 6),
                      Text(
                        'Platform Terpercaya di Indonesia',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
