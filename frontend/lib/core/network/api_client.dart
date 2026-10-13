import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../errors/app_exception.dart';

/// The one Dio instance for the whole app. Every backend-bound repository
/// call goes through this — see docs/TECHNICAL_DEEP_DIVE.md section 1.2.
class ApiClient {
  ApiClient({required String baseUrl})
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
        )) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await FirebaseAuth.instance.currentUser?.getIdToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) => handler.next(_mapDioError(error)),
      ),
    );
  }

  final Dio _dio;

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get<Map<String, dynamic>>(path, queryParameters: query);
    return _unwrap(response);
  }

  Future<Map<String, dynamic>> post(String path, {Object? data}) async {
    final response = await _dio.post<Map<String, dynamic>>(path, data: data);
    return _unwrap(response);
  }

  Future<Map<String, dynamic>> patch(String path, {Object? data}) async {
    final response = await _dio.patch<Map<String, dynamic>>(path, data: data);
    return _unwrap(response);
  }

  Map<String, dynamic> _unwrap(Response<Map<String, dynamic>> response) {
    final body = response.data ?? const {};
    return (body['data'] as Map<String, dynamic>?) ?? const {};
  }

  DioException _mapDioError(DioException error) {
    final status = error.response?.statusCode;
    final message = (error.response?.data is Map)
        ? (error.response?.data['error']?['message'] as String?)
        : null;

    final AppException mapped = switch (status) {
      401 => UnauthorizedException(message ?? 'Please sign in again.'),
      403 => ForbiddenException(message ?? 'You do not have access to this.'),
      404 => NotFoundException(message ?? 'Not found.'),
      422 => ValidationException(
          (error.response?.data?['error']?['details'] as Map?)?.map(
                (k, v) => MapEntry(k.toString(), v.toString()),
              ) ??
              const {},
          message ?? 'Check the form and try again.',
        ),
      _ => error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout
          ? const NetworkTimeoutException()
          : ServerException(message ?? 'Something went wrong. Try again.'),
    };

    return error.copyWith(error: mapped);
  }
}
