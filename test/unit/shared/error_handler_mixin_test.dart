import 'package:coach_app/core/error/api_exception.dart';
import 'package:coach_app/core/error/error_handler_mixin.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'error_handler_mixin_test.mocks.dart';

class TestApiService with ErrorHandler {
  Future<T> executeApiCall<T>(Future<T> Function() apiCall) {
    return handleErrors(apiCall);
  }
}

@GenerateMocks([Dio])
void main() {
  group('ErrorHandler', () {
    late TestApiService apiService;
    late MockDio mockDio;

    setUp(() {
      apiService = TestApiService();
      mockDio = MockDio();
    });

    test('handle connection timeout error', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(
        () async => await apiService.executeApiCall(() => mockDio.get('/test')),
        throwsA(predicate((e) =>
            e is ApiException &&
            e.message == 'Connection timed out' &&
            e.statusCode == null)),
      );
    });

    test('handle bad response error with status code 404', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
        ),
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(
        () async => await apiService.executeApiCall(() => mockDio.get('/test')),
        throwsA(predicate((e) =>
            e is ApiException &&
            e.message == 'Not found' &&
            e.statusCode == 404)),
      );
    });

    test('handle unexpected error', () async {
      when(mockDio.get(any)).thenThrow(Exception('Unexpected error'));

      expect(
        () async => await apiService.executeApiCall(() => mockDio.get('/test')),
        throwsA(predicate((e) => e is ApiException)),
      );
    });

    test('handle validation error with status code 422', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 422,
          data: {
            'message': 'Validation error',
            'errors': {
              'field1': ['Error 1'],
              'field2': ['Error 2'],
            }
          },
        ),
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(
        () async => await apiService.executeApiCall(() => mockDio.get('/test')),
        throwsA(predicate((e) =>
            e is ApiException &&
            e.message == 'Validation error' &&
            e.statusCode == 422 &&
            e.fieldErrors?['field1']?.contains('Error 1') == true &&
            e.fieldErrors?['field2']?.contains('Error 2') == true)),
      );
    });
  });
}
