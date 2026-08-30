import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../providers/candidate_profile_provider.dart';

class ExperiencesScreen extends ConsumerWidget {
  const ExperiencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profileAsync = ref.watch(candidateFullProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Pengalaman Kerja'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pengalaman'),
        onPressed: () => context.push('/experiences/add'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(candidateFullProfileProvider),
        child: profileAsync.when(
          data: (profile) {
            if (profile.experiences.isEmpty) {
              return const EmptyStateWidget(
                title: 'Belum Ada Pengalaman Kerja',
                message: 'Tambahkan riwayat tugas dan penempatan keamanan Anda untuk meningkatkan peluang diterima.',
                icon: Icons.work_history_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: profile.experiences.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final exp = profile.experiences[index];
                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              exp.positionTitle,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Pengalaman?'),
                                  content: Text('Hapus riwayat kerja di ${exp.companyName}?'),
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
                                await ref.read(candidateRepositoryProvider).deleteExperience(exp.id);
                                ref.invalidate(candidateFullProfileProvider);
                              }
                            },
                          ),
                        ],
                      ),
                      Text(
                        exp.companyName,
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${exp.startDate} s/d ${exp.isCurrent ? 'Sekarang' : (exp.endDate ?? '-')}',
                        style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextMuted),
                      ),
                      if (exp.description != null && exp.description!.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        Text(exp.description!, style: theme.textTheme.bodySmall),
                      ],
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorStateWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(candidateFullProfileProvider),
          ),
        ),
      ),
    );
  }
}
