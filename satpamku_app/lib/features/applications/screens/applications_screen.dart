import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/applications_provider.dart';
import '../widgets/application_card.dart';

class ApplicationsScreen extends ConsumerWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedStatus = ref.watch(selectedApplicationStatusProvider);
    final appsAsync = ref.watch(candidateApplicationsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Riwayat Lamaran Saya'),
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
                _buildTab(context, ref, 'Semua', null, selectedStatus == null),
                _buildTab(context, ref, 'Terkirim', 'submitted', selectedStatus == 'submitted'),
                _buildTab(context, ref, 'Ditinjau', 'reviewing', selectedStatus == 'reviewing'),
                _buildTab(context, ref, 'Interview', 'interview_scheduled', selectedStatus == 'interview_scheduled'),
                _buildTab(context, ref, 'Diterima', 'accepted', selectedStatus == 'accepted'),
                _buildTab(context, ref, 'Ditolak', 'rejected', selectedStatus == 'rejected'),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.lightBorder),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(candidateApplicationsProvider),
              child: appsAsync.when(
                data: (applications) {
                  if (applications.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Belum Ada Riwayat Lamaran',
                      message: 'Anda belum mengirimkan lamaran kerja satpam pada kategori ini.',
                      icon: Icons.assignment_late_outlined,
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: applications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final app = applications[index];
                      return ApplicationCard(
                        application: app,
                        onTap: () => context.push('/applications/${app.id}'),
                      );
                    },
                  );
                },
                loading: () => ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 100),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(candidateApplicationsProvider),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, WidgetRef ref, String label, String? status, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          ref.read(selectedApplicationStatusProvider.notifier).state = status;
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
