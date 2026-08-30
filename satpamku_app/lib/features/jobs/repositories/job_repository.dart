import '../../../core/network/api_client.dart';
import '../models/job_model.dart';

class JobRepository {
  final ApiClient _apiClient;

  JobRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<JobModel>> getJobs({
    String? query,
    int? categoryId,
    int? locationId,
    String? shiftType,
    String? certificateLevel,
    int? salaryMin,
    bool? isUrgent,
    bool? isFeatured,
    String sort = 'newest',
    int page = 1,
    int perPage = 15,
  }) async {
    final Map<String, dynamic> params = {
      'page': page,
      'per_page': perPage,
      'sort': sort,
    };

    if (query != null && query.isNotEmpty) params['q'] = query;
    if (categoryId != null) params['category_id'] = categoryId;
    if (locationId != null) params['location_id'] = locationId;
    if (shiftType != null) params['shift_type'] = shiftType;
    if (certificateLevel != null) params['certificate_level'] = certificateLevel;
    if (salaryMin != null) params['salary_min'] = salaryMin;
    if (isUrgent == true) params['is_urgent'] = 1;
    if (isFeatured == true) params['is_featured'] = 1;

    final response = await _apiClient.get('/jobs', queryParameters: params);
    final list = (response.data['data'] as List)
        .map((j) => JobModel.fromJson(j as Map<String, dynamic>))
        .toList();

    return list;
  }

  Future<List<JobModel>> getFeaturedJobs() async {
    final response = await _apiClient.get('/jobs/featured');
    return (response.data['data'] as List)
        .map((j) => JobModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<List<JobModel>> getUrgentJobs() async {
    final response = await _apiClient.get('/jobs/urgent');
    return (response.data['data'] as List)
        .map((j) => JobModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<JobDetailModel> getJobDetail(String slug) async {
    final response = await _apiClient.get('/jobs/$slug');
    return JobDetailModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<bool> toggleSaveJob(int jobId) async {
    final response = await _apiClient.post('/jobs/$jobId/save');
    return response.data['data']['is_saved'] as bool;
  }

  Future<List<JobModel>> getSavedJobs({int page = 1}) async {
    final response = await _apiClient.get('/candidate/saved-jobs', queryParameters: {'page': page});
    return (response.data['data'] as List)
        .map((j) => JobModel.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
