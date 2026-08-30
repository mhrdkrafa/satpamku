class EmployerDashboardModel {
  final int activeJobs;
  final int totalJobs;
  final int totalApplicants;
  final int pendingReview;
  final int interviewsScheduled;
  final int accepted;
  final List<RecentApplicantModel> recentApplicants;

  EmployerDashboardModel({
    required this.activeJobs,
    required this.totalJobs,
    required this.totalApplicants,
    required this.pendingReview,
    required this.interviewsScheduled,
    required this.accepted,
    required this.recentApplicants,
  });

  factory EmployerDashboardModel.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] as Map<String, dynamic>? ?? {};
    final recentList = (json['recent_applicants'] as List?)
            ?.map((r) => RecentApplicantModel.fromJson(r as Map<String, dynamic>))
            .toList() ??
        [];

    return EmployerDashboardModel(
      activeJobs: (metrics['active_jobs'] as num?)?.toInt() ?? 0,
      totalJobs: (metrics['total_jobs'] as num?)?.toInt() ?? 0,
      totalApplicants: (metrics['total_applicants'] as num?)?.toInt() ?? 0,
      pendingReview: (metrics['pending_review'] as num?)?.toInt() ?? 0,
      interviewsScheduled: (metrics['interviews_scheduled'] as num?)?.toInt() ?? 0,
      accepted: (metrics['accepted'] as num?)?.toInt() ?? 0,
      recentApplicants: recentList,
    );
  }
}

class RecentApplicantModel {
  final int id;
  final String status;
  final DateTime appliedAt;
  final String jobTitle;
  final int jobId;
  final String candidateName;
  final String? candidateAvatar;
  final String certificateLevel;
  final int? heightCm;
  final int? weightKg;

  RecentApplicantModel({
    required this.id,
    required this.status,
    required this.appliedAt,
    required this.jobTitle,
    required this.jobId,
    required this.candidateName,
    this.candidateAvatar,
    required this.certificateLevel,
    this.heightCm,
    this.weightKg,
  });

  factory RecentApplicantModel.fromJson(Map<String, dynamic> json) {
    return RecentApplicantModel(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'submitted',
      appliedAt: DateTime.tryParse(json['applied_at'] ?? '') ?? DateTime.now(),
      jobTitle: json['job_title'] as String? ?? '',
      jobId: json['job_id'] as int? ?? 0,
      candidateName: json['candidate_name'] as String? ?? 'Kandidat Satpam',
      candidateAvatar: json['candidate_avatar'] as String?,
      certificateLevel: json['certificate_level'] as String? ?? 'none',
      heightCm: (json['height_cm'] as num?)?.toInt(),
      weightKg: (json['weight_kg'] as num?)?.toInt(),
    );
  }
}
