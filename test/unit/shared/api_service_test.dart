import 'dart:convert';

import 'package:coach_app/core/app_config.dart';
import 'package:coach_app/core/error/api_exception.dart';
import 'package:coach_app/features/auth/data/auth_storage.dart';
import 'package:coach_app/shared/services/api/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AuthStorage>()])
void main() {
  group('ApiService', () {
    late MockDio mockDio;
    late MockAuthStorage mockAuthStorage;
    late PublicApiService apiService;

    setUp(() {
      mockDio = MockDio();
      mockAuthStorage = MockAuthStorage();
      when(mockDio.options).thenReturn(BaseOptions(
        baseUrl: Config.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));
      apiService = PublicApiService(mockDio, mockAuthStorage);
    });

    test('initializes Dio with correct baseUrl and headers', () {
      expect(mockDio.options.baseUrl, Config.baseUrl);
      expect(mockDio.options.headers['Content-Type'], 'application/json');
      expect(mockDio.options.headers['Accept'], 'application/json');
    });

    test('get method correctly handles a success response', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/test'),
            data: {'key': 'value'},
            statusCode: 200,
          ));

      var response = await apiService.get('/test', fromJson: (json) => json);

      expect(response, {'key': 'value'});
    });

    test('post method correctly handles a success response', () async {
      when(mockDio.post(any, data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/test'),
                data: {'key': 'value'},
                statusCode: 200,
              ));

      var response = await apiService.post('/test',
          data: {'key': 'value'}, fromJson: (json) => json);

      expect(response, {'key': 'value'});
    });

    test('put method correctly handles a success response', () async {
      when(mockDio.put(any, data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(path: '/test'),
                data: {'key': 'value'},
                statusCode: 200,
              ));

      var response = await apiService.put('/test',
          data: {'key': 'value'}, fromJson: (json) => json);

      expect(response, {'key': 'value'});
    });

    test('delete method correctly handles a success response', () async {
      when(mockDio.delete(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/test'),
            data: {'key': 'value'},
            statusCode: 200,
          ));

      var response = await apiService.delete('/test', fromJson: (json) => json);

      expect(response, {'key': 'value'});
    });

    test('handles a 404 error response', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 404,
        ),
      ));

      expect(
        () async => await apiService.get('/test', fromJson: (json) => json),
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404)),
      );
    });

    test('handles a timeout error response', () async {
      when(mockDio.get(any)).thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(path: '/test'),
      ));

      expect(
        () async => await apiService.get('/test', fromJson: (json) => json),
        throwsA(isA<ApiException>()
            .having((e) => e.message, 'message', 'Connection timed out')),
      );
    });

    test('handles an unexpected error', () async {
      when(mockDio.get(any)).thenThrow(Exception('Unexpected error'));

      expect(
        () async => await apiService.get('/test', fromJson: (json) => json),
        throwsA(isA<ApiException>().having(
            (e) => e.message, 'message', 'Exception: Unexpected error')),
      );
    });

    test('handles validation error with status code 422', () async {
      when(mockDio.get(any)).thenThrow(DioException.badResponse(
          statusCode: 422,
          requestOptions: RequestOptions(path: '/test', data: {
            'email': 'test@test.com',
            'password': 'password',
          }),
          response: Response(
            requestOptions: RequestOptions(path: '/test'),
            statusCode: 422,
            data: {
              'message': 'Validation error',
              'errors': {
                'email': ['The email field is required.'],
                'password': ['The password field is required.'],
              }
            },
          )));

      expect(
        () async => await apiService.get('/test', fromJson: (json) => json),
        throwsA(isA<ApiException>()
            .having((e) => e.message, 'message', 'Validation error')),
      );
    });

    test('handles various ApiException for badStatus codes 400', () async {
      when(mockDio.get(any)).thenThrow(DioException.badResponse(
          statusCode: 400,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: '/test'),
          )));

      expect(
        () async => await apiService.get('/test'),
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 400)),
      );
    });

    test('handles various ApiException for badStatus codes 401', () async {
      when(mockDio.get(any)).thenThrow(DioException.badResponse(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/test'),
          )));

      expect(
        () async => await apiService.get('/test'),
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 401)),
      );
    });

    test('handles error when DioExceptionType.cancel', () async {
      when(mockDio.get(any)).thenThrow(DioException.requestCancelled(
        requestOptions: RequestOptions(path: '/test'),
        reason: Error(),
      ));

      expect(
        () async => await apiService.get('/test'),
        throwsA(isA<ApiException>()
            .having((e) => e.statusCode, 'statusCode', null)),
      );
    });

    test('handles various ApiException for badStatus codes 403', () async {
      when(mockDio.get(any)).thenThrow(DioException.badResponse(
          statusCode: 403,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: '/test'),
          )));

      expect(
        () async => await apiService.get('/test'),
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 403)),
      );
    });

    test('handles various ApiException for badStatus codes 404', () async {
      when(mockDio.get(any)).thenThrow(DioException.badResponse(
          statusCode: 404,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: '/test'),
          )));

      expect(
        () async => await apiService.get('/test'),
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 404)),
      );
    });

    test('handles various ApiException for badStatus codes 500', () async {
      when(mockDio.get(any)).thenThrow(DioException.badResponse(
          statusCode: 500,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/test'),
          )));

      expect(
        () async => await apiService.get('/test'),
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500)),
      );
    });

    test('handles various ApiException for badStatus codes 502', () async {
      when(mockDio.get(any)).thenThrow(DioException.badResponse(
          statusCode: 502,
          requestOptions: RequestOptions(path: '/test'),
          response: Response(
            statusCode: 502,
            requestOptions: RequestOptions(path: '/test'),
          )));

      expect(
        () async => await apiService.get('/test'),
        throwsA(
            isA<ApiException>().having((e) => e.statusCode, 'statusCode', 502)),
      );
    });

    test('throws ApiException for unsupported type', () async {
      final testResponse = Response(
          requestOptions: RequestOptions(path: '/convert'),
          data: {'key': 'value'});
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => testResponse);

      expect(
        () => apiService.get<String>(
          '/convert',
          fromJson: (json) => json,
        ),
        throwsA(isA<ApiException>()),
      );
    });

    test('converts list response using fromJson function', () async {
      final listResponse =
          Response(requestOptions: RequestOptions(path: '/convert'), data: """
          [
            {"key": "value1"},
            {"key": "value2"}
          ]
          """);

      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => listResponse);

      final result = await apiService.get<List<Map<String, dynamic>>>(
        '/convert',
        fromJson: (json) {
          var decodedJson = jsonDecode(json) as List;

          return decodedJson
              .map((json) => json as Map<String, dynamic>)
              .toList();
        },
      );

      expect(result, [
        {'key': 'value1'},
        {'key': 'value2'}
      ]);
    });
  });

  group('PrivateApiService', () {
    late MockDio mockDio;
    late MockAuthStorage mockAuthStorage;
    late PrivateApiService privateApiService;

    setUp(() {
      mockDio = MockDio();
      mockAuthStorage = MockAuthStorage();
      when(mockDio.options).thenReturn(BaseOptions(
        baseUrl: Config.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));
      var interceptors = Interceptors();
      when(mockDio.interceptors).thenReturn(interceptors);
      privateApiService = PrivateApiService(mockDio, mockAuthStorage);
    });

    test('get method correctly handles a success response', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: '/test'),
            data: {'key': 'value'},
            statusCode: 200,
          ));

      var response =
          await privateApiService.get('/test', fromJson: (json) => json);

      expect(response, {'key': 'value'});
    });
  });

  group('PrivateApiService dio tests', () {
    late Dio dio;
    late MockAuthStorage mockAuthStorage;
    late PrivateApiService privateApiService;

    setUp(() {
      dio = Dio();
      mockAuthStorage = MockAuthStorage();
    });

    test('dio adds http interceptors properly', () {
      privateApiService = PrivateApiService(dio, mockAuthStorage);

      var dioInterceptors = privateApiService.getDioInterceptors();

      // expect that we have at least one of type InterceptorsWrapper
      expect(dioInterceptors.any((element) => element is InterceptorsWrapper),
          true);
    });
  });
}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}
