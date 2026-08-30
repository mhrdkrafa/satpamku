import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/jobs_provider.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/job_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final filter = ref.read(jobFilterProvider);
    if (filter.query != null) {
      _searchController.text = filter.query!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(jobFilterProvider);
    final jobsAsync = ref.watch(searchJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Cari Lowongan Satpam'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppSearchField(
              controller: _searchController,
              onSubmitted: (query) {
                ref.read(jobFilterProvider.notifier).update((state) => state.copyWith(query: query));
              },
              onClear: () {
                ref.read(jobFilterProvider.notifier).update((state) => state.copyWith(clearQuery: true));
              },
              onFilterTap: _openFilterModal,
              hasActiveFilters: filter.hasActiveFilters,
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(searchJobsProvider),
              child: jobsAsync.when(
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Tidak Ada Lowongan Ditemukan',
                      message: 'Coba ubah kata kunci pencarian atau sesuaikan opsi filter Anda.',
                      icon: Icons.search_off_rounded,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    itemCount: jobs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final job = jobs[index];
                      return JobCard(
                        job: job,
                        onTap: () => context.push('/jobs/${job.slug}'),
                      );
                    },
                  );
                },
                loading: () => ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 120),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(searchJobsProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
