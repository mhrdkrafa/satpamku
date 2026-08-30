import '../../../core/network/api_client.dart';
import '../../jobs/models/job_model.dart';
import '../models/employer_applicant_model.dart';
import '../models/employer_dashboard_model.dart';

class EmployerRepository {
  final ApiClient _apiClient;

  EmployerRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<EmployerDashboardModel> getDashboard() async {
    final response = await _apiClient.get('/employer/dashboard');
    return EmployerDashboardModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<JobModel>> getJobs({String? status}) async {
    final Map<String, dynamic> params = {};
    if (status != null && status.isNotEmpty) params['status'] = status;

    final response = await _apiClient.get('/employer/jobs', queryParameters: params);
    return (response.data['data'] as List)
        .map((j) => JobModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<void> createJob(Map<String, dynamic> payload) async {
    await _apiClient.post('/employer/jobs', data: payload);
  }

  Future<void> updateJob(int id, Map<String, dynamic> payload) async {
    await _apiClient.put('/employer/jobs/$id', data: payload);
  }

  Future<void> changeJobStatus(int id, String status) async {
    await _apiClient.put('/employer/jobs/$id/status', data: {'status': status});
  }

  Future<void> deleteJob(int id) async {
    await _apiClient.delete('/employer/jobs/$id');
  }

  Future<List<EmployerApplicantModel>> getApplicants({int? jobId, String? status, int page = 1}) async {
    final Map<String, dynamic> params = {'page': page};
    if (jobId != null) params['job_id'] = jobId;
    if (status != null && status.isNotEmpty) params['status'] = status;

    final response = await _apiClient.get('/employer/applicants', queryParameters: params);
    return (response.data['data'] as List)
        .map((a) => EmployerApplicantModel.fromJson(a as Map<String, dynamic>))
        .toList();
  }

  Future<EmployerApplicantModel> getApplicantDetail(int id) async {
    final response = await _apiClient.get('/employer/applicants/$id');
    return EmployerApplicantModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> changeApplicantStatus(
    int id, {
    required String status,
    DateTime? interviewAt,
    String? interviewLocation,
    String? rejectionReason,
    String? employerNotes,
  }) async {
    await _apiClient.put('/employer/applicants/$id/status', data: {
      'status': status,
      if (interviewAt != null) 'interview_at': interviewAt.toIso8601String(),
      if (interviewLocation != null && interviewLocation.isNotEmpty) 'interview_location': interviewLocation,
      if (rejectionReason != null && rejectionReason.isNotEmpty) 'rejection_reason': rejectionReason,
      if (employerNotes != null && employerNotes.isNotEmpty) 'employer_notes': employerNotes,
    });
  }
}
