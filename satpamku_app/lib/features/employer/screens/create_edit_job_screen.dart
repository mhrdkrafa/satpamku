import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
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
  final _heightMinController = TextEditingController();
  final _weightMinController = TextEditingController();
  final _placementAddressController = TextEditingController();

  String _shiftType = '2_shift';
  String _certificateLevel = 'gada_pratama';
  int _categoryId = 1;
  int _locationId = 1;
  bool _salaryIsHidden = false;
  bool _requiresSim = false;
  bool _isUrgent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _salaryMinController.dispose();
    _salaryMaxController.dispose();
    _heightMinController.dispose();
    _weightMinController.dispose();
    _placementAddressController.dispose();
    super.dispose();
  }

  Future<void> _submit(String submitStatus) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(employerRepositoryProvider);
      final payload = {
        'category_id': _categoryId,
        'location_id': _locationId,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'requirements': _requirementsController.text.trim(),
        'placement_address': _placementAddressController.text.trim(),
        'shift_type': _shiftType,
        'salary_min': int.tryParse(_salaryMinController.text),
        'salary_max': int.tryParse(_salaryMaxController.text),
        'salary_is_hidden': _salaryIsHidden,
        'min_height_cm': int.tryParse(_heightMinController.text),
        'min_weight_kg': int.tryParse(_weightMinController.text),
        'required_certificate_level': _certificateLevel,
        'requires_sim': _requiresSim,
        'is_urgent': _isUrgent,
        'status': submitStatus,
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
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        title: Text(widget.jobId != null ? 'Edit Lowongan' : 'Pasang Lowongan Satpam'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreen,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Judul Lowongan Pekerjaan',
                hint: 'Contoh: Satpam Gedung Perkantoran Sudirman',
                controller: _titleController,
                validator: (val) => val == null || val.trim().isEmpty ? 'Judul lowongan wajib diisi.' : null,
              ),
              const SizedBox(height: AppSpacing.md),

              // Sektor & Lokasi Dropdown
              Text('Kualifikasi Sertifikasi Wajib', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String>(
                value: _certificateLevel,
                items: const [
                  DropdownMenuItem(value: 'none', child: Text('Non-Sertifikasi (Umum)')),
                  DropdownMenuItem(value: 'gada_pratama', child: Text('Wajib Gada Pratama')),
                  DropdownMenuItem(value: 'gada_madya', child: Text('Wajib Gada Madya (Supervisor/Danru)')),
                  DropdownMenuItem(value: 'gada_utama', child: Text('Wajib Gada Utama (Chief/Manager)')),
                ],
                onChanged: (val) => setState(() => _certificateLevel = val ?? 'gada_pratama'),
              ),
              const SizedBox(height: AppSpacing.md),

              Text('Sistem Jam Kerja / Shift', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: AppSpacing.xs),
              DropdownButtonFormField<String>(
                value: _shiftType,
                items: const [
                  DropdownMenuItem(value: '2_shift', child: Text('2 Shift (12 Jam Kerja)')),
                  DropdownMenuItem(value: '3_shift', child: Text('3 Shift (8 Jam Kerja)')),
                  DropdownMenuItem(value: 'full_time', child: Text('Penuh Waktu (Non-Shift)')),
                  DropdownMenuItem(value: 'event', child: Text('Event / Pengamanan Acara')),
                ],
                onChanged: (val) => setState(() => _shiftType = val ?? '2_shift'),
              ),
              const SizedBox(height: AppSpacing.md),

              // Gaji
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Gaji Min (Rp)',
                      hint: '5000000',
                      controller: _salaryMinController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Gaji Max (Rp)',
                      hint: '6500000',
                      controller: _salaryMaxController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sembunyikan nominal gaji (Negosiasi)'),
                value: _salaryIsHidden,
                onChanged: (v) => setState(() => _salaryIsHidden = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: AppSpacing.md),

              // Syarat Fisik
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Tinggi Min (cm)',
                      hint: '168',
                      controller: _heightMinController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Berat Min (kg)',
                      hint: '60',
                      controller: _weightMinController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Wajib memiliki SIM aktif'),
                value: _requiresSim,
                onChanged: (v) => setState(() => _requiresSim = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Tandai sebagai Urgent Hiring (Kebutuhan Cepat)'),
                value: _isUrgent,
                onChanged: (v) => setState(() => _isUrgent = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Deskripsi Tugas & Tanggung Jawab',
                hint: 'Rincian tugas patroli, kontrol akses, penanganan lobi...',
                controller: _descriptionController,
                maxLines: 4,
                validator: (val) => val == null || val.trim().isEmpty ? 'Deskripsi pekerjaan wajib diisi.' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Alamat / Area Penempatan Proyek',
                hint: 'Jl. Jenderal Sudirman Kav. 21, Jakarta Selatan',
                controller: _placementAddressController,
              ),
              const SizedBox(height: AppSpacing.xl),

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: 'Simpan Draft',
                      variant: AppButtonVariant.outline,
                      isLoading: _isLoading,
                      onPressed: () => _submit('draft'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppButton(
                      text: 'Publikasikan',
                      isLoading: _isLoading,
                      onPressed: () => _submit('published'),
                    ),
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
