import '../../profile/models/candidate_profile_model.dart';

class EmployerApplicantModel {
  final int id;
  final String status;
  final DateTime appliedAt;
  final DateTime? interviewAt;
  final String? interviewLocation;
  final String? rejectionReason;
  final String? employerNotes;
  final String? coverLetter;
  final String jobTitle;
  final int jobId;
  final CandidateApplicantInfo candidate;

  EmployerApplicantModel({
    required this.id,
    required this.status,
    required this.appliedAt,
    this.interviewAt,
    this.interviewLocation,
    this.rejectionReason,
    this.employerNotes,
    this.coverLetter,
    required this.jobTitle,
    required this.jobId,
    required this.candidate,
  });

  factory EmployerApplicantModel.fromJson(Map<String, dynamic> json) {
    final job = json['job'] as Map<String, dynamic>? ?? {};
    final candidateJson = json['candidate'] as Map<String, dynamic>? ?? {};

    return EmployerApplicantModel(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'submitted',
      appliedAt: DateTime.tryParse(json['applied_at'] ?? '') ?? DateTime.now(),
      interviewAt: json['interview_at'] != null ? DateTime.tryParse(json['interview_at']) : null,
      interviewLocation: json['interview_location'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      employerNotes: json['employer_notes'] as String?,
      coverLetter: json['cover_letter'] as String?,
      jobTitle: job['title'] as String? ?? '',
      jobId: job['id'] as int? ?? 0,
      candidate: CandidateApplicantInfo.fromJson(candidateJson),
    );
  }

  String get statusDisplay {
    switch (status) {
      case 'submitted':
        return 'Lamaran Baru';
      case 'reviewing':
        return 'Sedang Ditinjau';
      case 'shortlisted':
        return 'Kandidat Terpilih';
      case 'interview_scheduled':
        return 'Interview Terjadwal';
      case 'accepted':
        return 'Diterima Bekerja';
      case 'rejected':
        return 'Ditolak';
      case 'withdrawn':
        return 'Dibatalkan Pelamar';
      default:
        return status;
    }
  }
}

class CandidateApplicantInfo {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? headline;
  final String? summary;
  final String highestCertificateLevel;
  final int? heightCm;
  final int? weightKg;
  final bool hasSimA;
  final bool hasSimB1;
  final bool hasSimC;
  final int profileCompletion;
  final List<ExperienceModel> experiences;
  final List<CertificationModel> certifications;
  final List<DocumentModel> documents;

  CandidateApplicantInfo({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.headline,
    this.summary,
    required this.highestCertificateLevel,
    this.heightCm,
    this.weightKg,
    this.hasSimA = false,
    this.hasSimB1 = false,
    this.hasSimC = false,
    this.profileCompletion = 0,
    this.experiences = const [],
    this.certifications = const [],
    this.documents = const [],
  });

  factory CandidateApplicantInfo.fromJson(Map<String, dynamic> json) {
    final expList = (json['experiences'] as List?)
            ?.map((e) => ExperienceModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final certList = (json['certifications'] as List?)
            ?.map((e) => CertificationModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];
    final docList = (json['documents'] as List?)
            ?.map((e) => DocumentModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return CandidateApplicantInfo(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Kandidat',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      headline: json['headline'] as String?,
      summary: json['summary'] as String?,
      highestCertificateLevel: json['highest_certificate_level'] as String? ?? 'none',
      heightCm: (json['height_cm'] as num?)?.toInt(),
      weightKg: (json['weight_kg'] as num?)?.toInt(),
      hasSimA: json['has_sim_a'] as bool? ?? false,
      hasSimB1: json['has_sim_b1'] as bool? ?? false,
      hasSimC: json['has_sim_c'] as bool? ?? false,
      profileCompletion: (json['profile_completion'] as num?)?.toInt() ?? 0,
      experiences: expList,
      certifications: certList,
      documents: docList,
    );
  }
}
