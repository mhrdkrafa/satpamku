import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../models/employer_models.dart';
import '../providers/employer_provider.dart';

class EmployerApplicantsScreen extends ConsumerStatefulWidget {
  const EmployerApplicantsScreen({super.key});

  @override
  ConsumerState<EmployerApplicantsScreen> createState() => _EmployerApplicantsScreenState();
}

class _EmployerApplicantsScreenState extends ConsumerState<EmployerApplicantsScreen> {
  final _searchController = TextEditingController();
  int _selectedTab = 0; // 0: New (12), 1: Shortlisted (8), 2: Interview (5)

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(employerApplicantFilterProvider);
    final applicantsAsync = ref.watch(employerApplicantsProvider);

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
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(employerApplicantsProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back to Jobs Navigation Link
              InkWell(
                onTap: () => context.go('/employer/jobs'),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 14, color: Color(0xFF1B2A72)),
                    SizedBox(width: 4),
                    Text(
                      'Back to Jobs',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),

              // Title & Subtitle
              const Text(
                'Senior Security Officer',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Jakarta Pusat • Full Time • 45 Applicants',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              // Search Bar & Filter Button
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontSize: 13),
                        decoration: const InputDecoration(
                          hintText: 'Search applicants by name or certification.',
                          hintStyle: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                          prefixIcon: Icon(Icons.search, size: 18, color: Color(0xFF64748B)),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFCBD5E1)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.tune, size: 16, color: Color(0xFF1B2A72)),
                          SizedBox(width: 6),
                          Text('Filters', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tab Filter Bar (New (12) / Shortlisted (8) / Interview (5))
              Row(
                children: [
                  _buildTab('New (12)', 0),
                  const SizedBox(width: 16),
                  _buildTab('Shortlisted (8)', 1),
                  const SizedBox(width: 16),
                  _buildTab('Interview (5)', 2),
                ],
              ),
              const Divider(height: 1, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 16),

              // Applicant Cards List
              _buildCandidateCard(
                name: 'Budi Santoso',
                appliedTime: 'Applied 2d ago',
                experience: '5 Years Experience',
                cert: 'Gada Madya',
                heightInfo: '175 cm',
                hasAvatar: true,
                onReview: () => context.push('/employer/applicants/1'),
              ),
              const SizedBox(height: 12),

              _buildCandidateCard(
                name: 'Agus Wijaya',
                appliedTime: 'Applied 3d ago',
                experience: '3 Years Experience',
                cert: 'Gada Pratama',
                skill: 'Bela Diri',
                initials: 'AW',
                hasAvatar: false,
                onReview: () => context.push('/employer/applicants/2'),
              ),
              const SizedBox(height: 12),

              _buildCandidateCard(
                name: 'Siti Rahma',
                appliedTime: 'Applied 5d ago',
                experience: '2 Years Experience',
                cert: 'Gada Pratama',
                skill: 'English Basic',
                hasAvatar: true,
                onReview: () => context.push('/employer/applicants/3'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, int index) {
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
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  Widget _buildCandidateCard({
    required String name,
    required String appliedTime,
    required String experience,
    required String cert,
    String? heightInfo,
    String? skill,
    String? initials,
    bool hasAvatar = true,
    required VoidCallback onReview,
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
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Color(0xFF1B2A72), width: 4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: initials != null
                          ? Text(
                              initials,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                            )
                          : const Icon(Icons.person, color: Color(0xFF1B2A72), size: 28),
                    ),
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
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2A72),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                appliedTime,
                                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.work_outline, size: 13, color: Color(0xFF64748B)),
                            const SizedBox(width: 4),
                            Text(
                              experience,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildTag(Icons.security, cert),
                  if (heightInfo != null) _buildTag(Icons.height, heightInfo),
                  if (skill != null) _buildTag(Icons.sports_martial_arts, skill),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: ElevatedButton(
                        onPressed: onReview,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B2A72),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text(
                          'Review Profile',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.more_horiz, size: 18, color: Color(0xFF64748B)),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
