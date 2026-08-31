import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../models/job_model.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarked;

  const JobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.onBookmarkTap,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: onTap,
      isHighlighted: job.isFeatured,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(
                name: job.companyName,
                imageUrl: job.companyLogoUrl,
                radius: 20,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.lightTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      job.companyName,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.lightTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (onBookmarkTap != null)
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? AppColors.secondary : AppColors.lightTextMuted,
                    size: 22,
                  ),
                  onPressed: onBookmarkTap,
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              if (job.matchScore != null)
                AppBadge(
                  label: '${job.matchScore}% Cocok',
                  variant: job.matchScore! >= 80 ? AppBadgeVariant.success : AppBadgeVariant.secondary,
                  icon: Icons.verified_user,
                  isSmall: true,
                ),
              if (job.isUrgent) AppBadge.urgent(),
              if (job.requiredCertificateLevel != 'none')
                AppBadge.certificate(job.requiredCertificateLevel),
              AppBadge(
                label: job.formattedShift,
                variant: AppBadgeVariant.neutral,
                icon: Icons.schedule,
                isSmall: true,
              ),
              AppBadge(
                label: job.locationName,
                variant: AppBadgeVariant.neutral,
                icon: Icons.location_on_outlined,
                isSmall: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1, color: AppColors.lightBorder),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  job.formattedSalary,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lihat Detail',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
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
}
