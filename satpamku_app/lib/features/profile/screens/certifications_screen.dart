import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../providers/candidate_profile_provider.dart';

class CertificationsScreen extends ConsumerWidget {
  const CertificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final certsAsync = ref.watch(candidateCertificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Sertifikasi & KTA'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(candidateCertificationsProvider),
        child: certsAsync.when(
          data: (certs) {
            if (certs.isEmpty) {
              return const EmptyStateWidget(
                title: 'Belum Ada Sertifikat Terdaftar',
                message: 'Upload Ijazah Gada Pratama/Madya/Utama atau KTA Satpam Anda untuk diverifikasi.',
                icon: Icons.verified_user_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: certs.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final cert = certs[index];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppBadge.certificate(cert.certificateLevel),
                          AppBadge.status(cert.status),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        cert.certificateName,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (cert.certificateNumber != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'No. Registrasi: ${cert.certificateNumber}',
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                        ),
                      ],
                      const Divider(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cert.issueDate != null ? 'Terbit: ${cert.issueDate}' : 'Tanggal terbit: -',
                            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextMuted, fontSize: 11),
                          ),
                          Text(
                            cert.expiryDate != null ? 'Berlaku s/d: ${cert.expiryDate}' : 'Masa berlaku: Seumur Hidup',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cert.status == 'expired' ? AppColors.error : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorStateWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(candidateCertificationsProvider),
          ),
        ),
      ),
    );
  }
}
