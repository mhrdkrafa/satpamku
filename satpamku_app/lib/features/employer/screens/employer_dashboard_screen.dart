import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/employer_models.dart';
import '../providers/employer_provider.dart';

class EmployerDashboardScreen extends ConsumerWidget {
  const EmployerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;
    final dashboardAsync = ref.watch(employerDashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: const Center(
              child: Icon(Icons.business, color: Color(0xFF1B2A72), size: 20),
            ),
          ),
        ),
        title: const Text(
          'Satpamku',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Color(0xFF1B2A72), size: 24),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(employerDashboardProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Subtitle
              const Text(
                'Employer Portal',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 2),
              Text(
                'Selamat Pagi, ${user?.name ?? "PT. Sekuriti Indonesia"}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 16),

              // KPI Metrics Cards (Row 1: Active Vacancies & New Applicants, Row 2: Interviews Today)
              dashboardAsync.when(
                data: (dashboard) => Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildKpiCard(
                            icon: Icons.work_outline,
                            iconColor: const Color(0xFF4338CA),
                            cardBg: const Color(0xFFEEF2FF),
                            title: 'Active Vacancies',
                            value: dashboard.activeJobs.toString(),
                            trendText: '+2 this week',
                            isTrendPositive: true,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildKpiCard(
                            icon: Icons.person_add_outlined,
                            iconColor: const Color(0xFFD97706),
                            cardBg: const Color(0xFFFEF3C7),
                            title: 'New Applicants',
                            value: dashboard.totalApplicants.toString(),
                            badgeText: 'Requires Review',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildKpiCard(
                      icon: Icons.calendar_today_outlined,
                      iconColor: const Color(0xFF15803D),
                      cardBg: const Color(0xFFDCFCE7),
                      title: 'Interviews Today',
                      value: dashboard.pendingInterviews.toString(),
                      badgeText: 'Scheduled',
                      isFullWidth: true,
                    ),
                  ],
                ),
                loading: () => Row(
                  children: [
                    Expanded(child: LoadingSkeleton.card(height: 110)),
                    const SizedBox(width: 12),
                    Expanded(child: LoadingSkeleton.card(height: 110)),
                  ],
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(height: 20),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline, size: 18),
                  label: const Text(
                    'Create New Job Post',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2A72),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => context.push('/employer/jobs/create'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.people_outline, size: 18, color: Color(0xFF1B2A72)),
                  label: const Text(
                    'Manage Candidates',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () => context.go('/employer/applicants'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Color(0xFF1B2A72)),
                  label: const Text(
                    'View Messages (3)',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pesan masuk pelamar akan dibuka.')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Recent Applicants Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Applicants',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2A72),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.go('/employer/applicants'),
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recent Applicants List
              dashboardAsync.when(
                data: (dashboard) {
                  return Column(
                    children: [
                      _buildApplicantCard(
                        context: context,
                        name: 'Budi Santoso',
                        headline: 'Gada Utama • 5 Yrs Exp',
                        location: 'Jakarta Selatan',
                        extraTag: 'First Aid Certified',
                        extraTagIcon: Icons.health_and_safety_outlined,
                        isVerified: true,
                        onReview: () => context.go('/employer/applicants'),
                      ),
                      const SizedBox(height: 12),
                      _buildApplicantCard(
                        context: context,
                        name: 'Agus Pratama',
                        headline: 'Gada Madya • 3 Yrs Exp',
                        location: 'Bekasi Barat',
                        extraTag: 'Patrol Driver',
                        extraTagIcon: Icons.directions_car_outlined,
                        isVerified: true,
                        onReview: () => context.go('/employer/applicants'),
                      ),
                      const SizedBox(height: 12),
                      _buildApplicantCard(
                        context: context,
                        name: 'Rina Melati',
                        headline: 'Gada Pratama • 1 Yr Exp',
                        location: 'Tangerang',
                        extraTag: 'Front Desk Sec.',
                        extraTagIcon: Icons.apartment_outlined,
                        isVerified: false,
                        onReview: () => context.go('/employer/applicants'),
                      ),
                    ],
                  );
                },
                loading: () => LoadingSkeleton.card(height: 140),
                error: (err, _) => ErrorStateWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(employerDashboardProvider),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required Color iconColor,
    required Color cardBg,
    required String title,
    required String value,
    String? trendText,
    bool isTrendPositive = true,
    String? badgeText,
    bool isFullWidth = false,
  }) {
    return Container(
      width: isFullWidth ? double.infinity : null,
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
              Row(
                children: [
                  Icon(icon, size: 16, color: iconColor),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              if (isFullWidth)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                ),
              ),
              const SizedBox(width: 10),
              if (trendText != null)
                Row(
                  children: [
                    Icon(
                      isTrendPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isTrendPositive ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trendText,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isTrendPositive ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: iconColor),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantCard({
    required BuildContext context,
    required String name,
    required String headline,
    required String location,
    required String extraTag,
    required IconData extraTagIcon,
    required bool isVerified,
    required VoidCallback onReview,
  }) {
    return Container(
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
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: const Icon(Icons.person, color: Color(0xFF1B2A72), size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        ),
                        if (isVerified) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle, size: 10, color: Color(0xFFD97706)),
                                SizedBox(width: 2),
                                Text('Verified', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      headline,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildTag(Icons.location_on_outlined, location),
              const SizedBox(width: 8),
              _buildTag(extraTagIcon, extraTag),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: OutlinedButton(
              onPressed: onReview,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1B2A72)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Review Application',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
          ),
        ],
      ),
    );
  }
}
