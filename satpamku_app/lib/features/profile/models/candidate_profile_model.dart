class CandidateFullProfileModel {
  final int id;
  final int userId;
  final String fullName;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? headline;
  final String? summary;
  final String? birthDate;
  final String? gender;
  final int? heightCm;
  final int? weightKg;
  final String? bloodType;
  final bool hasSimA;
  final bool hasSimB1;
  final bool hasSimB2;
  final bool hasSimC;
  final String highestCertificateLevel;
  final int profileCompletion;
  final bool isProfilePublic;
  final List<ExperienceModel> experiences;
  final List<CertificationModel> certifications;
  final List<DocumentModel> documents;

  CandidateFullProfileModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.headline,
    this.summary,
    this.birthDate,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.bloodType,
    this.hasSimA = false,
    this.hasSimB1 = false,
    this.hasSimB2 = false,
    this.hasSimC = false,
    required this.highestCertificateLevel,
    this.profileCompletion = 0,
    this.isProfilePublic = true,
    this.experiences = const [],
    this.certifications = const [],
    this.documents = const [],
  });

  factory CandidateFullProfileModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? {};
    final userProfile = user['profile'] as Map<String, dynamic>? ?? {};
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

    return CandidateFullProfileModel(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      fullName: user['name'] as String? ?? '',
      email: user['email'] as String? ?? '',
      phone: user['phone'] as String?,
      avatarUrl: userProfile['avatar_url'] as String?,
      headline: json['headline'] as String?,
      summary: json['summary'] as String?,
      birthDate: userProfile['birth_date'] as String?,
      gender: userProfile['gender'] as String?,
      heightCm: (json['height_cm'] as num?)?.toInt(),
      weightKg: (json['weight_kg'] as num?)?.toInt(),
      bloodType: json['blood_type'] as String?,
      hasSimA: json['has_sim_a'] as bool? ?? false,
      hasSimB1: json['has_sim_b1'] as bool? ?? false,
      hasSimB2: json['has_sim_b2'] as bool? ?? false,
      hasSimC: json['has_sim_c'] as bool? ?? false,
      highestCertificateLevel: json['highest_certificate_level'] as String? ?? 'none',
      profileCompletion: (json['profile_completion'] as num?)?.toInt() ?? 0,
      isProfilePublic: json['is_profile_public'] as bool? ?? true,
      experiences: expList,
      certifications: certList,
      documents: docList,
    );
  }
}

class ExperienceModel {
  final int id;
  final String companyName;
  final String positionTitle;
  final String startDate;
  final String? endDate;
  final bool isCurrent;
  final String? description;

  ExperienceModel({
    required this.id,
    required this.companyName,
    required this.positionTitle,
    required this.startDate,
    this.endDate,
    this.isCurrent = false,
    this.description,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['id'] as int,
      companyName: json['company_name'] as String? ?? '',
      positionTitle: json['position_title'] as String? ?? '',
      startDate: json['start_date'] as String? ?? '',
      endDate: json['end_date'] as String?,
      isCurrent: json['is_current'] as bool? ?? false,
      description: json['description'] as String?,
    );
  }
}

class CertificationModel {
  final int id;
  final String certificateName;
  final String certificateLevel;
  final String? certificateNumber;
  final String? issueDate;
  final String? expiryDate;
  final String status;

  CertificationModel({
    required this.id,
    required this.certificateName,
    required this.certificateLevel,
    this.certificateNumber,
    this.issueDate,
    this.expiryDate,
    required this.status,
  });

  factory CertificationModel.fromJson(Map<String, dynamic> json) {
    final cert = json['certification'] as Map<String, dynamic>?;

    return CertificationModel(
      id: json['id'] as int,
      certificateName: cert?['name'] as String? ?? 'Sertifikat Satpam',
      certificateLevel: cert?['level'] as String? ?? json['certificate_level'] as String? ?? 'gada_pratama',
      certificateNumber: json['certificate_number'] as String?,
      issueDate: json['issue_date'] as String?,
      expiryDate: json['expiry_date'] as String?,
      status: json['status'] as String? ?? 'pending',
    );
  }
}

class DocumentModel {
  final int id;
  final String type;
  final String name;
  final String status;
  final String? verifiedAt;

  DocumentModel({
    required this.id,
    required this.type,
    required this.name,
    required this.status,
    this.verifiedAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as int,
      type: json['type'] as String? ?? 'cv',
      name: json['name'] as String? ?? 'Dokumen',
      status: json['status'] as String? ?? 'pending',
      verifiedAt: json['verified_at'] as String?,
    );
  }
}
