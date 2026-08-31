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

class SavedJobsScreen extends ConsumerStatefulWidget {
  const SavedJobsScreen({super.key});

  @override
  ConsumerState<SavedJobsScreen> createState() => _SavedJobsScreenState();
}

class _SavedJobsScreenState extends ConsumerState<SavedJobsScreen> {
  String _sortBy = 'Recently Saved';

  @override
  Widget build(BuildContext context) {
    final savedAsync = ref.watch(savedJobsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'Satpamku',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1B2A72), size: 24),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(savedJobsProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              const Text(
                'Saved Jobs',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              savedAsync.when(
                data: (jobs) => Text(
                  'You have ${jobs.length} bookmarked opportunities.',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
                loading: () => const Text('Memuat bookmark...', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 14),

              // Sort Dropdown Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sort, size: 18, color: Color(0xFF1B2A72)),
                    const SizedBox(width: 8),
                    Text(
                      'Sort by: $_sortBy',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF64748B)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Saved Jobs List
              savedAsync.when(
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyStateWidget(
                        title: 'Belum Ada Lowongan Tersimpan',
                        message: 'Tandai lowongan yang menarik untuk disimpan dan dilamar nanti.',
                        icon: Icons.bookmark_border,
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return JobCard(
                        job: job,
                        isBookmarked: true,
                        onTap: () => context.push('/jobs/${job.slug}'),
                        onBookmarkTap: () async {
                          final repo = ref.read(jobRepositoryProvider);
                          await repo.toggleSaveJob(job.id);
                          ref.invalidate(savedJobsProvider);
                        },
                      );
                    },
                  );
                },
                loading: () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 140),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(savedJobsProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
