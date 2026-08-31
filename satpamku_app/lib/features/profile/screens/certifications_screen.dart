import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_avatar.dart';
import '../../../core/widgets/empty_state_widget.dart';
import '../../../core/widgets/error_state_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../models/candidate_profile_model.dart';
import '../providers/candidate_profile_provider.dart';

class CertificationsScreen extends ConsumerStatefulWidget {
  const CertificationsScreen({super.key});

  @override
  ConsumerState<CertificationsScreen> createState() => _CertificationsScreenState();
}

class _CertificationsScreenState extends ConsumerState<CertificationsScreen> {
  // Local list to enable immediate UI feedback and mock additions
  final List<Map<String, dynamic>> _localCerts = [
    {
      'id': 1,
      'title': 'Gada Pratama (Kualifikasi Dasar)',
      'issuer': 'Polda Metro Jaya • Basic Security Training',
      'number': 'GP-2022-09881',
      'issued': 'Jan 2022',
      'validUntil': 'Jan 2025',
      'isVerified': true,
    },
    {
      'id': 2,
      'title': 'K3 Umum (Keselamatan Kerja)',
      'issuer': 'BNSP • Keselamatan dan Kesehatan Kerja',
      'number': 'K3-BNSP-4412',
      'issued': 'Mar 2021',
      'validUntil': 'Mar 2024',
      'isVerified': true,
    },
    {
      'id': 3,
      'title': 'First Aid & Tanggap Darurat',
      'issuer': 'Palang Merah Indonesia (PMI)',
      'number': 'FA-PMI-8890',
      'issued': 'Jun 2022',
      'validUntil': 'Seumur Hidup',
      'isVerified': false,
    },
  ];

  void _showAddCertModal() {
    String selectedType = 'Gada Pratama (Kualifikasi Dasar)';
    String issuerOrg = 'Polda Metro Jaya / Mabes Polri';
    final numberController = TextEditingController(text: 'GP-${DateTime.now().year}-${DateTime.now().millisecond}');
    final yearController = TextEditingController(text: '${DateTime.now().year}');

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
                    'Tambah Sertifikasi Satpam',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B2A72),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Jenis Sertifikasi
                  const Text('Jenis Sertifikasi / Ijazah', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
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
                          DropdownMenuItem(value: 'Gada Pratama (Kualifikasi Dasar)', child: Text('Gada Pratama (Kualifikasi Dasar)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'Gada Madya (Supervisor/Danru)', child: Text('Gada Madya (Supervisor/Danru)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'Gada Utama (Chief/Manager)', child: Text('Gada Utama (Chief/Manager)', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'KTA Satpam Polri Aktif', child: Text('KTA Satpam Polri Aktif', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'K3 Umum / Keselamatan Gedung', child: Text('K3 Umum / Keselamatan Gedung', style: TextStyle(fontSize: 13))),
                          DropdownMenuItem(value: 'Pemadam Kebakaran (Damkar Kelas D)', child: Text('Pemadam Kebakaran (Damkar Kelas D)', style: TextStyle(fontSize: 13))),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              selectedType = val;
                              if (val.contains('Gada')) {
                                issuerOrg = 'Polda Metro Jaya / Mabes Polri';
                              } else if (val.contains('K3')) {
                                issuerOrg = 'BNSP / Kemnaker RI';
                              } else {
                                issuerOrg = 'Instansi Penerbit Resmi';
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Nomor Sertifikat
                  const Text('Nomor Sertifikat / Ijazah', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: numberController,
                    decoration: InputDecoration(
                      hintText: 'Contoh: GP-2024-XXXX',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tahun Terbit
                  const Text('Tahun / Tanggal Terbit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Contoh: 2024',
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFCBD5E1))),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tombol Simpan
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
                        final newCert = {
                          'id': DateTime.now().millisecondsSinceEpoch,
                          'title': selectedType,
                          'issuer': issuerOrg,
                          'number': numberController.text.trim(),
                          'issued': yearController.text.trim(),
                          'validUntil': 'Aktif',
                          'isVerified': false,
                        };

                        setState(() {
                          _localCerts.insert(0, newCert);
                        });

                        try {
                          await ref.read(candidateRepositoryProvider).addCertification(
                            certificationId: 1,
                            certificateNumber: numberController.text.trim(),
                            issuedAt: '${yearController.text.trim()}-01-01',
                          );
                          ref.invalidate(candidateCertificationsProvider);
                          ref.invalidate(candidateFullProfileProvider);
                        } catch (_) {}

                        if (ctx.mounted) Navigator.pop(ctx);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Sertifikasi berhasil ditambahkan & diajukan verifikasi!'),
                              backgroundColor: Color(0xFF16A34A),
                            ),
                          );
                        }
                      },
                      child: const Text('Simpan Sertifikasi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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

  void _deleteCert(int id, String title) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Sertifikat?'),
        content: Text('Apakah Anda yakin ingin menghapus sertifikat $title?'),
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
        _localCerts.removeWhere((c) => c['id'] == id);
      });
      try {
        await ref.read(candidateRepositoryProvider).deleteCertification(id);
        ref.invalidate(candidateCertificationsProvider);
        ref.invalidate(candidateFullProfileProvider);
      } catch (_) {}

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sertifikat berhasil dihapus.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).user;
    final verifiedCount = _localCerts.where((c) => c['isVerified'] == true).length;
    final pendingCount = _localCerts.length - verifiedCount;

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
                  onPressed: _showAddCertModal,
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
                    Text(
                      _localCerts.isNotEmpty ? '${((verifiedCount / _localCerts.length) * 100).toInt()}% Verified' : '0% Complete',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Color(0xFF16A34A)),
                        const SizedBox(width: 8),
                        const Text('Verified', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                        const Spacer(),
                        Text('$verifiedCount', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.pending, size: 16, color: Color(0xFFD97706)),
                        const SizedBox(width: 8),
                        const Text('Pending Verification', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                        const Spacer(),
                        Text('$pendingCount', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 12),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
              if (_localCerts.isEmpty)
                const EmptyStateWidget(
                  title: 'Belum Ada Sertifikasi',
                  message: 'Klik tombol di atas untuk menambahkan ijazah Gada Pratama atau sertifikasi lainnya.',
                  icon: Icons.card_membership_outlined,
                )
              else
                ..._localCerts.map((cert) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCertCard(
                      id: cert['id'] as int,
                      title: cert['title'] as String,
                      issuer: cert['issuer'] as String,
                      number: cert['number'] as String?,
                      issued: cert['issued'] as String,
                      validUntil: cert['validUntil'] as String,
                      isVerified: cert['isVerified'] as bool,
                    ),
                  );
                }),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertCard({
    required int id,
    required String title,
    required String issuer,
    String? number,
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
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B2A72),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                                    isVerified ? 'Verified' : 'Pending',
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
                        const SizedBox(height: 3),
                        Text(
                          issuer,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                        ),
                        if (number != null && number.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text(
                            'No: $number',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Issued: $issued  •  Expires: $validUntil',
                    style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 18, color: Color(0xFFEF4444)),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Hapus Sertifikat',
                    onPressed: () => _deleteCert(id, title),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
