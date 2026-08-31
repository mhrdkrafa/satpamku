import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/candidate_profile_provider.dart';

class CertificationsScreen extends ConsumerWidget {
  const CertificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;
    final certsAsync = ref.watch(candidateCertificationsProvider);

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
        onRefresh: () async => ref.invalidate(candidateCertificationsProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              const Text(
                'My Certifications',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage and verify your professional security credentials.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),

              // Button: + Add New Certification
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text(
                    'Add New Certification',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B2A72),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih berkas sertifikat Ijazah Gada / KTA')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),

              // Verification Status Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verification Status',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '85% Complete',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Icon(Icons.check_circle, size: 16, color: Color(0xFF16A34A)),
                        SizedBox(width: 8),
                        Text('Verified', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                        Spacer(),
                        Text('3', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: const [
                        Icon(Icons.pending, size: 16, color: Color(0xFFD97706)),
                        SizedBox(width: 8),
                        Text('Pending', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                        Spacer(),
                        Text('1', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.info_outline, size: 16, color: Color(0xFFD97706)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Verified certifications increase your profile visibility by 40% to top security firms.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B), height: 1.35),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Certification Cards List
              _buildCertCard(
                title: 'Gada Pratama',
                issuer: 'Polda Metro Jaya • Basic Security Training',
                issued: 'Jan 2022',
                validUntil: 'Jan 2025',
                isVerified: true,
              ),
              const SizedBox(height: 12),
              _buildCertCard(
                title: 'K3 Umum',
                issuer: 'BNSP • Keselamatan dan Kesehatan Kerja',
                issued: 'Mar 2021',
                validUntil: 'Mar 2024',
                isVerified: true,
              ),
              const SizedBox(height: 12),
              _buildCertCard(
                title: 'First Aid Training',
                issuer: 'Palang Merah Indonesia (PMI)',
                issued: 'Jun 2022',
                validUntil: 'Seumur Hidup',
                isVerified: false,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertCard({
    required String title,
    required String issuer,
    required String issued,
    required String validUntil,
    required bool isVerified,
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
            border: Border(left: BorderSide(color: Color(0xFFC69214), width: 4)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Icon(Icons.badge_outlined, color: Color(0xFF1B2A72), size: 24),
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
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B2A72),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isVerified ? const Color(0xFFF1F5F9) : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isVerified ? 'Verified' : 'Pending',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                  color: isVerified ? const Color(0xFF64748B) : const Color(0xFF92400E),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          issuer,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
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
                  _buildMetaChip(Icons.calendar_today_outlined, 'Issued: $issued'),
                  _buildMetaChip(Icons.history_toggle_off, 'Valid until: $validUntil'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF64748B)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF475569)),
          ),
        ],
      ),
    );
  }
}
