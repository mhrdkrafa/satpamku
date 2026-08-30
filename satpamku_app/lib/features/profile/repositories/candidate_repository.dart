import '../../../core/network/api_client.dart';
import '../models/candidate_profile_model.dart';

class CandidateRepository {
  final ApiClient _apiClient;

  CandidateRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<CandidateFullProfileModel> getFullProfile() async {
    final response = await _apiClient.get('/candidate/resume');
    return CandidateFullProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> updateProfile({
    String? headline,
    String? summary,
    int? heightCm,
    int? weightKg,
    String? bloodType,
    bool? hasSimA,
    bool? hasSimB1,
    bool? hasSimB2,
    bool? hasSimC,
  }) async {
    await _apiClient.put('/profile/candidate', data: {
      if (headline != null) 'headline': headline,
      if (summary != null) 'summary': summary,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (bloodType != null) 'blood_type': bloodType,
      if (hasSimA != null) 'has_sim_a': hasSimA,
      if (hasSimB1 != null) 'has_sim_b1': hasSimB1,
      if (hasSimB2 != null) 'has_sim_b2': hasSimB2,
      if (hasSimC != null) 'has_sim_c': hasSimC,
    });
  }

  Future<void> addExperience({
    required String companyName,
    required String positionTitle,
    required String startDate,
    String? endDate,
    bool isCurrent = false,
    String? description,
  }) async {
    await _apiClient.post('/candidate/experiences', data: {
      'company_name': companyName,
      'position_title': positionTitle,
      'start_date': startDate,
      'end_date': endDate,
      'is_current': isCurrent,
      'description': description,
    });
  }

  Future<void> deleteExperience(int id) async {
    await _apiClient.delete('/candidate/experiences/$id');
  }

  Future<List<CertificationModel>> getCertifications() async {
    final response = await _apiClient.get('/candidate/certifications');
    return (response.data['data'] as List)
        .map((c) => CertificationModel.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  Future<List<DocumentModel>> getDocuments() async {
    final response = await _apiClient.get('/candidate/documents');
    return (response.data['data'] as List)
        .map((d) => DocumentModel.fromJson(d as Map<String, dynamic>))
        .toList();
  }
}
