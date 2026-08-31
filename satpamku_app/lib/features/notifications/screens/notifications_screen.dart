import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/notifications_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B2A72)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
            onPressed: () async {
              await ref.read(notificationRepositoryProvider).markAllAsRead();
              ref.invalidate(notificationsProvider);
            },
            child: const Text(
              'Mark all read',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(notificationsProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SECTION: Today
              Row(
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B2A72),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      '2 New',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              _buildNotifCard(
                context: context,
                icon: Icons.calendar_month,
                iconBg: const Color(0xFFFEF3C7),
                iconColor: const Color(0xFFD97706),
                title: 'Interview Scheduled',
                body: 'PT. Garuda Security has scheduled an interview for the Chief Security Officer position.',
                time: '10:30 AM • Action Required',
                isUnread: true,
                onTap: () => context.push('/applications'),
              ),
              const SizedBox(height: 12),

              _buildNotifCard(
                context: context,
                icon: Icons.remove_red_eye_outlined,
                iconBg: const Color(0xFFEEF2FF),
                iconColor: const Color(0xFF4F46E5),
                title: 'Application Reviewed',
                body: 'Your application for Night Guard at Mall Kelapa Gading was reviewed.',
                time: '08:15 AM',
                isUnread: true,
                onTap: () => context.push('/applications'),
              ),
              const SizedBox(height: 20),

              // SECTION: Yesterday
              const Text(
                'Yesterday',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 12),

              _buildNotifCard(
                context: context,
                icon: Icons.work_outline,
                iconBg: const Color(0xFFF1F5F9),
                iconColor: const Color(0xFF64748B),
                title: 'New Job Alert',
                body: '3 new jobs match your preference for Corporate Security in Jakarta Selatan.',
                time: 'Yesterday, 14:20 PM',
                actionButtonText: 'View Jobs',
                onActionTap: () => context.push('/jobs'),
                onTap: () => context.push('/jobs'),
              ),
              const SizedBox(height: 12),

              _buildNotifCard(
                context: context,
                icon: Icons.verified_user_outlined,
                iconBg: const Color(0xFFF1F5F9),
                iconColor: const Color(0xFF64748B),
                title: 'Profile Verification Complete',
                body: 'Your Gada Pratama certificate has been verified. You now have the verified badge on your profile.',
                time: 'Yesterday, 09:00 AM',
                onTap: () => context.push('/profile'),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard({
    required BuildContext context,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String body,
    required String time,
    bool isUnread = false,
    String? actionButtonText,
    VoidCallback? onActionTap,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4F46E5),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    time,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                  ),
                  if (actionButtonText != null) ...[
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: onActionTap ?? onTap,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFCBD5E1)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        child: Text(
                          actionButtonText,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
