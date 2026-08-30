import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:satpamku_app/core/network/api_exception.dart';
import 'package:satpamku_app/core/network/auth_interceptor.dart';
import 'package:satpamku_app/core/storage/secure_storage_service.dart';

// Fake storage for unit testing without platform channels
class FakeSecureStorageService extends SecureStorageService {
  String? token;

  @override
  Future<String?> getAuthToken() async => token;

  @override
  Future<void> saveAuthToken(String token) async => this.token = token;

  @override
  Future<void> clearAll() async => token = null;
}

void main() {
  group('Network & Storage Unit Tests', () {
    test('ApiException correctly parses Laravel validation errors', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/api/v1/auth/login'),
        response: Response(
          requestOptions: RequestOptions(path: '/api/v1/auth/login'),
          statusCode: 422,
          data: {
            'message': 'Data yang diberikan tidak valid.',
            'errors': {
              'phone': ['Nomor telepon wajib diisi.'],
              'password': ['Kata sandi minimal 8 karakter.'],
            },
          },
        ),
      );

      final apiException = ApiException.fromDioError(dioError);

      expect(apiException.statusCode, 422);
      expect(apiException.validationErrors?['phone'], contains('Nomor telepon wajib diisi.'));
      expect(apiException.message, 'Nomor telepon wajib diisi.');
    });

    test('AuthInterceptor attaches Bearer token when present', () async {
      final fakeStorage = FakeSecureStorageService();
      fakeStorage.token = 'test_secret_token_123';

      final interceptor = AuthInterceptor(storageService: fakeStorage);

      final options = RequestOptions(path: '/api/v1/candidate/profile');
      final handler = RequestInterceptorHandler();

      await interceptor.onRequest(options, handler);

      expect(options.headers['Authorization'], 'Bearer test_secret_token_123');
      expect(options.headers['Accept'], 'application/json');
    });
  });
}
