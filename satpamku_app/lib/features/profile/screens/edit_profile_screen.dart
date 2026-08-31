import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/candidate_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _salaryController = TextEditingController(text: '5500000');
  String _preferredLocation = 'Jakarta Selatan';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authStateProvider).user;
    final profileAsync = ref.read(candidateFullProfileProvider);

    _nameController.text = user?.name ?? 'Budi Santoso';
    _phoneController.text = user?.phone ?? '+62 812-3456-7890';

    profileAsync.whenData((profile) {
      if (profile.summary != null && profile.summary!.isNotEmpty) {
        _bioController.text = profile.summary!;
      } else {
        _bioController.text = 'Experienced security professional with 5+ years in corporate access control and emergency response.';
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(candidateRepositoryProvider);
      await repo.updateProfile(
        headline: _bioController.text.trim().split('.').first,
        summary: _bioController.text.trim(),
      );

      ref.invalidate(candidateFullProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: const Color(0xFFEF4444)),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B2A72)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2A72),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar Photo Change Section
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: user?.avatarUrl != null && user!.avatarUrl!.isNotEmpty
                              ? Image.network(
                                  user.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Center(
                                    child: Icon(Icons.person, size: 50, color: Color(0xFF64748B)),
                                  ),
                                )
                              : const Center(
                                  child: Icon(Icons.person, size: 50, color: Color(0xFF64748B)),
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pilih foto dari Galeri / Kamera')),
                            );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B2A72),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to change photo',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SECTION 1: Personal Information
            const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2A72),
              ),
            ),
            const SizedBox(height: 4),
            const Divider(height: 1, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 14),

            _buildInputField(
              label: 'Full Name',
              controller: _nameController,
            ),
            const SizedBox(height: 14),

            _buildInputField(
              label: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),

            // Professional Bio
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Professional Bio',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: TextField(
                    controller: _bioController,
                    maxLines: 4,
                    maxLength: 200,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                      counterStyle: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // SECTION 2: Job Preferences
            const Text(
              'Job Preferences',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2A72),
              ),
            ),
            const SizedBox(height: 4),
            const Divider(height: 1, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 14),

            // Preferred Location Dropdown
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Preferred Location',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                ),
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
                      value: _preferredLocation,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
                      items: ['Jakarta Selatan', 'Jakarta Pusat', 'Jakarta Barat', 'Jakarta Utara', 'Jakarta Timur', 'Bekasi & Cikarang', 'Tangerang', 'Surabaya']
                          .map((loc) => DropdownMenuItem(value: loc, child: Text(loc, style: const TextStyle(fontSize: 13))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _preferredLocation = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            _buildInputField(
              label: 'Salary Expectation (IDR / month)',
              controller: _salaryController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            ),
          ),
        ),
      ],
    );
  }
}
