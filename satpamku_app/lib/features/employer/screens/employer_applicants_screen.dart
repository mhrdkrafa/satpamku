import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/employer_provider.dart';
import '../widgets/employer_applicant_card.dart';

class EmployerApplicantsScreen extends ConsumerWidget {
  const EmployerApplicantsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(employerApplicantFilterProvider);
    final applicantsAsync = ref.watch(employerApplicantsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Pipeline Pelamar Satpam'),
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
                _buildTab(ref, 'Semua', null, filter.status == null),
                _buildTab(ref, 'Baru Masuk', 'submitted', filter.status == 'submitted'),
                _buildTab(ref, 'Ditinjau', 'reviewing', filter.status == 'reviewing'),
                _buildTab(ref, 'Kandidat Terpilih', 'shortlisted', filter.status == 'shortlisted'),
                _buildTab(ref, 'Interview Terjadwal', 'interview_scheduled', filter.status == 'interview_scheduled'),
                _buildTab(ref, 'Diterima', 'accepted', filter.status == 'accepted'),
                _buildTab(ref, 'Ditolak', 'rejected', filter.status == 'rejected'),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.lightBorder),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(employerApplicantsProvider),
              child: applicantsAsync.when(
                data: (applicants) {
                  if (applicants.isEmpty) {
                    return const EmptyStateWidget(
                      title: 'Belum Ada Pelamar di Tahap Ini',
                      message: 'Tidak ada berkas pelamar satpam pada kategori status ini.',
                      icon: Icons.people_outline,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    itemCount: applicants.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      final applicant = applicants[index];
                      return EmployerApplicantCard(
                        applicant: applicant,
                        onTap: () => context.push('/employer/applicants/${applicant.id}'),
                      );
                    },
                  );
                },
                loading: () => ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  itemCount: 4,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 130),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(employerApplicantsProvider),
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
          ref.read(employerApplicantFilterProvider.notifier).update((state) => state.copyWith(status: status, clearStatus: status == null));
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
