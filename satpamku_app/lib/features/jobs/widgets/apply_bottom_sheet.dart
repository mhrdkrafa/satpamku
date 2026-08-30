import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../applications/providers/applications_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/job_model.dart';

class ApplyBottomSheet extends ConsumerStatefulWidget {
  final JobDetailModel job;

  const ApplyBottomSheet({super.key, required this.job});

  @override
  ConsumerState<ApplyBottomSheet> createState() => _ApplyBottomSheetState();
}

class _ApplyBottomSheetState extends ConsumerState<ApplyBottomSheet> {
  final _coverLetterController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _coverLetterController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    final authState = ref.read(authStateProvider);
    if (!authState.isAuthenticated) {
      Navigator.pop(context);
      context.push('/login');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repository = ref.read(applicationRepositoryProvider);
      await repository.apply(
        jobId: widget.job.id,
        coverLetter: _coverLetterController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
        _showSuccessDialog(context);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 48),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Lamaran Terkirim!',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Berkas dan KTA/Sertifikat Anda telah diteruskan ke tim rekrutmen ${widget.job.companyName}.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Pantau Status Lamaran',
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/notifications'); // Or /applications tracking
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider).user;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kirim Lamaran Pekerjaan',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Text(
                'Posisi: ${widget.job.title} • ${widget.job.companyName}',
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
              ),
              const Divider(height: AppSpacing.xl),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.errorLight,
                    borderRadius: AppSpacing.roundedMd,
                  ),
                  child: Text(
                    _errorMessage!,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
              ],

              // Ringkasan Dokumen Profil yang dilampirkan otomatis
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.lightSurfaceVariant,
                  borderRadius: AppSpacing.roundedMd,
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified, color: AppColors.secondary, size: 18),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Berkas Profil Satpamku yang Dilampirkan:',
                          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '• Nama: ${user?.name ?? 'Kandidat Satpam'}\n'
                      '• Tingkat Sertifikat: ${user?.highestCertificateLevel ?? 'Terdata di profil'}\n'
                      '• KTA, SKCK, & Riwayat Pengalaman terverifikasi',
                      style: theme.textTheme.bodySmall?.copyWith(height: 1.4, color: AppColors.lightTextSecondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              AppTextField(
                label: 'Catatan / Surat Pengantar (Opsional)',
                hint: 'Ceritakan kesiapan fisik, sertifikat, atau pengalaman relevan Anda...',
                controller: _coverLetterController,
                maxLines: 3,
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(
                text: 'Kirim Lamaran Sekarang',
                isLoading: _isLoading,
                onPressed: _submitApplication,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
