import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_model.dart';
import '../repositories/job_repository.dart';

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  return JobRepository();
});

// Featured Jobs
final featuredJobsProvider = FutureProvider.autoDispose<List<JobModel>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getFeaturedJobs();
});

// Urgent Hiring Jobs
final urgentJobsProvider = FutureProvider.autoDispose<List<JobModel>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getUrgentJobs();
});

// Filter Criteria State
class JobFilterCriteria {
  final String? query;
  final int? categoryId;
  final int? locationId;
  final String? shiftType;
  final String? certificateLevel;
  final int? salaryMin;
  final bool? isUrgent;
  final String sort;

  const JobFilterCriteria({
    this.query,
    this.categoryId,
    this.locationId,
    this.shiftType,
    this.certificateLevel,
    this.salaryMin,
    this.isUrgent,
    this.sort = 'newest',
  });

  bool get hasActiveFilters =>
      (query != null && query!.isNotEmpty) ||
      categoryId != null ||
      locationId != null ||
      shiftType != null ||
      certificateLevel != null ||
      salaryMin != null ||
      isUrgent == true;

  JobFilterCriteria copyWith({
    String? query,
    int? categoryId,
    int? locationId,
    String? shiftType,
    String? certificateLevel,
    int? salaryMin,
    bool? isUrgent,
    String? sort,
    bool clearQuery = false,
    bool clearCategory = false,
    bool clearLocation = false,
    bool clearShift = false,
    bool clearCertificate = false,
    bool clearSalary = false,
    bool clearUrgent = false,
  }) {
    return JobFilterCriteria(
      query: clearQuery ? null : (query ?? this.query),
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      locationId: clearLocation ? null : (locationId ?? this.locationId),
      shiftType: clearShift ? null : (shiftType ?? this.shiftType),
      certificateLevel: clearCertificate ? null : (certificateLevel ?? this.certificateLevel),
      salaryMin: clearSalary ? null : (salaryMin ?? this.salaryMin),
      isUrgent: clearUrgent ? null : (isUrgent ?? this.isUrgent),
      sort: sort ?? this.sort,
    );
  }
}

final jobFilterProvider = StateProvider<JobFilterCriteria>((ref) {
  return const JobFilterCriteria();
});

// Search / Filtered Jobs List
final searchJobsProvider = FutureProvider.autoDispose<List<JobModel>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  final filter = ref.watch(jobFilterProvider);

  return repository.getJobs(
    query: filter.query,
    categoryId: filter.categoryId,
    locationId: filter.locationId,
    shiftType: filter.shiftType,
    certificateLevel: filter.certificateLevel,
    salaryMin: filter.salaryMin,
    isUrgent: filter.isUrgent,
    sort: filter.sort,
  );
});

// Job Detail Provider
final jobDetailProvider = FutureProvider.autoDispose.family<JobDetailModel, String>((ref, slug) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getJobDetail(slug);
});

// Saved Jobs Provider
final savedJobsProvider = FutureProvider.autoDispose<List<JobModel>>((ref) async {
  final repository = ref.watch(jobRepositoryProvider);
  return repository.getSavedJobs();
});
