import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/employer_provider.dart';

class EmployerJobsScreen extends ConsumerWidget {
  const EmployerJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(selectedJobStatusFilterProvider);
    final jobsAsync = ref.watch(employerJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Kelola Lowongan BUJP'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        onPressed: () => context.push('/employer/jobs/create'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Filter Tabs
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
              children: [
                _buildTab(ref, 'Semua', null, selectedStatus == null),
                _buildTab(ref, 'Tayang (Aktif)', 'published', selectedStatus == 'published'),
                _buildTab(ref, 'Review Admin', 'review', selectedStatus == 'review'),
                _buildTab(ref, 'Draft', 'draft', selectedStatus == 'draft'),
                _buildTab(ref, 'Dijeda', 'paused', selectedStatus == 'paused'),
                _buildTab(ref, 'Ditutup', 'closed', selectedStatus == 'closed'),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.lightBorder),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(employerJobsProvider),
              child: jobsAsync.when(
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Belum Ada Lowongan',
                      message: 'Buat dan publikasikan lowongan baru untuk mencari personil keamanan.',
                      icon: Icons.work_off_outlined,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: jobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return AppCard(
                        onTap: () {
                          ref.read(employerApplicantFilterProvider.notifier).state = ApplicantFilter(jobId: job.id);
                          context.push('/employer/applicants');
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    job.title,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                AppBadge(label: job.formattedShift, variant: AppBadgeVariant.neutral, isSmall: true),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('Lokasi: ${job.locationName} • Gaji: ${job.formattedSalary}', style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary)),
                            const Divider(height: AppSpacing.lg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.people_alt_outlined, size: 16, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    const Text('Lihat Pelamar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 20),
                                      onPressed: () => context.push('/employer/jobs/${job.id}/edit'),
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('Hapus Lowongan?'),
                                            content: Text('Hapus lowongan "${job.title}"?'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                                onPressed: () => Navigator.pop(ctx, true),
                                                child: const Text('Hapus'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          await ref.read(employerRepositoryProvider).deleteJob(job.id);
                                          ref.invalidate(employerJobsProvider);
                                        }
                                      },
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                loading: () => ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 120),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(employerJobsProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(WidgetRef ref, String label, String? status, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          ref.read(selectedJobStatusFilterProvider.notifier).state = status;
        },
        selectedColor: AppColors.primary,
        backgroundColor: AppColors.lightSurface,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.lightTextSecondary,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedFull,
          side: BorderSide(color: isSelected ? AppColors.primary : AppColors.lightBorder),
        ),
      ),
    );
  }
}
