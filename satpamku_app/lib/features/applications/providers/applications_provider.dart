import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/job_application_model.dart';
import '../repositories/application_repository.dart';

final applicationRepositoryProvider = Provider<ApplicationRepository>((ref) {
  return ApplicationRepository();
});

final selectedApplicationStatusProvider = StateProvider<String?>((ref) => null);

final candidateApplicationsProvider = FutureProvider.autoDispose<List<JobApplicationModel>>((ref) async {
  final repository = ref.watch(applicationRepositoryProvider);
  final status = ref.watch(selectedApplicationStatusProvider);
  return repository.getApplications(status: status);
});

final applicationDetailProvider = FutureProvider.autoDispose.family<JobApplicationModel, int>((ref, id) async {
  final repository = ref.watch(applicationRepositoryProvider);
  return repository.getApplicationDetail(id);
});
