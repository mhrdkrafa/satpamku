import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/applications_provider.dart';

class ApplicationDetailScreen extends ConsumerStatefulWidget {
  final int applicationId;

  const ApplicationDetailScreen({super.key, required this.applicationId});

  @override
  ConsumerState<ApplicationDetailScreen> createState() => _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends ConsumerState<ApplicationDetailScreen> {
  bool _isWithdrawing = false;

  Future<void> _withdraw(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
        title: const Text('Batalkan Lamaran?'),
        content: const Text('Apakah Anda yakin ingin membatalkan berkas lamaran pekerjaan ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Kembali'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Batalkan Lamaran'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isWithdrawing = true);
    try {
      final repo = ref.read(applicationRepositoryProvider);
      await repo.withdrawApplication(widget.applicationId);
      ref.invalidate(applicationDetailProvider(widget.applicationId));
      ref.invalidate(candidateApplicationsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lamaran berhasil dibatalkan.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isWithdrawing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appAsync = ref.watch(applicationDetailProvider(widget.applicationId));
    final dateFormat = DateFormat('dd MMMM yyyy, HH:mm');

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Status Lamaran'),
      ),
      body: appAsync.when(
        data: (app) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status Hero Card
              AppCard(
                backgroundColor: _getStatusBgColor(app.status),
                borderColor: _getStatusBorderColor(app.status),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Status Lamaran:',
                          style: theme.textTheme.labelMedium?.copyWith(color: AppColors.lightTextSecondary),
                        ),
                        AppBadge.status(app.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      app.statusDisplay,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getStatusTextColor(app.status),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      _getStatusDescription(app.status),
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Interview Invitation (If scheduled)
              if (app.interviewAt != null) ...[
                AppCard(
                  backgroundColor: AppColors.warningLight,
                  borderColor: AppColors.warning,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.event_available, color: AppColors.warning, size: 22),
                          const SizedBox(width: AppSpacing.sm),
                          Text(
                            'Jadwal Undangan Interview',
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFFB45309)),
                          ),
                        ],
                      ),
                      const Divider(height: AppSpacing.md),
                      Text('Waktu: ${dateFormat.format(app.interviewAt!)} WIB', style: const TextStyle(fontWeight: FontWeight.bold)),
                      if (app.interviewLocation != null) ...[
                        const SizedBox(height: 4),
                        Text('Lokasi: ${app.interviewLocation}'),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              // Job Info Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppAvatar(
                          name: app.job.companyName,
                          imageUrl: app.job.companyLogoUrl,
                          radius: 24,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(app.job.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              Text(app.job.companyName, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: AppSpacing.lg),
                    Text('Gaji yang Ditawarkan: ${app.job.formattedSalary}'),
                    const SizedBox(height: 4),
                    Text('Lokasi Penempatan: ${app.job.locationName}'),
                    const SizedBox(height: 4),
                    Text('Tipe Shift: ${app.job.formattedShift}'),
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      text: 'Lihat Info Lowongan Lengkap',
                      variant: AppButtonVariant.outline,
                      height: 40,
                      onPressed: () => context.push('/jobs/${app.job.slug}'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Candidate Submission Cover Letter
              if (app.coverLetter != null && app.coverLetter!.isNotEmpty) ...[
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Catatan Pengantar Anda', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const Divider(height: AppSpacing.md),
                      Text(app.coverLetter!, style: theme.textTheme.bodyMedium),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],

              if (app.canWithdraw)
                AppButton(
                  text: 'Batalkan Lamaran',
                  variant: AppButtonVariant.danger,
                  isLoading: _isWithdrawing,
                  onPressed: () => _withdraw(context),
                ),
            ],
          ),
        ),
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              LoadingSkeleton.card(height: 120),
              const SizedBox(height: AppSpacing.lg),
              LoadingSkeleton.card(height: 160),
            ],
          ),
        ),
        error: (err, _) => ErrorStateWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(applicationDetailProvider(widget.applicationId)),
        ),
      ),
    );
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.successLight;
      case 'interview_scheduled':
        return AppColors.warningLight;
      case 'rejected':
        return AppColors.errorLight;
      default:
        return AppColors.lightSurface;
    }
  }

  Color _getStatusBorderColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.success;
      case 'interview_scheduled':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.lightBorder;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'accepted':
        return AppColors.success;
      case 'interview_scheduled':
        return const Color(0xFFB45309);
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  String _getStatusDescription(String status) {
    switch (status) {
      case 'submitted':
        return 'Lamaran Anda telah terkirim dan sedang menunggu verifikasi awal HRD perusahaan.';
      case 'reviewing':
        return 'Tim rekrutmen sedang memeriksa kualifikasi sertifikat dan pengalaman kerja Anda.';
      case 'shortlisted':
        return 'Selamat! Berkas Anda masuk ke daftar pendek kandidat potensial.';
      case 'interview_scheduled':
        return 'Perusahaan telah menentukan jadwal wawancara langsung/online untuk Anda.';
      case 'accepted':
        return 'Selamat! Anda diterima bekerja di posisi ini. Tunggu arahan kontrak dari BUJP.';
      case 'rejected':
        return 'Mohon maaf, kualifikasi Anda belum sesuai dengan kebutuhan lowongan ini saat ini.';
      case 'withdrawn':
        return 'Lamaran pekerjaan telah dibatalkan atas permintaan Anda.';
      default:
        return '';
    }
  }
}
