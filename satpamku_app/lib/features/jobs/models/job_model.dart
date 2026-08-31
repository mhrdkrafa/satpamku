import 'package:intl/intl.dart';

class JobModel {
  final int id;
  final String title;
  final String slug;
  final String companyName;
  final String? companyLogoUrl;
  final String? companyCity;
  final String categoryName;
  final String? categoryIcon;
  final String locationName;
  final String shiftType;
  final int? salaryMin;
  final int? salaryMax;
  final bool salaryIsHidden;
  final String requiredCertificateLevel;
  final bool isUrgent;
  final bool isFeatured;
  final int? matchScore;
  final List<String> matchReasons;
  final DateTime? publishedAt;

  JobModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.companyName,
    this.companyLogoUrl,
    this.companyCity,
    required this.categoryName,
    this.categoryIcon,
    required this.locationName,
    required this.shiftType,
    this.salaryMin,
    this.salaryMax,
    this.salaryIsHidden = false,
    required this.requiredCertificateLevel,
    this.isUrgent = false,
    this.isFeatured = false,
    this.matchScore,
    this.matchReasons = const [],
    this.publishedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    final employer = json['employer'] as Map<String, dynamic>?;
    final category = json['category'] as Map<String, dynamic>?;
    final location = json['location'] as Map<String, dynamic>?;

    final reasonsList = (json['match_reasons'] as List?)?.map((r) => r.toString()).toList() ?? [];

    return JobModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      companyName: employer?['company_name'] as String? ?? 'Perusahaan BUJP',
      companyLogoUrl: employer?['logo_url'] as String?,
      companyCity: employer?['city'] as String?,
      categoryName: category?['name'] as String? ?? 'Keamanan',
      categoryIcon: category?['icon'] as String?,
      locationName: location?['name'] as String? ?? 'Indonesia',
      shiftType: json['shift_type'] as String? ?? '2_shift',
      salaryMin: (json['salary_min'] as num?)?.toInt(),
      salaryMax: (json['salary_max'] as num?)?.toInt(),
      salaryIsHidden: json['salary_is_hidden'] as bool? ?? false,
      requiredCertificateLevel: json['required_certificate_level'] as String? ?? 'none',
      isUrgent: json['is_urgent'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      matchScore: (json['match_score'] as num?)?.toInt(),
      matchReasons: reasonsList,
      publishedAt: json['published_at'] != null ? DateTime.tryParse(json['published_at'].toString()) : null,
    );
  }

  String get employmentType {
    switch (shiftType) {
      case 'part_time':
        return 'Part-time';
      case 'event':
      case 'temporary':
        return 'Contract';
      default:
        return 'Full-time';
    }
  }

  String get postedTimeAgo {
    if (publishedAt == null) return '';
    final diff = DateTime.now().difference(publishedAt!);
    if (diff.inDays > 30) {
      return '${(diff.inDays / 30).floor()} bulan lalu';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} hari lalu';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} menit lalu';
    } else {
      return 'baru saja';
    }
  }

  String get formattedSalary {
    if (salaryIsHidden || (salaryMin == null && salaryMax == null)) {
      return 'Gaji Dirahasiakan / Negosiasi';
    }

    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    if (salaryMin != null && salaryMax != null) {
      return '${formatter.format(salaryMin)} - ${formatter.format(salaryMax)} / bln';
    } else if (salaryMin != null) {
      return 'Mulai ${formatter.format(salaryMin)} / bln';
    } else {
      return 'Hingga ${formatter.format(salaryMax)} / bln';
    }
  }

  String get formattedShift {
    switch (shiftType) {
      case '2_shift':
        return '2 Shift (12 Jam)';
      case '3_shift':
        return '3 Shift (8 Jam)';
      case 'full_time':
        return 'Penuh Waktu';
      case 'part_time':
        return 'Paruh Waktu';
      case 'event':
        return 'Event / Acara';
      case 'temporary':
        return 'Kontrak / Temporer';
      default:
        return shiftType;
    }
  }
}

