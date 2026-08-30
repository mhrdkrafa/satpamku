import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satpamku_app/core/theme/app_colors.dart';
import 'package:satpamku_app/core/theme/app_spacing.dart';
import 'package:satpamku_app/core/theme/app_theme.dart';
import 'package:satpamku_app/core/theme/app_typography.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  AppTypography.useGoogleFonts = false;

  group('AppTheme Tests', () {
    test('Light theme has correct primary and surface colors', () {
      final theme = AppTheme.lightTheme;

      expect(theme.primaryColor, AppColors.primary);
      expect(theme.scaffoldBackgroundColor, AppColors.lightBackground);
      expect(theme.colorScheme.primary, AppColors.primary);
      expect(theme.colorScheme.secondary, AppColors.secondary);
      expect(theme.useMaterial3, true);
    });

    test('Dark theme has correct dark colors', () {
      final theme = AppTheme.darkTheme;

      expect(theme.scaffoldBackgroundColor, AppColors.darkBackground);
      expect(theme.colorScheme.surface, AppColors.darkSurface);
      expect(theme.brightness, Brightness.dark);
    });

    test('AppSpacing values follow 4px grid', () {
      expect(AppSpacing.xs, 4.0);
      expect(AppSpacing.sm, 8.0);
      expect(AppSpacing.md, 12.0);
      expect(AppSpacing.lg, 16.0);
      expect(AppSpacing.xxl, 24.0);
    });
  });
}
