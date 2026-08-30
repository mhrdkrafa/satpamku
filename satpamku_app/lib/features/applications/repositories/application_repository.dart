import '../../../core/network/api_client.dart';
import '../models/job_application_model.dart';

class ApplicationRepository {
  final ApiClient _apiClient;

  ApplicationRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<JobApplicationModel> apply({
    required int jobId,
    String? coverLetter,
  }) async {
    final response = await _apiClient.post('/jobs/$jobId/apply', data: {
      if (coverLetter != null && coverLetter.isNotEmpty) 'cover_letter': coverLetter,
    });

    final data = response.data['data'] as Map<String, dynamic>;
    final appResponse = await _apiClient.get('/candidate/applications/${data['id']}');
    return JobApplicationModel.fromJson(appResponse.data['data'] as Map<String, dynamic>);
  }

  Future<List<JobApplicationModel>> getApplications({String? status, int page = 1}) async {
    final Map<String, dynamic> params = {'page': page};
    if (status != null && status.isNotEmpty) params['status'] = status;

    final response = await _apiClient.get('/candidate/applications', queryParameters: params);
    return (response.data['data'] as List)
        .map((a) => JobApplicationModel.fromJson(a as Map<String, dynamic>))
        .toList();
  }

  Future<JobApplicationModel> getApplicationDetail(int applicationId) async {
    final response = await _apiClient.get('/candidate/applications/$applicationId');
    return JobApplicationModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> withdrawApplication(int applicationId) async {
    await _apiClient.post('/candidate/applications/$applicationId/withdraw');
  }
}
