import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/employer_provider.dart';

class RecruitmentPipelineScreen extends ConsumerWidget {
  const RecruitmentPipelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Subtitle
            const Text(
              'Pipeline',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2A72),
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Senior Security Guard (Night Shift)',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),

            // 4 KPI METRICS (2x2 Grid)
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'TOTAL APPLICANTS',
                    value: '124',
                    icon: Icons.people_outline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'SCREENING',
                    value: '45',
                    icon: Icons.filter_alt_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'INTERVIEW',
                    value: '12',
                    icon: Icons.chat_bubble_outline,
                    iconColor: const Color(0xFFD97706),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'HIRED',
                    value: '3',
                    icon: Icons.verified_user_outlined,
                    iconColor: const Color(0xFF16A34A),
                    valueColor: const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // KANBAN PIPELINE COLUMNS (Horizontal Scroll)
            SizedBox(
              height: 380,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // COLUMN 1: Applied (64)
                  _buildKanbanColumn(
                    title: 'Applied',
                    colorDot: const Color(0xFF64748B),
                    count: 64,
                    cards: [
                      _buildKanbanCard(
                        context: context,
                        name: 'Budi Santoso',
                        details: '3 Yrs Exp • Gada Pratama',
                        time: '2d ago',
                        hasAvatar: true,
                        onTap: () => context.push('/employer/applicants/1'),
                      ),
                      _buildKanbanCard(
                        context: context,
                        name: 'Agus Wijaya',
                        details: '1 Yr Exp • Uncertified',
                        time: '3d ago',
                        initials: 'AW',
                        hasAvatar: false,
                        onTap: () => context.push('/employer/applicants/2'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // COLUMN 2: Screening (45)
                  _buildKanbanColumn(
                    title: 'Screening',
                    colorDot: const Color(0xFF1B2A72),
                    count: 45,
                    cards: [
                      _buildKanbanCard(
                        context: context,
                        name: 'Siti Rahma',
                        details: 'Doc Verified • Gada Pratama',
                        time: '1d ago',
                        isTopMatch: true,
                        hasAvatar: true,
                        onTap: () => context.push('/employer/applicants/3'),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // COLUMN 3: Interview (12)
                  _buildKanbanColumn(
                    title: 'Interview',
                    colorDot: const Color(0xFFD97706),
                    count: 12,
                    cards: [
                      _buildKanbanCard(
                        context: context,
                        name: 'Rian Pratama',
                        details: 'Scheduled 20 Oct 10:00 WIB',
                        time: '4d ago',
                        hasAvatar: true,
                        onTap: () => context.push('/employer/applicants/1'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    Color? iconColor,
    Color? valueColor,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
              ),
              Icon(icon, size: 18, color: iconColor ?? const Color(0xFF1B2A72)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: valueColor ?? const Color(0xFF1B2A72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn({
    required String title,
    required Color colorDot,
    required int count,
    required List<Widget> cards,
  }) {
    return Container(
      width: 270,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
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
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: colorDot, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  count.toString(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: cards,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanCard({
    required BuildContext context,
    required String name,
    required String details,
    required String time,
    String? initials,
    bool hasAvatar = true,
    bool isTopMatch = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isTopMatch ? const Color(0xFFC69214) : const Color(0xFFE2E8F0),
            width: isTopMatch ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isTopMatch) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'TOP MATCH',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                ),
              ),
              const SizedBox(height: 8),
            ],
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: initials != null
                        ? Text(initials, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)))
                        : const Icon(Icons.person, color: Color(0xFF1B2A72), size: 22),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        details,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 12, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 10.5, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
