import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../providers/employer_provider.dart';

class EmployerJobsScreen extends ConsumerStatefulWidget {
  const EmployerJobsScreen({super.key});

  @override
  ConsumerState<EmployerJobsScreen> createState() => _EmployerJobsScreenState();
}

class _EmployerJobsScreenState extends ConsumerState<EmployerJobsScreen> {
  int _selectedTab = 0; // 0: Active, 1: Drafts, 2: Expired

  @override
  Widget build(BuildContext context) {
    final jobsAsync = ref.watch(employerJobsProvider);

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
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Color(0xFF1B2A72), size: 24),
            onPressed: () => context.push('/notifications'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1B2A72),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => context.push('/employer/jobs/create'),
        child: const Icon(Icons.add, size: 28),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(employerJobsProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              const Text(
                'Job Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your active listings and past vacancies.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              // Tab Bar (Active / Drafts / Expired)
              Row(
                children: [
                  _buildTabItem('Active (3)', 0),
                  const SizedBox(width: 16),
                  _buildTabItem('Drafts (1)', 1),
                  const SizedBox(width: 16),
                  _buildTabItem('Expired (12)', 2),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 16),

              // Job Cards List
              _buildJobManagementCard(
                title: 'Senior Security Guard',
                location: 'Jakarta Selatan',
                type: 'Full-time',
                totalApplicants: 24,
                newApplicants: 5,
                postedDate: 'Oct 12, 2023',
                status: 'Active',
                isActive: true,
                onTap: () => context.go('/employer/applicants'),
              ),
              const SizedBox(height: 14),

              _buildJobManagementCard(
                title: 'Patrol Officer Night Shift',
                location: 'Tangerang',
                type: 'Contract',
                totalApplicants: 12,
                newApplicants: 2,
                postedDate: 'Oct 15, 2023',
                status: 'Active',
                isActive: true,
                onTap: () => context.go('/employer/applicants'),
              ),
              const SizedBox(height: 14),

              _buildJobManagementCard(
                title: 'Event Security Detail',
                location: 'Bandung',
                type: 'Temporary',
                totalApplicants: 45,
                newApplicants: 0,
                postedDate: 'Sep 01, 2023',
                status: 'Expired',
                isActive: false,
                onTap: () => context.go('/employer/applicants'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: isSelected ? const Border(bottom: BorderSide(color: Color(0xFF1B2A72), width: 2.5)) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildJobManagementCard({
    required String title,
    required String location,
    required String type,
    required int totalApplicants,
    required int newApplicants,
    required String postedDate,
    required String status,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: isActive ? const Color(0xFF16A34A) : const Color(0xFF94A3B8),
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Status Badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isActive ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Chips
              Row(
                children: [
                  _buildChip(Icons.location_on_outlined, location),
                  const SizedBox(width: 8),
                  _buildChip(Icons.schedule, type),
                ],
              ),
              const SizedBox(height: 12),

              // Applicants Box
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Applicants', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                          const SizedBox(height: 2),
                          Text(
                            '$totalApplicants Total',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                          ),
                        ],
                      ),
                      if (newApplicants > 0)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('New', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            const SizedBox(height: 2),
                            Text(
                              '+$newApplicants',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),

              // Footer: Posted Date & Action Buttons (Edit, Deactivate)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posted: $postedDate',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF1B2A72)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF1B2A72)),
                          padding: EdgeInsets.zero,
                          onPressed: () => context.push('/employer/jobs/create'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFEF4444)),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.block, size: 16, color: Color(0xFFEF4444)),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Lowongan telah ditutup.')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(IconData icon, String label) {
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
