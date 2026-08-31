import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();

    Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      final authState = ref.read(authProvider);
      if (authState.isAuthenticated) {
        if (authState.user?.role == 'employer') {
          context.go('/employer/dashboard');
        } else {
          context.go('/');
        }
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            // Center Brand Content
            Center(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Shield Logo Box
                      Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF1B2A72).withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(
                              Icons.shield,
                              size: 58,
                              color: Color(0xFF1B2A72),
                            ),
                            Positioned(
                              right: 14,
                              bottom: 14,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.verified,
                                  size: 20,
                                  color: Color(0xFFC69214),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // App Name
                      const Text(
                        'Satpamku',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B2A72),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Subtitle
                      const Text(
                        'Profesionalisme dan Disiplin dalam\nGenggaman Anda.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4A5568),
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Loading Indicator / Status
            const Positioned(
              bottom: 36,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'MEMUAT SISTEM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
