class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String role;
  final String status;
  final String? avatarUrl;
  final String? city;
  final String? headline;
  final String? highestCertificateLevel;
  final int profileCompletion;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    required this.status,
    this.avatarUrl,
    this.city,
    this.headline,
    this.highestCertificateLevel,
    this.profileCompletion = 20,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final profile = json['profile'] as Map<String, dynamic>?;
    final candidateProfile = json['candidate_profile'] as Map<String, dynamic>?;

    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'candidate',
      status: json['status'] as String? ?? 'active',
      avatarUrl: profile?['avatar_url'] as String?,
      city: profile?['city'] as String?,
      headline: candidateProfile?['headline'] as String?,
      highestCertificateLevel: candidateProfile?['highest_certificate_level'] as String? ?? 'none',
      profileCompletion: (candidateProfile?['profile_completion'] as num?)?.toInt() ?? 20,
    );
  }

  bool get isCandidate => role == 'candidate';
  bool get isEmployer => role == 'employer';
}
