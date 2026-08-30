import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../jobs/models/job_model.dart';
import '../models/employer_applicant_model.dart';
import '../models/employer_dashboard_model.dart';
import '../repositories/employer_repository.dart';

final employerRepositoryProvider = Provider<EmployerRepository>((ref) {
  return EmployerRepository();
});

final employerDashboardProvider = FutureProvider.autoDispose<EmployerDashboardModel>((ref) async {
  final repository = ref.watch(employerRepositoryProvider);
  return repository.getDashboard();
});

final selectedJobStatusFilterProvider = StateProvider<String?>((ref) => null);

final employerJobsProvider = FutureProvider.autoDispose<List<JobModel>>((ref) async {
  final repository = ref.watch(employerRepositoryProvider);
  final status = ref.watch(selectedJobStatusFilterProvider);
  return repository.getJobs(status: status);
});

class ApplicantFilter {
  final int? jobId;
  final String? status;

  const ApplicantFilter({this.jobId, this.status});

  ApplicantFilter copyWith({int? jobId, String? status, bool clearJob = false, bool clearStatus = false}) {
    return ApplicantFilter(
      jobId: clearJob ? null : (jobId ?? this.jobId),
      status: clearStatus ? null : (status ?? this.status),
    );
  }
}

final employerApplicantFilterProvider = StateProvider<ApplicantFilter>((ref) => const ApplicantFilter());

final employerApplicantsProvider = FutureProvider.autoDispose<List<EmployerApplicantModel>>((ref) async {
  final repository = ref.watch(employerRepositoryProvider);
  final filter = ref.watch(employerApplicantFilterProvider);
  return repository.getApplicants(jobId: filter.jobId, status: filter.status);
});

final employerApplicantDetailProvider = FutureProvider.autoDispose.family<EmployerApplicantModel, int>((ref, id) async {
  final repository = ref.watch(employerRepositoryProvider);
  return repository.getApplicantDetail(id);
});
