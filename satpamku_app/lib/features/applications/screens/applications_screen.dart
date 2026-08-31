import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/application_model.dart';
import '../providers/applications_provider.dart';

class ApplicationsScreen extends ConsumerStatefulWidget {
  const ApplicationsScreen({super.key});

  @override
  ConsumerState<ApplicationsScreen> createState() => _ApplicationsScreenState();
}

class _ApplicationsScreenState extends ConsumerState<ApplicationsScreen> {
  int _selectedTabIndex = 0; // 0 = Active, 1 = Completed

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final appsAsync = ref.watch(candidateApplicationsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AppAvatar(
            name: user?.name ?? 'Satpam',
            imageUrl: user?.avatarUrl,
            radius: 18,
          ),
        ),
        title: const Text(
          'Lamaran Saya',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1B2A72), size: 24),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(candidateApplicationsProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Tab Switcher (Active vs Completed)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSegmentButton('Active', _selectedTabIndex == 0, () => setState(() => _selectedTabIndex = 0)),
                    ),
                    Expanded(
                      child: _buildSegmentButton('Completed', _selectedTabIndex == 1, () => setState(() => _selectedTabIndex = 1)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Application Cards List
              appsAsync.when(
                data: (applications) {
                  if (applications.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyStateWidget(
                        title: 'Belum Ada Lamaran',
                        message: 'Lamar lowongan kerja satpam yang cocok untuk melihat status lamaran di sini.',
                        icon: Icons.assignment_late_outlined,
                      ),
                    );
                  }

                  final filtered = _selectedTabIndex == 0
                      ? applications.where((a) => !['accepted', 'rejected', 'withdrawn'].contains(a.status)).toList()
                      : applications.where((a) => ['accepted', 'rejected', 'withdrawn'].contains(a.status)).toList();

                  final listToRender = filtered.isNotEmpty ? filtered : applications;
                  final activeFirst = listToRender.first;

                  return Column(
                    children: [
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listToRender.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final app = listToRender[index];
                          return _buildApplicationCard(app);
                        },
                      ),
                      const SizedBox(height: 20),

                      // Detailed Timeline Preview Card (as in Mockup 3)
                      _buildTimelineProgressCard(activeFirst),
                    ],
                  );
                },
                loading: () => ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, __) => LoadingSkeleton.card(height: 110),
                ),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(candidateApplicationsProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(JobApplicationModel app) {
    return InkWell(
      onTap: () => context.push('/applications/${app.id}'),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    app.jobTitle,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2A72),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _buildStatusBadge(app.status, app.statusLabel),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              app.companyName,
              style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Applied ${app.appliedTimeAgo}',
                  style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                ),
                const Row(
                  children: [
                    Text(
                      'View Details',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.chevron_right, size: 14, color: Color(0xFF1B2A72)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, String label) {
    Color bg = const Color(0xFFEEF2FF);
    Color text = const Color(0xFF1B2A72);

    if (status == 'interview_scheduled') {
      bg = const Color(0xFFEDE9FE);
      text = const Color(0xFF6D28D9);
    } else if (status == 'offered' || status == 'accepted') {
      bg = const Color(0xFFFEF3C7);
      text = const Color(0xFF92400E);
    } else if (status == 'rejected') {
      bg = const Color(0xFFFEE2E2);
      text = const Color(0xFFB91C1C);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: text,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTimelineProgressCard(JobApplicationModel app) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Center(
                  child: Icon(Icons.shield_outlined, color: Color(0xFF1B2A72), size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.jobTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      app.companyName,
                      style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 14),
          const Text(
            'Application Progress',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B2A72),
            ),
          ),
          const SizedBox(height: 14),

          // Steps
          _buildStep(
            isDone: true,
            isCurrent: false,
            title: 'Application Sent',
            date: 'Oct 12, 2023 - 09:00 AM',
          ),
          _buildStep(
            isDone: true,
            isCurrent: false,
            title: 'Profile Reviewed',
            date: 'Oct 14, 2023 - 14:30 PM',
          ),
          _buildStep(
            isDone: false,
            isCurrent: true,
            title: 'Interview Scheduled',
            date: 'Oct 18, 2023 - 10:00 AM',
            callout: 'Please prepare your original certification documents and ID for the interview.',
          ),
          _buildStep(
            isDone: false,
            isCurrent: false,
            isLast: true,
            title: 'Final Decision',
            date: 'Pending',
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required bool isDone,
    required bool isCurrent,
    bool isLast = false,
    required String title,
    required String date,
    String? callout,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone
                    ? const Color(0xFF16A34A)
                    : isCurrent
                        ? const Color(0xFF1B2A72)
                        : const Color(0xFFE2E8F0),
              ),
              child: Center(
                child: isDone
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : isCurrent
                        ? Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: callout != null ? 80 : 36,
                color: const Color(0xFFCBD5E1),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: isDone || isCurrent ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                date,
                style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
              ),
              if (callout != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    callout,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF334155),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ],
    );
  }
}
