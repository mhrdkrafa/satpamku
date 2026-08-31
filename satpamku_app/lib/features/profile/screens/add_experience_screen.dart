import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isCurrent = false;
  bool _isLoading = false;

  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
      helpText: 'PILIH TANGGAL MULAI BERTUGAS',
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        _startDateController.text = _dateFormat.format(picked);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
      firstDate: _startDate ?? DateTime(1980),
      lastDate: DateTime(2030),
      locale: const Locale('id', 'ID'),
      helpText: 'PILIH TANGGAL SELESAI BERTUGAS',
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
        _endDateController.text = _dateFormat.format(picked);
      });
    }
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
          const SnackBar(
            content: Text('Pengalaman kerja berhasil disimpan!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.error,
          ),
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
                hint: 'Contoh: PT Sigap Prima Astrea / Bank BCA KCU Menteng',
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
                    child: InkWell(
                      onTap: _selectStartDate,
                      child: IgnorePointer(
                        child: AppTextField(
                          label: 'Tanggal Mulai',
                          hint: 'Pilih Tanggal',
                          controller: _startDateController,
                          prefixIcon: const Icon(Icons.calendar_today, size: 18),
                          validator: (val) => val == null || val.trim().isEmpty ? 'Wajib dipilih.' : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _isCurrent
                        ? Container(
                            height: 52,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: AppSpacing.roundedMd,
                              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                            ),
                            child: const Text(
                              'Masih Bertugas',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          )
                        : InkWell(
                            onTap: _selectEndDate,
                            child: IgnorePointer(
                              child: AppTextField(
                                label: 'Tanggal Selesai',
                                hint: 'Pilih Tanggal',
                                controller: _endDateController,
                                prefixIcon: const Icon(Icons.event, size: 18),
                                validator: (val) {
                                  if (!_isCurrent && (val == null || val.trim().isEmpty)) {
                                    return 'Wajib dipilih.';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Saya masih bertugas di posisi ini saat ini'),
                value: _isCurrent,
                onChanged: (v) {
                  setState(() {
                    _isCurrent = v ?? false;
                    if (_isCurrent) {
                      _endDateController.clear();
                      _endDate = null;
                    }
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Deskripsi Tugas & Tanggung Jawab (Opsional)',
                hint: 'Contoh: Melakukan patroli perimeter area perkantoran, kontrol akses pengunjung dan tamu VIP, pengecekan CCTV...',
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
