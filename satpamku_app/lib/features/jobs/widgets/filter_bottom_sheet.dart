import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../providers/jobs_provider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  String? _selectedShift;
  String? _selectedCertLevel;
  bool _isUrgent = false;
  String _selectedSort = 'newest';

  @override
  void initState() {
    super.initState();
    final filter = ref.read(jobFilterProvider);
    _selectedShift = filter.shiftType;
    _selectedCertLevel = filter.certificateLevel;
    _isUrgent = filter.isUrgent ?? false;
    _selectedSort = filter.sort;
  }

  void _applyFilter() {
    ref.read(jobFilterProvider.notifier).update((state) => state.copyWith(
          shiftType: _selectedShift,
          certificateLevel: _selectedCertLevel,
          isUrgent: _isUrgent ? true : null,
          sort: _selectedSort,
          clearShift: _selectedShift == null,
          clearCertificate: _selectedCertLevel == null,
          clearUrgent: !_isUrgent,
        ));
    Navigator.pop(context);
  }

  void _resetFilter() {
    ref.read(jobFilterProvider.notifier).update((state) => const JobFilterCriteria());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Lowongan Satpam',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: _resetFilter,
                    child: const Text('Reset', style: TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
              const Divider(height: AppSpacing.lg),

              // Urutkan (Sort)
              Text('Urutkan Berdasarkan', style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildChoiceChip('Terbaru', 'newest', _selectedSort, (val) => setState(() => _selectedSort = val)),
                  _buildChoiceChip('Gaji Tertinggi', 'salary_desc', _selectedSort, (val) => setState(() => _selectedSort = val)),
                  _buildChoiceChip('Paling Mendesak', 'urgent', _selectedSort, (val) => setState(() => _selectedSort = val)),
                  _buildChoiceChip('Paling Banyak Dilihat', 'popular', _selectedSort, (val) => setState(() => _selectedSort = val)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tingkat Sertifikasi
              Text('Kualifikasi Sertifikat Gada', style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildChoiceChip('Semua Kualifikasi', null, _selectedCertLevel, (val) => setState(() => _selectedCertLevel = val)),
                  _buildChoiceChip('Gada Pratama', 'gada_pratama', _selectedCertLevel, (val) => setState(() => _selectedCertLevel = val)),
                  _buildChoiceChip('Gada Madya', 'gada_madya', _selectedCertLevel, (val) => setState(() => _selectedCertLevel = val)),
                  _buildChoiceChip('Gada Utama', 'gada_utama', _selectedCertLevel, (val) => setState(() => _selectedCertLevel = val)),
                  _buildChoiceChip('Non-Sertifikat', 'none', _selectedCertLevel, (val) => setState(() => _selectedCertLevel = val)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tipe Shift
              Text('Tipe Jam Kerja / Shift', style: theme.textTheme.labelLarge),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildChoiceChip('Semua Shift', null, _selectedShift, (val) => setState(() => _selectedShift = val)),
                  _buildChoiceChip('2 Shift (12 Jam)', '2_shift', _selectedShift, (val) => setState(() => _selectedShift = val)),
                  _buildChoiceChip('3 Shift (8 Jam)', '3_shift', _selectedShift, (val) => setState(() => _selectedShift = val)),
                  _buildChoiceChip('Penuh Waktu', 'full_time', _selectedShift, (val) => setState(() => _selectedShift = val)),
                  _buildChoiceChip('Event / Acara', 'event', _selectedShift, (val) => setState(() => _selectedShift = val)),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),

              // Urgent Switch
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Hanya Tampilkan Urgent Hiring', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: const Text('Lowongan yang membutuhkan personil segera'),
                value: _isUrgent,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _isUrgent = val),
              ),
              const SizedBox(height: AppSpacing.xl),

              AppButton(
                text: 'Terapkan Filter',
                onPressed: _applyFilter,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label, String? value, String? groupValue, ValueChanged<String?> onSelected) {
    final isSelected = value == groupValue;

    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onSelected(value),
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.lightSurfaceVariant,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.lightTextPrimary,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
        fontSize: 12,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.roundedFull,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.lightBorder,
        ),
      ),
    );
  }
}
