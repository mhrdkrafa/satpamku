import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';

class ScheduleInterviewDialog extends StatefulWidget {
  final String candidateName;

  const ScheduleInterviewDialog({super.key, required this.candidateName});

  @override
  State<ScheduleInterviewDialog> createState() => _ScheduleInterviewDialogState();
}

class _ScheduleInterviewDialogState extends State<ScheduleInterviewDialog> {
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2, hours: 9));

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd HH:mm').format(_selectedDate);
    _locationController.text = 'Kantor Operasional BUJP / Lokasi Penempatan Proyek';
    _notesController.text = 'Harap membawa KTA asli, Ijazah Gada Pratama/Madya, dan pakaian dinas PDH/PDL rapi.';
  }

  @override
  void dispose() {
    _dateController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: AppSpacing.roundedLg),
      title: Text('Jadwalkan Interview — ${widget.candidateName}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: 'Waktu Interview (YYYY-MM-DD HH:MM)',
              hint: '2026-09-02 09:00',
              controller: _dateController,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Lokasi Interview / Link Online',
              hint: 'Alamat kantor atau link Google Meet',
              controller: _locationController,
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              label: 'Instruksi / Catatan untuk Kandidat',
              hint: 'KTA asli, seragam, berkas...',
              controller: _notesController,
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'interview_at': DateTime.tryParse(_dateController.text.trim()) ?? _selectedDate,
              'interview_location': _locationController.text.trim(),
              'employer_notes': _notesController.text.trim(),
            });
          },
          child: const Text('Kirim Jadwal'),
        ),
      ],
    );
  }
}
