import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/candidate_profile_model.dart';
import '../repositories/candidate_repository.dart';

final candidateRepositoryProvider = Provider<CandidateRepository>((ref) {
  return CandidateRepository();
});

final candidateFullProfileProvider = FutureProvider.autoDispose<CandidateFullProfileModel>((ref) async {
  final repository = ref.watch(candidateRepositoryProvider);
  return repository.getFullProfile();
});

final candidateCertificationsProvider = FutureProvider.autoDispose<List<CertificationModel>>((ref) async {
  final repository = ref.watch(candidateRepositoryProvider);
  return repository.getCertifications();
});

final candidateDocumentsProvider = FutureProvider.autoDispose<List<DocumentModel>>((ref) async {
  final repository = ref.watch(candidateRepositoryProvider);
  return repository.getDocuments();
});
