import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../models/job_application_model.dart';

class ApplicationCard extends StatelessWidget {
  final JobApplicationModel application;
  final VoidCallback onTap;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd MMM yyyy');

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(
                name: application.job.companyName,
                imageUrl: application.job.companyLogoUrl,
                radius: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.job.title,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      application.job.companyName,
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(application.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.lightBorder),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dilamar pada: ${dateFormat.format(application.appliedAt)}',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextMuted, fontSize: 11),
              ),
              Row(
                children: [
                  Text(
                    'Detail Lamaran',
                    style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 2),
                  const Icon(Icons.arrow_forward_ios, size: 10, color: AppColors.primary),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    switch (status) {
      case 'submitted':
        return const AppBadge(label: 'Terkirim', variant: AppBadgeVariant.neutral, isSmall: true);
      case 'reviewing':
        return const AppBadge(label: 'Ditinjau', variant: AppBadgeVariant.info, isSmall: true);
      case 'shortlisted':
        return const AppBadge(label: 'Terpilih', variant: AppBadgeVariant.secondary, isSmall: true);
      case 'interview_scheduled':
        return const AppBadge(label: 'Interview', variant: AppBadgeVariant.warning, isSmall: true);
      case 'accepted':
        return const AppBadge(label: 'Diterima', variant: AppBadgeVariant.success, isSmall: true);
      case 'rejected':
        return const AppBadge(label: 'Belum Sesuai', variant: AppBadgeVariant.error, isSmall: true);
      case 'withdrawn':
        return const AppBadge(label: 'Dibatalkan', variant: AppBadgeVariant.neutral, isSmall: true);
      default:
        return AppBadge(label: status, variant: AppBadgeVariant.neutral, isSmall: true);
    }
  }
}
