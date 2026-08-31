import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nikController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedCertLevel = 'gada_pratama';
  String? _uploadedFileName;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _nikController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final phone = _phoneController.text.trim();
    // Auto-generate email alias if only phone is used for simpler registration
    final generatedEmail = '${phone.replaceAll(RegExp(r'[^0-9]'), '')}@satpamku.id';

    final success = await ref.read(authProvider.notifier).registerCandidate(
          name: _nameController.text.trim(),
          email: generatedEmail,
          phone: phone,
          password: _passwordController.text,
          passwordConfirmation: _passwordController.text,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran akun Satpam berhasil!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B2A72)),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B2A72).withOpacity(0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header
                    const Text(
                      'Satpamku',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Buat Akun Profesional',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Daftar sekarang untuk bergabung dengan jaringan keamanan terpercaya di Indonesia.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (authState.error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Text(
                          authState.error!,
                          style: const TextStyle(color: Color(0xFFB91C1C), fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Field 1: Nama Lengkap
                    const Text(
                      'Nama Lengkap (Sesuai KTP)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        hint: 'Masukkan nama lengkap',
                        icon: Icons.person_outline,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Nama lengkap wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),

                    // Field 2: NIK
                    const Text(
                      'Nomor Induk Kependudukan (NIK)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      maxLength: 16,
                      decoration: _inputDecoration(
                        hint: '16 Digit NIK Anda',
                        icon: Icons.badge_outlined,
                      ).copyWith(counterText: ''),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'NIK wajib diisi';
                        if (v.trim().length != 16) return 'NIK harus 16 digit angka';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Field 3: Nomor Telepon
                    const Text(
                      'Nomor Telepon (WhatsApp Aktif)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        hint: 'Contoh: 081234567890',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Nomor telepon wajib diisi' : null,
                    ),
                    const SizedBox(height: 14),

                    // Field 4: Tingkat Sertifikasi Dropdown
                    const Text(
                      'Tingkat Sertifikasi',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedCertLevel,
                      decoration: _inputDecoration(hint: 'Pilih Tingkat Sertifikasi'),
                      items: const [
                        DropdownMenuItem(value: 'gada_pratama', child: Text('Gada Pratama (Dasar)')),
                        DropdownMenuItem(value: 'gada_madya', child: Text('Gada Madya (Supervisor / Danru)')),
                        DropdownMenuItem(value: 'gada_utama', child: Text('Gada Utama (Chief / Manager)')),
                        DropdownMenuItem(value: 'none', child: Text('Non-Sertifikasi (Baru / Belum Pelatihan)')),
                      ],
                      onChanged: (val) => setState(() => _selectedCertLevel = val ?? 'gada_pratama'),
                    ),
                    const SizedBox(height: 14),

                    // Field 5: Upload KTA / Sertifikat (Opsional)
                    const Text(
                      'Upload KTA / Sertifikat (Opsional)',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _uploadedFileName = 'Ijazah_Gada_Pratama.pdf';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File Ijazah_Gada_Pratama.pdf berhasil dipilih.')),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF94A3B8),
                            width: 1.2,
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.cloud_upload_outlined,
                              size: 32,
                              color: Color(0xFF1B2A72),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _uploadedFileName ?? 'Upload file atau drag and drop',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _uploadedFileName != null ? AppColors.success : const Color(0xFF1B2A72),
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'PNG, JPG, PDF up to 5MB',
                              style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Field 6: Kata Sandi
                    const Text(
                      'Kata Sandi',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                    ),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration(
                        hint: 'Minimal 8 karakter',
                        icon: Icons.lock_outline,
                      ).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 20,
                            color: const Color(0xFF64748B),
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Kata sandi wajib diisi';
                        if (v.length < 8) return 'Minimal 8 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 22),

                    // Submit Button
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B2A72),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.person_add_alt_1, size: 18),
                                  SizedBox(width: 8),
                                  Text(
                                    'Daftar Sekarang',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sudah punya akun? ',
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                        ),
                        GestureDetector(
                          onTap: () => context.push('/login'),
                          child: const Text(
                            'Masuk di sini',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B2A72),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
      prefixIcon: icon != null ? Icon(icon, size: 20, color: const Color(0xFF64748B)) : null,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF1B2A72), width: 1.5),
      ),
    );
  }
}
