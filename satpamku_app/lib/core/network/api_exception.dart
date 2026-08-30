import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? validationErrors;

  ApiException({
    required this.message,
    this.statusCode,
    this.validationErrors,
  });

  factory ApiException.fromDioError(DioException error) {
    String message = 'Terjadi kesalahan jaringan. Silakan coba lagi.';
    int? statusCode = error.response?.statusCode;
    Map<String, List<String>>? validationErrors;

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      message = 'Koneksi ke server timeout. Silakan periksa jaringan Anda.';
    } else if (error.type == DioExceptionType.connectionError) {
      message = 'Tidak dapat terhubung ke server Satpamku. Pastikan koneksi aktif.';
    } else if (error.response != null) {
      final data = error.response?.data;

      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) {
          message = data['message'].toString();
        }

        if (data.containsKey('errors') && data['errors'] is Map<String, dynamic>) {
          validationErrors = {};
          (data['errors'] as Map<String, dynamic>).forEach((key, val) {
            if (val is List) {
              validationErrors![key] = val.map((e) => e.toString()).toList();
            }
          });
        }
      }

      if (statusCode == 401) {
        message = message.isEmpty || message == 'Unauthenticated.'
            ? 'Sesi Anda telah berakhir. Silakan login kembali.'
            : message;
      } else if (statusCode == 403) {
        message = message.isEmpty ? 'Anda tidak memiliki akses ke fitur ini.' : message;
      } else if (statusCode == 404) {
        message = message.isEmpty ? 'Data tidak ditemukan di server.' : message;
      } else if (statusCode == 422 && validationErrors != null && validationErrors.isNotEmpty) {
        final firstError = validationErrors.values.first.firstOrNull;
        if (firstError != null) {
          message = firstError;
        }
      }
    }

    return ApiException(
      message: message,
      statusCode: statusCode,
      validationErrors: validationErrors,
    );
  }

  @override
  String toString() => message;
}
