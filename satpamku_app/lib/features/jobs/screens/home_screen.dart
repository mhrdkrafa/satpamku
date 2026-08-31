import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/jobs_provider.dart';
import '../widgets/job_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final user = authState.user;

    final featuredAsync = ref.watch(featuredJobsProvider);
    final urgentAsync = ref.watch(urgentJobsProvider);
    final searchAsync = ref.watch(searchJobsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        titleSpacing: AppSpacing.lg,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: AppSpacing.roundedSm,
              ),
              child: const Icon(Icons.shield, color: AppColors.primaryDark, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Text(
              'Satpamku',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/jobs'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => context.push('/saved-jobs'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(featuredJobsProvider);
          ref.invalidate(urgentJobsProvider);
          ref.invalidate(searchJobsProvider);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Candidate Header / Greeting
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: AppSpacing.roundedLg,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      AppAvatar(
                        name: user?.name ?? 'Satpam',
                        imageUrl: user?.avatarUrl,
                        radius: 26,
                        isVerified: true,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user != null ? 'Halo, ${user.name}' : 'Selamat Datang di Satpamku',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user != null
                                  ? 'Kualifikasi: ${user.highestCertificateLevel == null || user.highestCertificateLevel == 'none' ? 'Non-Sertifikat' : user.highestCertificateLevel!.toUpperCase()}'
                                  : 'Portal Karir Satpam Indonesia',
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.secondaryLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Categories Horizontal Pills
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Text(
                  'Sektor Penempatan',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  children: [
                    _buildCategoryPill(context, 'Semua Sektor', null),
                    _buildCategoryPill(context, 'Perkantoran', 'Perkantoran'),
                    _buildCategoryPill(context, 'Perbankan & Kas', 'Perbankan'),
                    _buildCategoryPill(context, 'Mall & Retail', 'Retail'),
                    _buildCategoryPill(context, 'Pabrik & Industri', 'Industri'),
                    _buildCategoryPill(context, 'Residensial / Perumahan', 'Residensial'),
                    _buildCategoryPill(context, 'VIP Bodyguard', 'VIP'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Urgent Hiring Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.bolt, color: AppColors.error, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          'Urgent Hiring',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(jobFilterProvider.notifier).update((state) => state.copyWith(isUrgent: true));
                        context.push('/jobs');
                      },
                      child: Text(
                        'Lihat Semua',
                        style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              urgentAsync.when(
                data: (urgentJobs) {
                  if (urgentJobs.isEmpty) return const SizedBox.shrink();
                  return SizedBox(
                    height: 245,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      itemCount: urgentJobs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final job = urgentJobs[index];
                        return SizedBox(
                          width: 300,
                          child: JobCard(
                            job: job,
                            onTap: () => context.push('/jobs/${job.slug}'),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  child: LoadingSkeleton.card(height: 140),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Lowongan Terbaru List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Lowongan Satpam Terbaru',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/jobs'),
                      child: Text(
                        'Eksplorasi',
                        style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              searchAsync.when(
                data: (jobs) {
                  if (jobs.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Belum Ada Lowongan',
                      message: 'Saat ini belum ada lowongan baru yang tersedia.',
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
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
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 120),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(searchJobsProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPill(BuildContext context, String title, String? categorySlug) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      child: ActionChip(
        label: Text(title),
        backgroundColor: AppColors.lightSurface,
        labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.roundedFull,
          side: const BorderSide(color: AppColors.lightBorder),
        ),
        onPressed: () {
          context.push('/jobs');
        },
      ),
    );
  }
}
