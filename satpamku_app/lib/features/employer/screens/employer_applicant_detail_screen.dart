import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/app_badge.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
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
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
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
        title: const Text('Tolak Berkas Pelamar?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Berikan catatan alasan mengapa kualifikasi belum sesuai:'),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(hintText: 'Misal: Kebutuhan tinggi badan minimal belum terpenuhi...'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Tolak Pelamar'),
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
    final theme = Theme.of(context);
    final detailAsync = ref.watch(employerApplicantDetailProvider(widget.applicationId));

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Dossier Pelamar Satpam'),
      ),
      bottomNavigationBar: detailAsync.whenOrNull(
        data: (applicant) => Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: const BoxDecoration(
            color: AppColors.lightSurface,
            border: Border(top: BorderSide(color: AppColors.lightBorder)),
          ),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _openRejectDialog,
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.error),
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _updateStatus('shortlisted'),
                    child: const Text('Shortlist'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: AppButton(
                    text: 'Jadwalkan Interview',
                    isLoading: _isUpdating,
                    onPressed: () => _openScheduleDialog(applicant.candidate.name),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: detailAsync.when(
        data: (applicant) {
          final cand = applicant.candidate;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Candidate Header Card
                AppCard(
                  child: Column(
                    children: [
                      AppAvatar(name: cand.name, imageUrl: cand.avatarUrl, radius: 36, isVerified: true),
                      const SizedBox(height: AppSpacing.md),
                      Text(cand.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      if (cand.headline != null) ...[
                        const SizedBox(height: 2),
                        Text(cand.headline!, textAlign: TextAlign.center, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.lightTextSecondary)),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: AppSpacing.xs,
                        children: [
                          AppBadge.certificate(cand.highestCertificateLevel),
                          const AppBadge(label: 'KTA Satpam Aktif', variant: AppBadgeVariant.success, isSmall: true),
                        ],
                      ),
                      const Divider(height: AppSpacing.lg),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildContactInfo(Icons.phone, cand.phone ?? '-'),
                          _buildContactInfo(Icons.email, cand.email),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Physical Attributes & Driving License
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kualifikasi Fisik & Lisensi', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      const Divider(height: AppSpacing.md),
                      _buildInfoRow('Tinggi Badan', cand.heightCm != null ? '${cand.heightCm} cm' : '-'),
                      _buildInfoRow('Berat Badan', cand.weightKg != null ? '${cand.weightKg} kg' : '-'),
                      _buildInfoRow('Golongan Darah', cand.bloodType ?? '-'),
                      _buildInfoRow('SIM Dimiliki', [
                        if (cand.hasSimA) 'SIM A',
                        if (cand.hasSimB1) 'SIM B1',
                        if (cand.hasSimC) 'SIM C',
                      ].join(', ')),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Cover Letter
                if (applicant.coverLetter != null && applicant.coverLetter!.isNotEmpty) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Surat Pengantar Pelamar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const Divider(height: AppSpacing.md),
                        Text(applicant.coverLetter!, style: theme.textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Experiences
                if (cand.experiences.isNotEmpty) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Riwayat Pengalaman Kerja (${cand.experiences.length})', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const Divider(height: AppSpacing.md),
                        ...cand.experiences.map((exp) => Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(exp.positionTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${exp.companyName} • ${exp.startDate} - ${exp.isCurrent ? 'Sekarang' : exp.endDate}', style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Action Accept / Reject Big Buttons
                AppButton(
                  text: 'Terima Sebagai Personil Satpam',
                  variant: AppButtonVariant.secondary,
                  onPressed: () => _updateStatus('accepted'),
                ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => ErrorStateWidget(
          message: err.toString(),
          onRetry: () => ref.invalidate(employerApplicantDetailProvider(widget.applicationId)),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.lightTextSecondary)),
          Text(value.isEmpty ? '-' : value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
