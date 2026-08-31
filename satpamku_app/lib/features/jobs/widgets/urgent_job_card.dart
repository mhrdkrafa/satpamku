import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../models/job_model.dart';

class UrgentJobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onTap;

  const UrgentJobCard({
    super.key,
    required this.job,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: AppSpacing.roundedMd,
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppSpacing.roundedMd,
          border: Border.all(color: AppColors.error.withOpacity(0.2), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: AppColors.error.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Row: Avatar + Info + Urgent Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(
                  name: job.companyName,
                  imageUrl: job.companyLogoUrl,
                  radius: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.lightTextPrimary,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.companyName,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.lightTextSecondary,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Badges Row
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                const AppBadge(
                  label: 'URGENT',
                  variant: AppBadgeVariant.error,
                  icon: Icons.bolt,
                  isSmall: true,
                ),
                if (job.requiredCertificateLevel != 'none')
                  AppBadge.certificate(
                    job.requiredCertificateLevel,
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

            // Divider & Salary
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1, color: AppColors.lightBorder),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        job.formattedSalary,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 11,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
