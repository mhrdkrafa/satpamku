import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_card.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Notifikasi & Aktivitas'),
        actions: [
          IconButton(
            tooltip: 'Tandai Semua Dibaca',
            icon: const Icon(Icons.done_all),
            onPressed: () async {
              await ref.read(notificationRepositoryProvider).markAllAsRead();
              ref.invalidate(notificationsProvider);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationsProvider),
        child: notifsAsync.when(
          data: (response) {
            if (response.items.isEmpty) {
              return const EmptyStateWidget(
                title: 'Belum Ada Notifikasi',
                message: 'Pemberitahuan status lamaran, undangan interview, dan masa berlaku sertifikat akan muncul di sini.',
                icon: Icons.notifications_none_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: response.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final item = response.items[index];
                return NotificationCard(
                  notification: item,
                  onTap: () async {
                    if (!item.isRead) {
                      await ref.read(notificationRepositoryProvider).markAsRead(item.id);
                      ref.invalidate(notificationsProvider);
                    }

                    if (item.type == 'application_status' && item.payload['application_id'] != null) {
                      context.push('/applications/${item.payload['application_id']}');
                    } else if (item.type == 'new_application' && item.payload['application_id'] != null) {
                      context.push('/employer/applicants/${item.payload['application_id']}');
                    } else if (item.type.startsWith('certificate_')) {
                      context.push('/certifications');
                    }
                  },
                );
              },
            );
          },
          loading: () => ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: 4,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, __) => LoadingSkeleton.card(height: 90),
          ),
          error: (err, _) => ErrorStateWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(notificationsProvider),
          ),
        ),
      ),
    );
  }
}
