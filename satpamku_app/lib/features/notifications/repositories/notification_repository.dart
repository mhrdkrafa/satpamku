import '../../../core/network/api_client.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final ApiClient _apiClient;

  NotificationRepository({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<NotificationListResponse> getNotifications({int page = 1}) async {
    final response = await _apiClient.get('/notifications', queryParameters: {'page': page});
    return NotificationListResponse.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> markAsRead(String id) async {
    await _apiClient.put('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _apiClient.put('/notifications/read-all');
  }

  Future<void> saveDeviceToken(String token, {String deviceType = 'android'}) async {
    await _apiClient.post('/device-token', data: {
      'fcm_token': token,
      'device_type': deviceType,
    });
  }

  Future<void> removeDeviceToken(String token) async {
    await _apiClient.delete('/device-token', data: {
      'fcm_token': token,
    });
  }
}