class JobDetailModel extends JobModel {
  final String description;
  final String? requirements;
  final String? responsibilities;
  final String? placementAddress;
  final int experienceYearsMin;
  final int? minHeightCm;
  final int? minWeightKg;
  final bool requiresSim;
  final List<String> requiredSimTypes;
  final int viewsCount;
  final int applicationsCount;
  final List<String> facilities;
  final List<String> skills;
  final List<Map<String, dynamic>> certifications;

  JobDetailModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.companyName,
    super.companyLogoUrl,
    super.companyCity,
    required super.categoryName,
    super.categoryIcon,
    required super.locationName,
    required super.shiftType,
    super.salaryMin,
    super.salaryMax,
    super.salaryIsHidden,
    required super.requiredCertificateLevel,
    super.isUrgent,
    super.isFeatured,
    super.publishedAt,
    required this.description,
    this.requirements,
    this.responsibilities,
    this.placementAddress,
    this.experienceYearsMin = 0,
    this.minHeightCm,
    this.minWeightKg,
    this.requiresSim = false,
    this.requiredSimTypes = const [],
    this.viewsCount = 0,
    this.applicationsCount = 0,
    this.facilities = const [],
    this.skills = const [],
    this.certifications = const [],
  });

  List<String> get responsibilitiesList {
    if (responsibilities == null || responsibilities!.trim().isEmpty) return [];
    return responsibilities!
        .split('\n')
        .map((s) => s.replaceAll(RegExp(r'^[\s\-•*]+'), '').trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  List<String> get requirementsList {
    if (requirements == null || requirements!.trim().isEmpty) return [];
    return requirements!
        .split('\n')
        .map((s) => s.replaceAll(RegExp(r'^[\s\-•*]+'), '').trim())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  factory JobDetailModel.fromJson(Map<String, dynamic> json) {
    final base = JobModel.fromJson(json);

    final facilitiesList = (json['facilities'] as List?)
            ?.map((e) => (e as Map<String, dynamic>)['name'] as String)
            .toList() ??
        [];

    final skillsList = (json['skills'] as List?)
            ?.map((e) => (e as Map<String, dynamic>)['name'] as String)
            .toList() ??
        [];

    final certsList = (json['certifications'] as List?)
            ?.map((e) => e as Map<String, dynamic>)
            .toList() ??
        [];

    return JobDetailModel(
      id: base.id,
      title: base.title,
      slug: base.slug,
      companyName: base.companyName,
      companyLogoUrl: base.companyLogoUrl,
      companyCity: base.companyCity,
      categoryName: base.categoryName,
      categoryIcon: base.categoryIcon,
      locationName: base.locationName,
      shiftType: base.shiftType,
      salaryMin: base.salaryMin,
      salaryMax: base.salaryMax,
      salaryIsHidden: base.salaryIsHidden,
      requiredCertificateLevel: base.requiredCertificateLevel,
      isUrgent: base.isUrgent,
      isFeatured: base.isFeatured,
      publishedAt: base.publishedAt,
      description: json['description'] as String? ?? '',
      requirements: json['requirements'] as String?,
      responsibilities: json['responsibilities'] as String?,
      placementAddress: json['placement_address'] as String?,
      experienceYearsMin: (json['experience_years_min'] as num?)?.toInt() ?? 0,
      minHeightCm: (json['min_height_cm'] as num?)?.toInt(),
      minWeightKg: (json['min_weight_kg'] as num?)?.toInt(),
      requiresSim: json['requires_sim'] as bool? ?? false,
      requiredSimTypes: (json['required_sim_types'] as List?)?.map((e) => e.toString()).toList() ?? [],
      viewsCount: (json['views_count'] as num?)?.toInt() ?? 0,
      applicationsCount: (json['applications_count'] as num?)?.toInt() ?? 0,
      facilities: facilitiesList,
      skills: skillsList,
      certifications: certsList,
    );
  }
}
