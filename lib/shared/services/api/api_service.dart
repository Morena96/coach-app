import 'package:coach_app/core/app_config.dart';
import 'package:coach_app/core/error/api_exception.dart';
import 'package:coach_app/core/error/error_handler_mixin.dart';
import 'package:coach_app/features/auth/data/auth_storage.dart';
import 'package:dio/dio.dart';

abstract class ApiService with ErrorHandler {
  final Dio _dio;
  final AuthStorage _authStorage;

  ApiService(this._dio, this._authStorage) {
    _dio.options.baseUrl = Config.baseUrl;
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  }) async {
    return handleErrors(() async {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _convertResponse<T>(response, fromJson);
    });
  }

  Future<T> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    return handleErrors(() async {
      final response = await _dio.post(path, data: data);
      return _convertResponse<T>(response, fromJson);
    });
  }

  Future<T> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? fromJson,
  }) async {
    return handleErrors(() async {
      final response = await _dio.put(path, data: data);
      return _convertResponse<T>(response, fromJson);
    });
  }

  Future<T> delete<T>(
    String path, {
    T Function(dynamic)? fromJson,
  }) async {
    return handleErrors(() async {
      final response = await _dio.delete(path);
      return _convertResponse<T>(response, fromJson);
    });
  }

  dynamic _convertResponse<T>(
      Response response, dynamic Function(dynamic)? fromJson) {
    try {
      if (fromJson == null) {
        return null;
      } else {
        return fromJson(response.data);
      }
    } catch (_) {
      throw ApiException(message: 'Unsupported type: $T');
    }
  }
}

class PublicApiService extends ApiService {
  PublicApiService(super.dio, super.authStorage);
}

class PrivateApiService extends ApiService {
  PrivateApiService(super.dio, super.authStorage) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _authStorage.getToken();
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  getDioInterceptors() {
    return _dio.interceptors;
  }
}
