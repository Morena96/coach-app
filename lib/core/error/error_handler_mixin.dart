import 'package:coach_app/core/error/api_exception.dart';
import 'package:dio/dio.dart';

/// A mixin that provides error handling functionality for API calls.
///
/// This mixin can be used to wrap API calls and handle common error scenarios,
/// such as network timeouts and HTTP status code errors.
mixin ErrorHandler {
  /// Executes the given [apiCall] and handles any errors that occur.
  ///
  /// This method wraps the API call in a try-catch block and translates
  /// exceptions into [ApiException] instances.
  Future<T> handleErrors<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on Exception catch (e) {
      throw ApiException(message: e.toString());
    }
  }

/// Handles [DioException] instances and converts them to [ApiException] instances.
  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
            message: 'Connection timed out',
            statusCode: e.response?.statusCode);
      case DioExceptionType.badResponse:
        return _handleBadResponse(e.response);
      case DioExceptionType.cancel:
        return ApiException(
            message: 'Request cancelled', statusCode: e.response?.statusCode);
      default:
        return ApiException(
            message: 'Network error occurred',
            statusCode: e.response?.statusCode);
    }
  }

/// Handles bad HTTP responses and converts them to [ApiException] instances.
  ApiException _handleBadResponse(Response? response) {
    switch (response?.statusCode) {
      case 400:
        return ApiException(message: 'Bad request', statusCode: 400);
      case 401:
        return ApiException(message: 'Unauthorized', statusCode: 401);
      case 403:
        return ApiException(message: 'Forbidden', statusCode: 403);
      case 404:
        return ApiException(message: 'Not found', statusCode: 404);
      case 422:
        final responseData = response?.data;
        final message = responseData['message'] ?? 'Error';
        final errors = responseData['errors'] as Map<String, dynamic>? ?? {};
        final fieldErrors = errors.map<String, List<String>>(
          (key, value) => MapEntry(key, List<String>.from(value as List)),
        );
        return ApiException(
          message: message,
          statusCode: 422,
          fieldErrors: fieldErrors,
        );
      case 500:
        return ApiException(
          message: 'Internal server error',
          statusCode: 500,
        );
      default:
        return ApiException(
          message: 'Unexpected error occurred',
          statusCode: response?.statusCode,
        );
    }
  }
}
