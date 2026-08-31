import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../models/employer_applicant_model.dart';
import '../providers/employer_provider.dart';
import '../widgets/schedule_interview_dialog.dart';

class EmployerApplicantDetailScreen extends ConsumerStatefulWidget {
  final int applicationId;

  const EmployerApplicantDetailScreen({super.key, required this.applicationId});

  @override
  ConsumerState<EmployerApplicantDetailScreen> createState() => _EmployerApplicantDetailScreenState();
}

class _EmployerApplicantDetailScreenState extends ConsumerState<EmployerApplicantDetailScreen> {
  bool _isUpdating = false;

  Future<void> _updateStatus(String newStatus, {DateTime? interviewAt, String? interviewLocation, String? rejectionReason, String? notes}) async {
    setState(() => _isUpdating = true);
    try {
      final repo = ref.read(employerRepositoryProvider);
      await repo.changeApplicantStatus(
        widget.applicationId,
        status: newStatus,
        interviewAt: interviewAt,
        interviewLocation: interviewLocation,
        rejectionReason: rejectionReason,
        employerNotes: notes,
      );

      ref.invalidate(employerApplicantDetailProvider(widget.applicationId));
      ref.invalidate(employerApplicantsProvider);
      ref.invalidate(employerDashboardProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status pelamar diubah menjadi $newStatus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: const Color(0xFFEF4444)),
        );
      }
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }

  void _openScheduleDialog(String candidateName) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ScheduleInterviewDialog(candidateName: candidateName),
    );

    if (result != null) {
      await _updateStatus(
        'interview_scheduled',
        interviewAt: result['interview_at'] as DateTime?,
        interviewLocation: result['interview_location'] as String?,
        notes: result['employer_notes'] as String?,
      );
    }
  }

  void _openRejectDialog() async {
    final reasonController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Tolak Berkas Pelamar?', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2A72))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Berikan catatan alasan mengapa kualifikasi belum sesuai:'),
            const SizedBox(height: 12),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Misal: Kebutuhan tinggi badan minimal belum terpenuhi...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Tolak Pelamar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _updateStatus('rejected', rejectionReason: reasonController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final applicantAsync = ref.watch(employerApplicantDetailProvider(widget.applicationId));

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
          'Applicant Detail',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF1B2A72)),
            onPressed: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP CANDIDATE SUMMARY CARD
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFC69214), width: 4)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFCBD5E1)),
                                ),
                                child: const Icon(Icons.person, color: Color(0xFF1B2A72), size: 36),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAB308),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Budi Santoso',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B2A72),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Senior Security Officer • 5 Years Experience',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Available Now',
                                    style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                                  ),
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
                          _buildChip(Icons.location_on_outlined, 'Jakarta Selatan'),
                          _buildChip(Icons.security, 'Gada Pratama Certified'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      const SizedBox(height: 10),

                      const Text(
                        'Dedicated security professional with 5 years of experience in corporate and residential environments. Proven track record in access control, CCTV monitoring, and emergency response.',
                        style: TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.45),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // SECTION 1: Documents & Certifications
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.folder_open_outlined, color: Color(0xFF1B2A72), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Documents & Certifications',
                        style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildDocItem(Icons.description_outlined, 'Curriculum Vitae', 'PDF • 1.2 MB'),
                  const SizedBox(height: 10),
                  _buildDocItem(Icons.workspace_premium_outlined, 'Gada Pratama Cert', 'JPG • 800 KB'),
                  const SizedBox(height: 10),
                  _buildDocItem(Icons.badge_outlined, 'KTP (ID Card)', 'JPG • 500 KB'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // SECTION 2: Application Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Actions',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                  ),
                  const SizedBox(height: 14),

                  // Schedule Interview (Primary)
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_month, size: 18),
                      label: const Text('Schedule Interview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2A72),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _openScheduleDialog('Budi Santoso'),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.bookmark_border, size: 16, color: Color(0xFF1B2A72)),
                            label: const Text('Shortlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1B2A72))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () => _updateStatus('shortlisted'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 44,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.close, size: 16, color: Color(0xFFEF4444)),
                            label: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFEF4444))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFCA5A5)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: _openRejectDialog,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // SECTION 3: Application Timeline
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Application Timeline',
                    style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                  ),
                  const SizedBox(height: 14),

                  _buildTimelineItem(
                    color: const Color(0xFF16A34A),
                    title: 'Applied for Head of Security',
                    time: 'Oct 24, 2023 • 09:30 AM',
                    hasLine: true,
                  ),
                  _buildTimelineItem(
                    color: const Color(0xFFEAB308),
                    title: 'Under Review',
                    time: 'Oct 25, 2023 • 02:15 PM',
                    hasLine: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
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

  Widget _buildDocItem(IconData icon, String title, String size) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF1B2A72)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(size, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          const Icon(Icons.download, size: 18, color: Color(0xFF1B2A72)),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required Color color,
    required String title,
    required String time,
    required bool hasLine,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            if (hasLine)
              Container(width: 2, height: 36, color: const Color(0xFFCBD5E1)),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              const SizedBox(height: 2),
              Text(time, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
