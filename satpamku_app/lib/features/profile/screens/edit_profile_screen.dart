import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../providers/candidate_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _headlineController = TextEditingController();
  final _summaryController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  bool _hasSimA = false;
  bool _hasSimB1 = false;
  bool _hasSimC = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final profileAsync = ref.read(candidateFullProfileProvider);
    profileAsync.whenData((profile) {
      _headlineController.text = profile.headline ?? '';
      _summaryController.text = profile.summary ?? '';
      _heightController.text = profile.heightCm?.toString() ?? '';
      _weightController.text = profile.weightKg?.toString() ?? '';
      _hasSimA = profile.hasSimA;
      _hasSimB1 = profile.hasSimB1;
      _hasSimC = profile.hasSimC;
    });
  }

  @override
  void dispose() {
    _headlineController.dispose();
    _summaryController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(candidateRepositoryProvider);
      await repo.updateProfile(
        headline: _headlineController.text.trim(),
        summary: _summaryController.text.trim(),
        heightCm: int.tryParse(_heightController.text),
        weightKg: int.tryParse(_weightController.text),
        hasSimA: _hasSimA,
        hasSimB1: _hasSimB1,
        hasSimC: _hasSimC,
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
      appBar: AppBar(title: const Text('Edit Data Diri & Fisik')),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Headline Singkat Profil',
              hint: 'Contoh: Satpam Gada Pratama berpengalaman 3 tahun perbankan',
              controller: _headlineController,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Ringkasan Diri / Bio',
              hint: 'Ceritakan latar belakang disiplin, integritas, dan keahlian bela diri/pengamanan Anda...',
              controller: _summaryController,
              maxLines: 4,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: 'Tinggi Badan (cm)',
                    hint: '172',
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppTextField(
                    label: 'Berat Badan (kg)',
                    hint: '68',
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Kepemilikan Surat Izin Mengemudi (SIM):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            CheckboxListTile(
              title: const Text('SIM A (Mobil Pribadi)'),
              value: _hasSimA,
              onChanged: (v) => setState(() => _hasSimA = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('SIM B1 / B2 (Kendaraan Berat/Operasional)'),
              value: _hasSimB1,
              onChanged: (v) => setState(() => _hasSimB1 = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            CheckboxListTile(
              title: const Text('SIM C (Sepeda Motor)'),
              value: _hasSimC,
              onChanged: (v) => setState(() => _hasSimC = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              text: 'Simpan Perubahan',
              isLoading: _isLoading,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
