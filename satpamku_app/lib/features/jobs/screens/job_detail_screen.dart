import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../../core/widgets/loading_skeleton.dart';
import '../models/job_model.dart';
import '../providers/jobs_provider.dart';
import '../widgets/apply_bottom_sheet.dart';

class JobDetailScreen extends ConsumerStatefulWidget {
  final String slug;

  const JobDetailScreen({super.key, required this.slug});

  @override
  ConsumerState<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends ConsumerState<JobDetailScreen> {
  bool _isSaved = false;

  void _openApplyModal(JobDetailModel job) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ApplyBottomSheet(job: job),
    );
  }

  Future<void> _toggleSave(int jobId) async {
    try {
      final repo = ref.read(jobRepositoryProvider);
      final saved = await repo.toggleSaveJob(jobId);
      setState(() => _isSaved = saved);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(saved ? 'Lowongan disimpan ke bookmark.' : 'Lowongan dihapus dari bookmark.'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(jobDetailProvider(widget.slug));

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
          'Job Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Color(0xFF1B2A72)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan lowongan telah disalin ke clipboard.')),
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: detailAsync.whenOrNull(
        data: (job) => Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF1B2A72), width: 1.4),
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isSaved ? Icons.bookmark : Icons.bookmark_border,
                      color: const Color(0xFF1B2A72),
                      size: 22,
                    ),
                    onPressed: () => _toggleSave(job.id),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _openApplyModal(job),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2A72),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Apply Now',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: detailAsync.when(
        data: (job) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Card
                Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(11),
                              child: job.companyLogoUrl != null && job.companyLogoUrl!.isNotEmpty
                                  ? Image.network(
                                      job.companyLogoUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Icon(Icons.shield_outlined, color: Color(0xFF1B2A72), size: 26),
                                      ),
                                    )
                                  : const Center(
                                      child: Icon(Icons.shield_outlined, color: Color(0xFF1B2A72), size: 26),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B2A72),
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      job.companyName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.verified, size: 15, color: Color(0xFFC69214)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildHeaderChip(Icons.location_on_outlined, '${job.locationName}, Indonesia'),
                          _buildHeaderChip(Icons.schedule, 'Posted ${job.postedTimeAgo.isNotEmpty ? job.postedTimeAgo : "baru saja"}'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3 Metric Cards Row (Salary, Shift, Type)
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        label: 'SALARY',
                        value: job.formattedSalary,
                        subtitle: 'per month',
                        valueColor: const Color(0xFF16A34A),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        label: 'SHIFT',
                        value: job.formattedShift,
                        icon: Icons.sync,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildMetricCard(
                        label: 'TYPE',
                        value: job.employmentType.toUpperCase(),
                        icon: Icons.work_outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // SECTION 1: Job Description
                _buildSectionBox(
                  icon: Icons.description_outlined,
                  title: 'Job Description',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.description,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          height: 1.5,
                        ),
                      ),
                      if (job.responsibilitiesList.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ...job.responsibilitiesList.map(
                          (resp) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B2A72))),
                                Expanded(
                                  child: Text(
                                    resp,
                                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF475569), height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION 2: Requirements
                _buildSectionBox(
                  icon: Icons.fact_check_outlined,
                  title: 'Requirements',
                  child: Column(
                    children: [
                      if (job.requiredCertificateLevel != 'none') ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.workspace_premium, color: Color(0xFFD97706), size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${_formatCertName(job.requiredCertificateLevel)} Certification (Mandatory, active).',
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                      if (job.requirementsList.isNotEmpty)
                        ...job.requirementsList.map(
                          (req) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    req,
                                    style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155), height: 1.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION 3: Benefits (2x2 Grid)
                _buildSectionBox(
                  icon: Icons.card_giftcard,
                  title: 'Benefits',
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _buildBenefitGridItem(Icons.health_and_safety_outlined, 'BPJS Kesehatan')),
                          const SizedBox(width: 10),
                          Expanded(child: _buildBenefitGridItem(Icons.account_balance_outlined, 'BPJS Ketenagakerjaan')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: _buildBenefitGridItem(Icons.restaurant_outlined, 'Meal Allowance')),
                          const SizedBox(width: 10),
                          Expanded(child: _buildBenefitGridItem(Icons.dry_cleaning_outlined, 'Uniform Provided')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION 4: Company Profile Box
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
                      Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.business, color: Color(0xFF1B2A72), size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  job.companyName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1B2A72),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Badan Usaha Jasa Pengamanan (BUJP)',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${job.companyName} adalah penyedia layanan pengamanan terpercaya bersertifikasi Mabes Polri dengan ribuan personil satpam handal.',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorStateWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(jobDetailProvider(widget.slug)),
        ),
      ),
    );
  }

  Widget _buildHeaderChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    String? subtitle,
    IconData? icon,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.5),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 14, color: valueColor ?? const Color(0xFF1B2A72)),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? const Color(0xFF1B2A72),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionBox({required IconData icon, required String title, required Widget child}) {
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
              Icon(icon, size: 18, color: const Color(0xFF1B2A72)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildBenefitGridItem(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF1B2A72)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCertName(String level) {
    switch (level.toLowerCase()) {
      case 'gada_utama':
        return 'Gada Utama';
      case 'gada_madya':
        return 'Gada Madya';
      default:
        return 'Gada Pratama';
    }
  }
}
