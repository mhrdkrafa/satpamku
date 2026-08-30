import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../providers/candidate_profile_provider.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final docsAsync = ref.watch(candidateDocumentsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Dokumen & Berkas CV'),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(candidateDocumentsProvider),
        child: docsAsync.when(
          data: (docs) {
            if (docs.isEmpty) {
              return const EmptyStateWidget(
                title: 'Belum Ada Dokumen Tersimpan',
                message: 'Upload file CV, KTP, SKCK, dan Surat Keterangan Sehat untuk melengkapi profil lamaran.',
                icon: Icons.folder_open_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: docs.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final doc = docs[index];
                return AppCard(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.08),
                          borderRadius: AppSpacing.roundedMd,
                        ),
                        child: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc.name,
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Jenis: ${doc.type.toUpperCase()}',
                              style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary),
                            ),
                          ],
                        ),
                      ),
                      AppBadge.status(doc.status),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => ErrorStateWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(candidateDocumentsProvider),
          ),
        ),
      ),
    );
  }
}
