import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../providers/candidate_profile_provider.dart';

class ExperiencesScreen extends ConsumerWidget {
  const ExperiencesScreen({super.key});

  String _formatDate(String dateStr) {
    try {
      final parsed = DateTime.parse(dateStr);
      return DateFormat('MMM yyyy', 'id_ID').format(parsed);
    } catch (_) {
      return dateStr;
    }
  }

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
        label: const Text('Tambah Pengalaman', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => context.push('/experiences/add'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(candidateFullProfileProvider),
        child: profileAsync.when(
          data: (profile) {
            if (profile.experiences.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: const EmptyStateWidget(
                      title: 'Belum Ada Pengalaman Kerja',
                      message: 'Tambahkan riwayat tugas dan penempatan keamanan Anda untuk meningkatkan peluang diterima.',
                      icon: Icons.work_history_outlined,
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: profile.experiences.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final exp = profile.experiences[index];
                final startFormatted = _formatDate(exp.startDate);
                final endFormatted = exp.isCurrent ? 'Sekarang' : (exp.endDate != null ? _formatDate(exp.endDate!) : '-');

                return AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: AppSpacing.roundedSm,
                            ),
                            child: const Icon(Icons.shield_outlined, color: AppColors.primary, size: 22),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  exp.positionTitle.isNotEmpty ? exp.positionTitle : 'Petugas Keamanan (Satpam)',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  exp.companyName.isNotEmpty ? exp.companyName : 'Perusahaan BUJP',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '$startFormatted – $endFormatted',
                                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextMuted),
                                    ),
                                    if (exp.isCurrent) ...[
                                      const SizedBox(width: 8),
                                      const AppBadge(
                                        label: 'Aktif Bertugas',
                                        variant: AppBadgeVariant.success,
                                        isSmall: true,
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                            tooltip: 'Hapus Pengalaman',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Hapus Pengalaman?'),
                                  content: Text('Hapus riwayat tugas di ${exp.companyName}?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Hapus', style: TextStyle(color: Colors.white)),
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
                      if (exp.description != null && exp.description!.trim().isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.sm),
                        const Divider(height: 1, color: AppColors.lightBorder),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          exp.description!,
                          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                        ),
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
