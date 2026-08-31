import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../providers/employer_provider.dart';

class CreateEditJobScreen extends ConsumerStatefulWidget {
  final int? jobId;

  const CreateEditJobScreen({super.key, this.jobId});

  @override
  ConsumerState<CreateEditJobScreen> createState() => _CreateEditJobScreenState();
}

class _CreateEditJobScreenState extends ConsumerState<CreateEditJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _salaryMinController = TextEditingController();
  final _salaryMaxController = TextEditingController();

  String _category = 'Retail Security';
  String _shiftType = '2 Shift (12 Jam)';
  String _requiredCert = 'Gada Pratama (Basic)';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(employerRepositoryProvider);
      final payload = {
        'category_id': 1,
        'location_id': 1,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : 'Bertanggung jawab atas pengamanan perimeter, patroli berkala, dan penegakan SOP keamanan.',
        'requirements': _requirementsController.text.trim().isNotEmpty
            ? _requirementsController.text.trim()
            : 'Minimal pengalaman 1 tahun di bidang pengamanan korporat/retail.',
        'shift_type': _shiftType.toLowerCase().contains('3') ? '3_shift' : '2_shift',
        'salary_min': int.tryParse(_salaryMinController.text) ?? 5000000,
        'salary_max': int.tryParse(_salaryMaxController.text) ?? 7000000,
        'required_certificate_level': _requiredCert.toLowerCase().contains('madya')
            ? 'gada_madya'
            : _requiredCert.toLowerCase().contains('utama')
                ? 'gada_utama'
                : 'gada_pratama',
        'status': 'published',
      };

      if (widget.jobId != null) {
        await repo.updateJob(widget.jobId!, payload);
      } else {
        await repo.createJob(payload);
      }

      ref.invalidate(employerJobsProvider);
      ref.invalidate(employerDashboardProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.jobId != null ? 'Lowongan berhasil diperbarui!' : 'Lowongan berhasil dipublikasikan!')),
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
          'Satpamku',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B2A72),
          ),
        ),
        centerTitle: false,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Color(0xFF1B2A72), size: 24),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
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
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B2A72),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text(
                      'Publish Job Post',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title & Subtitle
              const Text(
                'Post a New Job',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B2A72),
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Create a detailed listing to attract the best security personnel.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              // SECTION 1: Basic Information
              const Text(
                'Basic Information',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
              ),
              const SizedBox(height: 4),
              const Divider(height: 1, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 14),

              _buildFieldLabel('Job Title *'),
              _buildTextInput(
                controller: _titleController,
                hintText: 'e.g., Senior Security Officer, Retail Guard',
                validator: (v) => v == null || v.trim().isEmpty ? 'Judul lowongan wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              _buildFieldLabel('Category *'),
              _buildDropdown(
                value: _category,
                items: ['Retail Security', 'Residential Guard', 'VIP Protection', 'Event Security', 'Industrial Security'],
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 14),

              _buildFieldLabel('Shift Type *'),
              _buildDropdown(
                value: _shiftType,
                items: ['2 Shift (12 Jam)', '3 Shift (8 Jam)', 'Morning Shift', 'Night Shift', 'Rotating Shift'],
                onChanged: (val) => setState(() => _shiftType = val!),
              ),
              const SizedBox(height: 24),

              // SECTION 2: Compensation & Requirements
              const Text(
                'Compensation & Requirements',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
              ),
              const SizedBox(height: 4),
              const Divider(height: 1, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 14),

              _buildFieldLabel('Monthly Salary Range (IDR) *'),
              Row(
                children: [
                  Expanded(
                    child: _buildSalaryBox('Rp  Min', _salaryMinController),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('-', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                  ),
                  Expanded(
                    child: _buildSalaryBox('Rp  Max', _salaryMaxController),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildFieldLabel('Required Certification *'),
              _buildRadioOption('Gada Pratama (Basic)'),
              _buildRadioOption('Gada Madya (Supervisor)'),
              _buildRadioOption('Gada Utama (Manager)'),
              const SizedBox(height: 24),

              // SECTION 3: Job Details
              const Text(
                'Job Details',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72)),
              ),
              const SizedBox(height: 4),
              const Divider(height: 1, color: Color(0xFFCBD5E1)),
              const SizedBox(height: 14),

              _buildFieldLabel('Job Description'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Tuliskan deskripsi tugas dan tanggung jawab penugasan...',
                    hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _buildFieldLabel('Requirements & Kualifikasi'),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFCBD5E1)),
                ),
                child: TextField(
                  controller: _requirementsController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Contoh: Tinggi min 168cm, tidak bertato, SKCK aktif...',
                    hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
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
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String hintText,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF64748B)),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSalaryBox(String hint, TextEditingController controller) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label) {
    final isSelected = _requiredCert == label;
    return InkWell(
      onTap: () => setState(() => _requiredCert = label),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFF94A3B8),
                  width: isSelected ? 6 : 1.5,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
