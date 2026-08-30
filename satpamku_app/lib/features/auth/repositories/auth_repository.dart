import '../../../core/network/api_client.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  AuthRepository({
    ApiClient? apiClient,
    SecureStorageService? storageService,
  })  : _apiClient = apiClient ?? ApiClient(),
        _storageService = storageService ?? SecureStorageService();

  Future<UserModel> login({required String username, required String password}) async {
    final response = await _apiClient.post('/auth/login', data: {
      'login': username,
      'username': username,
      'password': password,
    });

    final data = response.data['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final userJson = data['user'] as Map<String, dynamic>;
    final user = UserModel.fromJson(userJson);

    await _storageService.saveAuthToken(token);
    await _storageService.saveUserSession(
      userId: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    );

    return user;
  }

  Future<UserModel> registerCandidate({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    String highestCertificateLevel = 'none',
  }) async {
    final response = await _apiClient.post('/auth/register/candidate', data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'highest_certificate_level': highestCertificateLevel,
    });

    final data = response.data['data'] as Map<String, dynamic>;
    final token = data['token'] as String;
    final userJson = data['user'] as Map<String, dynamic>;
    final user = UserModel.fromJson(userJson);

    await _storageService.saveAuthToken(token);
    await _storageService.saveUserSession(
      userId: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    );

    return user;
  }

  Future<UserModel?> getCurrentUser() async {
    final hasToken = await _storageService.hasValidToken();
    if (!hasToken) return null;

    try {
      final response = await _apiClient.get('/auth/me');
      final userJson = response.data['data'] as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.post('/auth/logout');
    } catch (_) {}
    await _storageService.clearAll();
  }
}
