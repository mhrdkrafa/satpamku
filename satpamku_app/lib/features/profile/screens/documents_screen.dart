import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/candidate_profile_provider.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final List<Map<String, dynamic>> _documents = [
    {
      'id': 1,
      'type': 'KTP',
      'title': 'KTP (Kartu Tanda Penduduk)',
      'subtitle': 'Wajib untuk verifikasi identitas resmi Polri',
      'fileName': 'ktp_scan_front_2024.jpg',
      'fileMeta': '1.2 MB • Diunggah 12 Okt 2024',
      'isVerified': true,
      'badgeText': 'Verified',
      'icon': Icons.image_outlined,
      'iconColor': Color(0xFF64748B),
    },
    {
      'id': 2,
      'type': 'SKCK',
      'title': 'SKCK (Surat Keterangan Catatan Kepolisian)',
      'subtitle': 'Wajib untuk pemeriksaan latar belakang keamanan',
      'fileName': 'skck_polres_metro_2024.pdf',
      'fileMeta': '850 KB • Menunggu Verifikasi Admin',
      'isVerified': false,
      'badgeText': 'Pending',
      'icon': Icons.description_outlined,
      'iconColor': Color(0xFFD97706),
    },
    {
      'id': 3,
      'type': 'CV',
      'title': 'Curriculum Vitae (CV Satpam)',
      'subtitle': 'Ringkasan profil dan riwayat penugasan',
      'fileName': 'CV_Budi_Santoso_Security_2024.pdf',
      'fileMeta': '2.4 MB • Diunggah 01 Nov 2024',
      'isVerified': true,
      'badgeText': 'Active',
      'icon': Icons.picture_as_pdf,
      'iconColor': Color(0xFFEF4444),
    },
    {
      'id': 4,
      'type': 'KTA',
      'title': 'KTA Satpam Polri (Kartu Tanda Anggota)',
      'subtitle': 'Legalitas keanggotaan satpam aktif',
      'fileName': 'kta_satpam_polri_2024.jpg',
      'fileMeta': '1.5 MB • Diunggah 15 Nov 2024',
      'isVerified': true,
      'badgeText': 'Verified',
      'icon': Icons.badge_outlined,
      'iconColor': Color(0xFF1B2A72),
    },
  ];

  void _showUploadModal({String? defaultType}) {
    String selectedType = defaultType ?? 'SKCK';
    final fileNameController = TextEditingController(text: 'dokumen_${selectedType.toLowerCase()}_${DateTime.now().year}.pdf');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFCBD5E1),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Unggah Dokumen Berkas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2A72),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Jenis Dokumen
                  const Text('Jenis Dokumen', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedType,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                        items: const [
                          DropdownMenuItem(value: 'SKCK', child: Text('SKCK (Kepolisian)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'KTP', child: Text('KTP (Identitas)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'CV', child: Text('Curriculum Vitae (CV)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'KTA', child: Text('KTA Satpam Polri', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'Ijazah', child: Text('Ijazah Pendidikan Terakhir', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'Surat Dokter', child: Text('Surat Keterangan Sehat & Bebas Narkoba', style: TextStyle(fontSize: 13))),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedType = val;
                              fileNameController.text = 'dokumen_${val.toLowerCase()}_${DateTime.now().year}.pdf';
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Nama Berkas
                  const Text('Nama / Judul Berkas', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: fileNameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Unggah
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B2A72),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () async {
                        final newDoc = {
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'type': selectedType,
                          'title': '$selectedType Resmi',
                          'subtitle': 'Dokumen pendukung lamaran satpam',
                          'fileName': fileNameController.text.trim(),
                          'fileMeta': '1.1 MB • Baru saja diunggah',
                          'isVerified': false,
                          'badgeText': 'Pending',
                          'icon': selectedType == 'CV' ? Icons.picture_as_pdf : Icons.description_outlined,
                          'iconColor': selectedType == 'CV' ? const Color(0xFFEF4444) : const Color(0xFFD97706),
                        };

                        setState(() {
                          _documents.add(newDoc);
                        });

                        try {
                          await ref.read(candidateRepositoryProvider).addDocument(
                            documentType: selectedType.toLowerCase(),
                            title: fileNameController.text.trim(),
                          );
                          ref.invalidate(candidateDocumentsProvider);
                          ref.invalidate(candidateFullProfileProvider);
                        } catch (_) {}

                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berkas $selectedType berhasil diunggah & diajukan verifikasi!'),
                              backgroundColor: const Color(0xFF16A34A),
                            ),
                          );
                        }
                      },
                      child: const Text('Unggah & Simpan Berkas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _deleteDoc(int id, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Dokumen?'),
        content: Text('Apakah Anda yakin ingin menghapus berkas $title?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        _documents.removeWhere((d) => d['id'] == id);
      });
      try {
        await ref.read(candidateRepositoryProvider).deleteDocument(id);
        ref.invalidate(candidateDocumentsProvider);
        ref.invalidate(candidateFullProfileProvider);
      } catch (_) {}

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berkas berhasil dihapus.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;

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
              const SizedBox(height: 16),

              // Button: + Unggah Dokumen Baru
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.upload_file, size: 18),
                  label: const Text(
                    'Unggah Dokumen / Berkas Baru',
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
                  onPressed: () => _showUploadModal(),
                ),
              ),
              const SizedBox(height: 18),

              // Document Cards
              ..._documents.map((doc) {
                final id = doc['id'] as int;
                final title = doc['title'] as String;
                final subtitle = doc['subtitle'] as String;
                final fileName = doc['fileName'] as String;
                final fileMeta = doc['fileMeta'] as String;
                final isVerified = doc['isVerified'] as bool;
                final badgeText = doc['badgeText'] as String;
                final icon = doc['icon'] as IconData;
                final iconColor = doc['iconColor'] as Color;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _buildDocCard(
                    title: title,
                    subtitle: subtitle,
                    badgeText: badgeText,
                    isVerified: isVerified,
                    child: _buildUploadedFileBox(
                      icon: icon,
                      iconColor: iconColor,
                      fileName: fileName,
                      fileMeta: fileMeta,
                      onView: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Membuka pratinjau $fileName')),
                        );
                      },
                      onDelete: () => _deleteDoc(id, title),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 10),

              // Document Guidelines Card
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
                    Row(
                      children: const [
                        Icon(Icons.info_outline, color: Color(0xFF1B2A72), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Panduan Berkas Dokumen',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildGuidelineItem('Format file: PDF, JPG, atau PNG dengan ukuran maksimal 5 MB.'),
                    _buildGuidelineItem('Pastikan foto KTP dan KTA jelas, tidak buram, dan teks dapat terbaca.'),
                    _buildGuidelineItem('SKCK yang diunggah harus masih dalam masa berlaku aktif kepolisian.'),
                    _buildGuidelineItem('Dokumen CV disarankan mencantumkan tinggi badan, berat badan, dan riwayat penugasan.'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
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
                      Icon(
                        isVerified ? Icons.check_circle : Icons.pending,
                        size: 11,
                        color: isVerified ? const Color(0xFF16A34A) : const Color(0xFFD97706),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isVerified ? const Color(0xFF16A34A) : const Color(0xFFD97706),
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
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
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
                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_red_eye_outlined, size: 18, color: Color(0xFF64748B)),
            onPressed: onView,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Lihat File',
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
            onPressed: onDelete,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            tooltip: 'Hapus File',
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: Color(0xFF475569), height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
