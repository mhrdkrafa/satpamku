import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/jobs_provider.dart';

class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  RangeValues _salaryRange = const RangeValues(3.0, 8.0);
  String _selectedJobType = 'Full-time';
  String _selectedShift = 'morning';
  final Set<String> _selectedCertifications = {'gada_pratama'};

  @override
  void initState() {
    super.initState();
    final filter = ref.read(jobFilterProvider);
    if (filter.certificateLevel != null) {
      _selectedCertifications.add(filter.certificateLevel!);
    }
    if (filter.shiftType != null) {
      _selectedShift = filter.shiftType!;
    }
  }

  void _applyFilter() {
    ref.read(jobFilterProvider.notifier).update((state) => state.copyWith(
          shiftType: _selectedShift,
          certificateLevel: _selectedCertifications.isNotEmpty ? _selectedCertifications.first : null,
          salaryMin: (_salaryRange.start * 1000000).toInt(),
        ));
    Navigator.pop(context);
  }

  void _resetFilter() {
    ref.read(jobFilterProvider.notifier).update((state) => const JobFilterCriteria());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF1E293B), size: 22),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 14),
                    const Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1B2A72),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: _resetFilter,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Scrollable Filter Sections
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SECTION 1: Salary Range (Monthly)
                  _buildSectionCard(
                    icon: Icons.payments_outlined,
                    title: 'Salary Range (Monthly)',
                    child: Column(
                      children: [
                        RangeSlider(
                          values: _salaryRange,
                          min: 2.0,
                          max: 12.0,
                          divisions: 20,
                          activeColor: const Color(0xFF1B2A72),
                          inactiveColor: const Color(0xFFE2E8F0),
                          onChanged: (values) => setState(() => _salaryRange = values),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildValueBox('Min', 'Rp ${_salaryRange.start.toStringAsFixed(0)}M'),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text('-', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                            ),
                            Expanded(
                              child: _buildValueBox('Max', 'Rp ${_salaryRange.end.toStringAsFixed(0)}M+'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 2: Job Type
                  _buildSectionCard(
                    icon: Icons.work_outline,
                    title: 'Job Type',
                    child: Row(
                      children: [
                        _buildJobTypePill('Full-time'),
                        const SizedBox(width: 8),
                        _buildJobTypePill('Contract'),
                        const SizedBox(width: 8),
                        _buildJobTypePill('Part-time'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 3: Shift Preference
                  _buildSectionCard(
                    icon: Icons.schedule,
                    title: 'Shift Preference',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildShiftCard('morning', 'Morning Shift', Icons.wb_sunny_outlined),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildShiftCard('night', 'Night Shift', Icons.nightlight_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildShiftCard('rotating', 'Rotating (2-Shift)', Icons.sync, isFullWidth: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // SECTION 4: Required Certification
                  _buildSectionCard(
                    icon: Icons.verified_user_outlined,
                    title: 'Required Certification',
                    child: Column(
                      children: [
                        _buildCertCheckbox('gada_pratama', 'Gada Pratama', 'Basic Security Training'),
                        const SizedBox(height: 8),
                        _buildCertCheckbox('gada_madya', 'Gada Madya', 'Supervisory Security Training'),
                        const SizedBox(height: 8),
                        _buildCertCheckbox('gada_utama', 'Gada Utama', 'Management Security Training'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom CTA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _applyFilter,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B2A72),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Show Results',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({required IconData icon, required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1B2A72)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildValueBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1B2A72))),
        ],
      ),
    );
  }

  Widget _buildJobTypePill(String type) {
    final isSelected = _selectedJobType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedJobType = type),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1B2A72) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFFCBD5E1),
            ),
          ),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : const Color(0xFF334155),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShiftCard(String id, String label, IconData icon, {bool isFullWidth = false}) {
    final isSelected = _selectedShift == id;
    return InkWell(
      onTap: () => setState(() => _selectedShift = id),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFFCBD5E1),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFF64748B)),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFF1B2A72) : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertCheckbox(String id, String title, String subtitle) {
    final isChecked = _selectedCertifications.contains(id);
    return InkWell(
      onTap: () {
        setState(() {
          if (isChecked) {
            _selectedCertifications.remove(id);
          } else {
            _selectedCertifications.add(id);
          }
        });
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isChecked ? const Color(0xFF1B2A72) : const Color(0xFFCBD5E1),
            width: isChecked ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isChecked ? const Color(0xFF1B2A72) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isChecked ? const Color(0xFF1B2A72) : const Color(0xFF94A3B8),
                  width: 1.5,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
