import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/employer_provider.dart';

class EmployerDashboardScreen extends ConsumerWidget {
  const EmployerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authStateProvider).user;
    final dashboardAsync = ref.watch(employerDashboardProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Portal Perusahaan BUJP'),
        actions: [
          IconButton(
            icon: const Icon(Icons.business_outlined),
            onPressed: () => context.go('/employer/profile'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.primaryDark,
        icon: const Icon(Icons.add_task),
        label: const Text('Pasang Lowongan Baru', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => context.push('/employer/jobs/create'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(employerDashboardProvider),
        child: dashboardAsync.when(
          data: (dashboard) => SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                AppCard(
                  backgroundColor: AppColors.primary,
                  child: Row(
                    children: [
                      AppAvatar(
                        name: user?.name ?? 'BUJP',
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
                              user?.name ?? 'Perusahaan BUJP',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Badan Usaha Jasa Pengamanan Resmi',
                              style: TextStyle(color: AppColors.secondaryLight, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Metrics Grid (4 KPI boxes)
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                  childAspectRatio: 1.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildMetricCard(
                      context,
                      title: 'Lowongan Aktif',
                      value: dashboard.activeJobs.toString(),
                      icon: Icons.work_outline,
                      color: AppColors.primary,
                      onTap: () => context.go('/employer/jobs'),
                    ),
                    _buildMetricCard(
                      context,
                      title: 'Total Pelamar',
                      value: dashboard.totalApplicants.toString(),
                      icon: Icons.people_outline,
                      color: AppColors.info,
                      onTap: () => context.go('/employer/applicants'),
                    ),
                    _buildMetricCard(
                      context,
                      title: 'Perlu Ditinjau',
                      value: dashboard.pendingReview.toString(),
                      icon: Icons.pending_actions,
                      color: AppColors.warning,
                      onTap: () {
                        ref.read(employerApplicantFilterProvider.notifier).state = const ApplicantFilter(status: 'submitted');
                        context.go('/employer/applicants');
                      },
                    ),
                    _buildMetricCard(
                      context,
                      title: 'Interview Terjadwal',
                      value: dashboard.interviewsScheduled.toString(),
                      icon: Icons.event_available,
                      color: AppColors.success,
                      onTap: () {
                        ref.read(employerApplicantFilterProvider.notifier).state = const ApplicantFilter(status: 'interview_scheduled');
                        context.go('/employer/applicants');
                      },
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // Quick Navigation Actions
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Kelola Lowongan',
                        variant: AppButtonVariant.outline,
                        icon: Icons.list_alt,
                        onPressed: () => context.go('/employer/jobs'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: AppButton(
                        text: 'Pipeline Pelamar',
                        variant: AppButtonVariant.primary,
                        icon: Icons.filter_alt_outlined,
                        onPressed: () => context.go('/employer/applicants'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.xl),

                // Recent Applicants Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pelamar Satpam Terbaru',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/employer/applicants'),
                      child: Text(
                        'Lihat Semua',
                        style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                if (dashboard.recentApplicants.isEmpty)
                  const EmptyStateWidget(
                    title: 'Belum Ada Pelamar Masuk',
                    message: 'Pasang lowongan baru untuk mulai menerima berkas lamaran dari satpam terverifikasi.',
                    icon: Icons.people_outline,
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dashboard.recentApplicants.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      final item = dashboard.recentApplicants[index];
                      return AppCard(
                        onTap: () => context.push('/employer/applicants/${item.id}'),
                        child: Row(
                          children: [
                            AppAvatar(name: item.candidateName, imageUrl: item.candidateAvatar, radius: 20),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.candidateName, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('Melamar: ${item.jobTitle}', style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary)),
                                ],
                              ),
                            ),
                            AppBadge.certificate(item.certificateLevel),
                          ],
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorStateWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(employerDashboardProvider),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary, fontWeight: FontWeight.w600)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
