import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../jobs/providers/jobs_provider.dart';
import '../../jobs/widgets/job_card.dart';

class SavedJobsScreen extends ConsumerWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedAsync = ref.watch(savedJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Lowongan Tersimpan'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(savedJobsProvider),
        child: savedAsync.when(
          data: (jobs) {
            if (jobs.isEmpty) {
              return const EmptyStateWidget(
                title: 'Belum Ada Lowongan Tersimpan',
                message: 'Tandai lowongan yang menarik untuk disimpan dan dilamar nanti.',
                icon: Icons.bookmark_border,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: jobs.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return JobCard(
                  job: job,
                  isBookmarked: true,
                  onTap: () => context.push('/jobs/${job.slug}'),
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
            onRetry: () => ref.invalidate(savedJobsProvider),
          ),
        ),
      ),
    );
  }
}
