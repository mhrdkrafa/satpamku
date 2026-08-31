import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

enum AppBadgeVariant { primary, secondary, success, warning, error, info, neutral, certificate }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;
  final bool isSmall;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.primary,
    this.icon,
    this.isSmall = false,
  });

  factory AppBadge.certificate(String level, {bool isSmall = true}) {
    String label;
    AppBadgeVariant variant;

    switch (level.toLowerCase()) {
      case 'gada_utama':
      case 'utama':
        label = 'Gada Utama';
        variant = AppBadgeVariant.secondary;
        break;
      case 'gada_madya':
      case 'madya':
        label = 'Gada Madya';
        variant = AppBadgeVariant.info;
        break;
      case 'gada_pratama':
      case 'pratama':
        label = 'Gada Pratama';
        variant = AppBadgeVariant.primary;
        break;
      default:
        label = 'Non-Sertifikasi';
        variant = AppBadgeVariant.neutral;
    }

    return AppBadge(label: label, variant: variant, icon: Icons.verified_user_outlined, isSmall: isSmall);
  }

  factory AppBadge.urgent() {
    return const AppBadge(
      label: 'URGENT HIRING',
      variant: AppBadgeVariant.error,
      icon: Icons.bolt,
      isSmall: true,
    );
  }

  factory AppBadge.featured() {
    return const AppBadge(
      label: 'FEATURED',
      variant: AppBadgeVariant.secondary,
      icon: Icons.star,
      isSmall: true,
    );
  }

  factory AppBadge.status(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'published':
        return const AppBadge(label: 'Terverifikasi', variant: AppBadgeVariant.success, icon: Icons.check_circle);
      case 'pending':
      case 'review':
        return const AppBadge(label: 'Menunggu Review', variant: AppBadgeVariant.warning, icon: Icons.schedule);
      case 'rejected':
        return const AppBadge(label: 'Ditolak', variant: AppBadgeVariant.error, icon: Icons.cancel);
      case 'expired':
      case 'closed':
        return const AppBadge(label: 'Kedaluwarsa', variant: AppBadgeVariant.neutral, icon: Icons.history);
      default:
        return AppBadge(label: status, variant: AppBadgeVariant.neutral);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (bgColor, textColor, borderColor) = _getColors();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? AppSpacing.sm : AppSpacing.md,
        vertical: isSmall ? 2.0 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppSpacing.roundedFull,
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: isSmall ? 12 : 14, color: textColor),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            label,
            style: (isSmall ? theme.textTheme.labelSmall : theme.textTheme.labelMedium)?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  (Color, Color, Color) _getColors() {
    switch (variant) {
      case AppBadgeVariant.primary:
        return (AppColors.primary.withOpacity(0.08), AppColors.primary, AppColors.primary.withOpacity(0.2));
      case AppBadgeVariant.secondary:
        return (AppColors.secondary.withOpacity(0.15), AppColors.secondaryDark, AppColors.secondary);
      case AppBadgeVariant.success:
        return (AppColors.successLight, AppColors.success, AppColors.success.withOpacity(0.3));
      case AppBadgeVariant.warning:
        return (AppColors.warningLight, const Color(0xFFB45309), AppColors.warning.withOpacity(0.4));
      case AppBadgeVariant.error:
        return (AppColors.errorLight, AppColors.error, AppColors.error.withOpacity(0.3));
      case AppBadgeVariant.info:
        return (AppColors.infoLight, AppColors.info, AppColors.info.withOpacity(0.3));
      case AppBadgeVariant.certificate:
        return (AppColors.secondaryLight, AppColors.secondaryDark, AppColors.secondary);
      case AppBadgeVariant.neutral:
        return (AppColors.lightSurfaceVariant, AppColors.lightTextSecondary, AppColors.lightBorder);
    }
  }
}
