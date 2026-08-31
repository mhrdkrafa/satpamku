import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/candidate_profile_provider.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;
    final docsAsync = ref.watch(candidateDocumentsProvider);

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
        onRefresh: () async => ref.invalidate(candidateDocumentsProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              const Text(
                'My Documents',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Manage your verification documents and CV for job applications.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 18),

              // CARD 1: KTP (Verified)
              _buildDocCard(
                title: 'KTP (Kartu Tanda Penduduk)',
                subtitle: 'Required for identity verification',
                badgeText: 'Verified',
                isVerified: true,
                child: _buildUploadedFileBox(
                  icon: Icons.image_outlined,
                  iconColor: const Color(0xFF64748B),
                  fileName: 'ktp_scan_front_2023.jpg',
                  fileMeta: '1.2 MB • Uploaded Oct 12, 2023',
                  onView: () {},
                  onDelete: () {},
                ),
              ),
              const SizedBox(height: 14),

              // CARD 2: SKCK (Pending / Upload Box)
              _buildDocCard(
                title: 'SKCK (Police Certificate)',
                subtitle: 'Required for background check',
                badgeText: 'Pending',
                isVerified: false,
                child: _buildDashedUploadBox(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih file SKCK dari perangkat (PDF/JPG/PNG)')),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),

              // CARD 3: Curriculum Vitae (CV)
              _buildDocCard(
                title: 'Curriculum Vitae (CV)',
                subtitle: 'Your professional experience',
                child: _buildUploadedFileBox(
                  icon: Icons.picture_as_pdf,
                  iconColor: const Color(0xFFEF4444),
                  fileName: 'Budi_Santoso_Security_CV_2023.pdf',
                  fileMeta: '2.4 MB • Uploaded Nov 01, 2023',
                  onView: () {},
                  onDelete: () {},
                ),
              ),
              const SizedBox(height: 18),

              // Document Guidelines Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF1B2A72), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Document Guidelines',
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    _GuidelineItem(text: 'Ensure all documents are clearly legible.'),
                    SizedBox(height: 6),
                    _GuidelineItem(text: 'SKCK must be valid for at least the next 3 months.'),
                    SizedBox(height: 6),
                    _GuidelineItem(text: 'CV should highlight your security certifications (Gada Pratama, etc.).'),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocCard({
    required String title,
    required String subtitle,
    String? badgeText,
    bool isVerified = false,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.badge_outlined, color: Color(0xFF1B2A72), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              if (badgeText != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isVerified ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isVerified ? Icons.check_circle : Icons.pending, size: 12, color: isVerified ? const Color(0xFF16A34A) : const Color(0xFF92400E)),
                      const SizedBox(width: 4),
                      Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isVerified ? const Color(0xFF16A34A) : const Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildUploadedFileBox({
    required IconData icon,
    required Color iconColor,
    required String fileName,
    required String fileMeta,
    required VoidCallback onView,
    required VoidCallback onDelete,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  fileMeta,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.visibility_outlined, size: 20, color: Color(0xFF1B2A72)),
            onPressed: onView,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFEF4444)),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildDashedUploadBox({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF818CF8),
            style: BorderStyle.solid,
            width: 1.2,
          ),
        ),
        child: const Column(
          children: [
            Icon(Icons.file_upload_outlined, size: 28, color: Color(0xFF1B2A72)),
            SizedBox(height: 8),
            Text(
              'Click to upload or drag and drop',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
            ),
            SizedBox(height: 2),
            Text(
              'PDF, JPG or PNG (max. 5MB)',
              style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuidelineItem extends StatelessWidget {
  final String text;

  const _GuidelineItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check, size: 14, color: Color(0xFF1B2A72)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Color(0xFF334155), height: 1.35),
          ),
        ),
      ],
    );
  }
}
