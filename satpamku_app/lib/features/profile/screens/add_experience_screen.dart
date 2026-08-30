import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/candidate_profile_provider.dart';

class AddExperienceScreen extends ConsumerStatefulWidget {
  const AddExperienceScreen({super.key});

  @override
  ConsumerState<AddExperienceScreen> createState() => _AddExperienceScreenState();
}

class _AddExperienceScreenState extends ConsumerState<AddExperienceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _positionController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isCurrent = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(candidateRepositoryProvider);
      await repo.addExperience(
        companyName: _companyController.text.trim(),
        positionTitle: _positionController.text.trim(),
        startDate: _startDateController.text.trim(),
        endDate: _isCurrent ? null : _endDateController.text.trim(),
        isCurrent: _isCurrent,
        description: _descriptionController.text.trim(),
      );

      ref.invalidate(candidateFullProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengalaman kerja berhasil ditambahkan!')),
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
      appBar: AppBar(title: const Text('Tambah Pengalaman Kerja')),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreen,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: 'Nama Perusahaan / BUJP / Lokasi Tugas',
                hint: 'Contoh: PT Bravo Security Indonesia / Mall Grand Indonesia',
                controller: _companyController,
                validator: (val) => val == null || val.trim().isEmpty ? 'Nama perusahaan wajib diisi.' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Posisi / Jabatan Pengamanan',
                hint: 'Contoh: Anggota Regu Satpam / Danru Security',
                controller: _positionController,
                validator: (val) => val == null || val.trim().isEmpty ? 'Posisi jabatan wajib diisi.' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Tanggal Mulai (YYYY-MM-DD)',
                      hint: '2023-01-01',
                      controller: _startDateController,
                      validator: (val) => val == null || val.trim().isEmpty ? 'Wajib diisi.' : null,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Tanggal Berakhir',
                      hint: '2024-01-01',
                      controller: _endDateController,
                      readOnly: _isCurrent,
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                title: const Text('Saya masih bertugas di sini saat ini'),
                value: _isCurrent,
                onChanged: (v) => setState(() => _isCurrent = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Deskripsi Tugas & Tanggung Jawab',
                hint: 'Pengawasan area lobi, patroli perimeter gedung, pemeriksaan tamu, penanganan CCTV...',
                controller: _descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: 'Simpan Pengalaman Kerja',
                isLoading: _isLoading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
