import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_card.dart';
import '../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

    return AppCard(
      onTap: onTap,
      backgroundColor: notification.isRead ? AppColors.lightSurface : AppColors.secondary.withOpacity(0.06),
      borderColor: notification.isRead ? AppColors.lightBorder : AppColors.secondary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIcon(notification.type),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                          color: notification.isRead ? AppColors.lightTextPrimary : AppColors.primaryDark,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  dateFormat.format(notification.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.lightTextMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(String type) {
    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (type) {
      case 'new_application':
        icon = Icons.person_add_outlined;
        bgColor = AppColors.info.withOpacity(0.15);
        iconColor = AppColors.info;
        break;
      case 'application_status':
        icon = Icons.assignment_turned_in_outlined;
        bgColor = AppColors.primary.withOpacity(0.15);
        iconColor = AppColors.primary;
        break;
      case 'certificate_near_expiry':
        icon = Icons.warning_amber_rounded;
        bgColor = AppColors.warning.withOpacity(0.15);
        iconColor = AppColors.warning;
        break;
      case 'certificate_expired':
        icon = Icons.error_outline;
        bgColor = AppColors.error.withOpacity(0.15);
        iconColor = AppColors.error;
        break;
      default:
        icon = Icons.notifications_none;
        bgColor = AppColors.lightBorder;
        iconColor = AppColors.lightTextSecondary;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
