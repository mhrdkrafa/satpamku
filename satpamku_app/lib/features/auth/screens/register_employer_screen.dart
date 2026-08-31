import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';

class RegisterEmployerScreen extends ConsumerStatefulWidget {
  const RegisterEmployerScreen({super.key});

  @override
  ConsumerState<RegisterEmployerScreen> createState() => _RegisterEmployerScreenState();
}

class _RegisterEmployerScreenState extends ConsumerState<RegisterEmployerScreen> {
  final _formKey = GlobalKey<FormState>();

  // Company Information
  final _companyNameController = TextEditingController();
  final _industryController = TextEditingController(text: 'Badan Usaha Jasa Pengamanan (BUJP)');
  final _addressController = TextEditingController();

  // PIC & Account
  final _picNameController = TextEditingController();
  final _picPhoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _uploadedLegalDoc;
  bool _termsAgreed = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _companyNameController.dispose();
    _industryController.dispose();
    _addressController.dispose();
    _picNameController.dispose();
    _picPhoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap menyetujui Syarat & Ketentuan serta Kebijakan Privasi Satpamku.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    final success = await ref.read(authProvider.notifier).registerEmployer(
          name: _picNameController.text.trim(),
          companyName: _companyNameController.text.trim(),
          email: _emailController.text.trim(),
          phone: _picPhoneController.text.trim(),
          password: _passwordController.text,
          passwordConfirmation: _passwordController.text,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pendaftaran Perusahaan BUJP berhasil!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/employer/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B2A72)),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF1B2A72),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.shield, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
            const Text(
              'Satpamku',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B2A72),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Hubungi Layanan Bantuan: support@satpamku.id')),
              );
            },
            child: const Text(
              'Bantuan',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 480),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1B2A72).withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
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
                      'Daftar Perusahaan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Buat akun untuk mulai mencari dan merekrut tenaga pengamanan profesional yang terverifikasi.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),

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

                    // SECTION 1: Informasi Perusahaan
                    const Row(
                      children: [
                        Icon(Icons.business, size: 18, color: Color(0xFF1B2A72)),
                        SizedBox(width: 8),
                        Text(
                          'Informasi Perusahaan',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Nama Perusahaan *'),
                    TextFormField(
                      controller: _companyNameController,
                      decoration: _inputDecoration(hint: 'PT. Keamanan Abadi'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Nama perusahaan wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Bidang Industri *'),
                    DropdownButtonFormField<String>(
                      value: _industryController.text,
                      decoration: _inputDecoration(hint: 'Pilih Industri'),
                      items: const [
                        DropdownMenuItem(
                          value: 'Badan Usaha Jasa Pengamanan (BUJP)',
                          child: Text('Badan Usaha Jasa Pengamanan (BUJP)'),
                        ),
                        DropdownMenuItem(value: 'Perbankan & Keuangan', child: Text('Perbankan & Keuangan')),
                        DropdownMenuItem(value: 'Mall & Pusat Perbelanjaan', child: Text('Mall & Pusat Perbelanjaan')),
                        DropdownMenuItem(value: 'Properti & Apartemen', child: Text('Properti & Apartemen')),
                        DropdownMenuItem(value: 'Manufaktur & Pabrik', child: Text('Manufaktur & Pabrik')),
                        DropdownMenuItem(value: 'Lainnya', child: Text('Lainnya')),
                      ],
                      onChanged: (val) => setState(() => _industryController.text = val ?? ''),
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Alamat Kantor Lengkap *'),
                    TextFormField(
                      controller: _addressController,
                      maxLines: 2,
                      decoration: _inputDecoration(hint: 'Jl. Sudirman No. 123, Jakarta Selatan...'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Alamat kantor wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),

                    const Divider(color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 14),

                    // SECTION 2: PIC & Akun
                    const Row(
                      children: [
                        Icon(Icons.person_outline, size: 18, color: Color(0xFF1B2A72)),
                        SizedBox(width: 8),
                        Text(
                          'Penanggung Jawab (PIC) & Akun',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Nama PIC *'),
                    TextFormField(
                      controller: _picNameController,
                      decoration: _inputDecoration(hint: 'Budi Santoso'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Nama PIC wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Nomor Telepon PIC *'),
                    TextFormField(
                      controller: _picPhoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(hint: '08123456789'),
                      validator: (v) => v == null || v.trim().isEmpty ? 'Nomor telepon PIC wajib diisi' : null,
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Email Perusahaan *'),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputDecoration(hint: 'hrd@perusahaan.com'),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
                        if (!v.contains('@')) return 'Format email tidak valid';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildFieldLabel('Kata Sandi *'),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration(hint: '••••••••').copyWith(
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
                    const SizedBox(height: 20),

                    const Divider(color: Color(0xFFE2E8F0)),
                    const SizedBox(height: 14),

                    // SECTION 3: Verifikasi Legalitas
                    const Row(
                      children: [
                        Icon(Icons.description_outlined, size: 18, color: Color(0xFF1B2A72)),
                        SizedBox(width: 8),
                        Text(
                          'Verifikasi Legalitas',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Unggah SIUP, NIB, atau dokumen legalitas perusahaan lainnya untuk proses verifikasi. Maks 5MB (PDF/JPG).',
                      style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.35),
                    ),
                    const SizedBox(height: 10),

                    InkWell(
                      onTap: () {
                        setState(() {
                          _uploadedLegalDoc = 'SIUP_NIB_PT_Keamanan.pdf';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('File SIUP_NIB_PT_Keamanan.pdf berhasil dipilih.')),
                        );
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
                              _uploadedLegalDoc != null ? _uploadedLegalDoc! : 'Pilih File atau Tarik ke Sini',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _uploadedLegalDoc != null ? AppColors.success : const Color(0xFF1B2A72),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _uploadedLegalDoc != null ? 'Dokumen Siap Diunggah' : 'Belum ada file yang dipilih',
                              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Terms Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _termsAgreed,
                          activeColor: const Color(0xFF1B2A72),
                          onChanged: (v) => setState(() => _termsAgreed = v ?? false),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text.rich(
                              TextSpan(
                                text: 'Saya menyetujui ',
                                style: TextStyle(fontSize: 11.5, color: Color(0xFF4A5568)),
                                children: [
                                  TextSpan(
                                    text: 'Syarat & Ketentuan',
                                    style: TextStyle(
                                      color: Color(0xFF1B2A72),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: ' serta '),
                                  TextSpan(
                                    text: 'Kebijakan Privasi',
                                    style: TextStyle(
                                      color: Color(0xFF1B2A72),
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: ' Satpamku.'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                            : const Text(
                                'Daftar Perusahaan',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),

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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF1B2A72), width: 1.5),
      ),
    );
  }
}
