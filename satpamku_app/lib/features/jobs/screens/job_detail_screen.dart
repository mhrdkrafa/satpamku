import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../models/job_model.dart';
import '../providers/jobs_provider.dart';
import '../widgets/apply_bottom_sheet.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String slug;

  const JobDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  bool _isSaved = false;

  void _openApplyModal(JobDetailModel job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ApplyBottomSheet(job: job),
    );
  }

  Future<void> _toggleSave(int jobId) async {
    try {
      final repo = ref.read(jobRepositoryProvider);
      final saved = await repo.toggleSaveJob(jobId);
      setState(() => _isSaved = saved);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(saved ? 'Lowongan disimpan ke bookmark.' : 'Lowongan dihapus dari bookmark.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final detailAsync = ref.watch(jobDetailProvider(widget.slug));

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Detail Lowongan'),
        actions: [
          detailAsync.whenOrNull(
                data: (job) => IconButton(
                  icon: Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
                  onPressed: () => _toggleSave(job.id),
                ),
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: detailAsync.whenOrNull(
        data: (job) => Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            border: const Border(top: BorderSide(color: AppColors.lightBorder)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () => _toggleSave(job.id),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedMd),
                  ),
                  child: Icon(
                    _isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: _isSaved ? AppColors.secondary : AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppButton(
                    text: 'Lamar Pekerjaan Sekarang',
                    onPressed: () => _openApplyModal(job),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: detailAsync.when(
        data: (job) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Employer Card
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppAvatar(
                          name: job.companyName,
                          imageUrl: job.companyLogoUrl,
                          radius: 28,
                          isVerified: true,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job.companyName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_outlined, size: 14, color: AppColors.lightTextSecondary),
                                  const SizedBox(width: 2),
                                  Text(
                                    job.locationName,
                                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      job.title,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      job.formattedSalary,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppColors.secondaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (job.isUrgent) AppBadge.urgent(),
                        if (job.isFeatured) AppBadge.featured(),
                        if (job.requiredCertificateLevel != 'none')
                          AppBadge.certificate(job.requiredCertificateLevel),
                        AppBadge(label: job.formattedShift, variant: AppBadgeVariant.neutral, icon: Icons.schedule),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Kualifikasi Fisik & Umum
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Persyaratan Fisik & Kualifikasi', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Divider(height: AppSpacing.lg),
                    _buildRequirementRow(Icons.straighten, 'Tinggi Badan Minimal', job.minHeightCm != null ? '${job.minHeightCm} cm' : 'Tidak ditentukan'),
                    _buildRequirementRow(Icons.monitor_weight_outlined, 'Berat Badan Minimal', job.minWeightKg != null ? '${job.minWeightKg} kg' : 'Proporsional'),
                    _buildRequirementRow(Icons.card_membership, 'Sertifikasi Minimal', job.requiredCertificateLevel == 'none' ? 'Non-Sertifikasi' : job.requiredCertificateLevel.toUpperCase()),
                    _buildRequirementRow(Icons.directions_car_outlined, 'Kepemilikan SIM', job.requiresSim ? 'Wajib (${job.requiredSimTypes.join(', ')})' : 'Tidak wajib'),
                    _buildRequirementRow(Icons.work_history_outlined, 'Pengalaman Kerja', '${job.experienceYearsMin} Tahun di bidang keamanan'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Deskripsi Pekerjaan
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Deskripsi Tugas & Tanggung Jawab', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const Divider(height: AppSpacing.lg),
                    Text(
                      job.description,
                      style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                    ),
                  ],
                ),
              ),

              if (job.facilities.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fasilitas & Tunjangan', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const Divider(height: AppSpacing.lg),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.sm,
                        children: job.facilities
                            .map((f) => AppBadge(label: f, variant: AppBadgeVariant.neutral, icon: Icons.check_circle_outline))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        loading: () => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              LoadingSkeleton.card(height: 180),
              const SizedBox(height: AppSpacing.lg),
              LoadingSkeleton.card(height: 140),
            ],
          ),
        ),
        error: (err, _) => ErrorStateWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(jobDetailProvider(widget.slug)),
        ),
      ),
    );
  }

  Widget _buildRequirementRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryLight),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: AppColors.lightTextSecondary))),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.lightTextPrimary)),
        ],
      ),
    );
  }
}
