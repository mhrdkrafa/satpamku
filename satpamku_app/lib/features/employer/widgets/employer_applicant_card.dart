import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../models/employer_applicant_model.dart';

class EmployerApplicantCard extends StatelessWidget {
  final EmployerApplicantModel applicant;
  final VoidCallback onTap;

  const EmployerApplicantCard({
    super.key,
    required this.applicant,
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
                name: applicant.candidate.name,
                imageUrl: applicant.candidate.avatarUrl,
                radius: 24,
                isVerified: true,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      applicant.candidate.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Posisi: ${applicant.jobTitle}',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(applicant.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AppBadge.certificate(applicant.candidate.highestCertificateLevel),
              if (applicant.candidate.heightCm != null)
                AppBadge(
                  label: '${applicant.candidate.heightCm} cm',
                  variant: AppBadgeVariant.neutral,
                  icon: Icons.straighten,
                  isSmall: true,
                ),
              if (applicant.candidate.hasSimA || applicant.candidate.hasSimC)
                AppBadge(
                  label: 'SIM ${[
                    if (applicant.candidate.hasSimA) 'A',
                    if (applicant.candidate.hasSimB1) 'B1',
                    if (applicant.candidate.hasSimC) 'C'
                  ].join('/')}',
                  variant: AppBadgeVariant.neutral,
                  icon: Icons.directions_car,
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
              Text(
                'Masuk: ${dateFormat.format(applicant.appliedAt)}',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextMuted, fontSize: 11),
              ),
              Row(
                children: [
                  Text(
                    'Lihat Profil Lengkap',
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
        return const AppBadge(label: 'Baru', variant: AppBadgeVariant.neutral, isSmall: true);
      case 'reviewing':
        return const AppBadge(label: 'Ditinjau', variant: AppBadgeVariant.info, isSmall: true);
      case 'shortlisted':
        return const AppBadge(label: 'Terpilih', variant: AppBadgeVariant.secondary, isSmall: true);
      case 'interview_scheduled':
        return const AppBadge(label: 'Interview', variant: AppBadgeVariant.warning, isSmall: true);
      case 'accepted':
        return const AppBadge(label: 'Diterima', variant: AppBadgeVariant.success, isSmall: true);
      case 'rejected':
        return const AppBadge(label: 'Ditolak', variant: AppBadgeVariant.error, isSmall: true);
      default:
        return AppBadge(label: status, variant: AppBadgeVariant.neutral, isSmall: true);
    }
  }
}
