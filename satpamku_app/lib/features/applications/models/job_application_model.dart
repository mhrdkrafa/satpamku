import '../../jobs/models/job_model.dart';

class JobApplicationModel {
  final int id;
  final String status;
  final DateTime appliedAt;
  final DateTime? interviewAt;
  final String? interviewLocation;
  final String? rejectionReason;
  final String? coverLetter;
  final JobModel job;

  JobApplicationModel({
    required this.id,
    required this.status,
    required this.appliedAt,
    this.interviewAt,
    this.interviewLocation,
    this.rejectionReason,
    this.coverLetter,
    required this.job,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'submitted',
      appliedAt: DateTime.tryParse(json['applied_at'] ?? '') ?? DateTime.now(),
      interviewAt: json['interview_at'] != null ? DateTime.tryParse(json['interview_at']) : null,
      interviewLocation: json['interview_location'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      coverLetter: json['cover_letter'] as String?,
      job: JobModel.fromJson(json['job'] as Map<String, dynamic>),
    );
  }

  String get jobTitle => job.title;
  String get companyName => job.companyName;
  String get jobSlug => job.slug;
  String get locationName => job.locationName;
  String get salaryRange => job.formattedSalary;
  String get shiftType => job.shiftType;

  String get statusDisplay {
    switch (status) {
      case 'submitted':
        return 'Lamaran Terkirim';
      case 'reviewing':
        return 'Sedang Ditinjau';
      case 'shortlisted':
        return 'Kandidat Terpilih';
      case 'interview_scheduled':
        return 'Jadwal Interview';
      case 'accepted':
        return 'Diterima Bekerja';
      case 'rejected':
        return 'Belum Sesuai';
      case 'withdrawn':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  bool get canWithdraw => status == 'submitted' || status == 'reviewing';
}
