import 'package:coach_app/core/error/api_exception.dart';
import 'package:coach_app/features/auth/data/auth_storage.dart';
import 'package:coach_app/features/auth/data/repositories/auth_repository.dart';
import 'package:domain/features/auth/entities/token.dart';
import 'package:coach_app/shared/services/api/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([PublicApiService, PrivateApiService, AuthStorage])
import 'auth_repository_test.mocks.dart';

void main() {
  late AuthRepositoryImpl authRepository;
  late MockPublicApiService mockPublicApiService;
  late MockPrivateApiService mockPrivateApiService;
  late MockAuthStorage mockAuthStorage;

  setUp(() {
    mockPublicApiService = MockPublicApiService();
    mockPrivateApiService = MockPrivateApiService();
    mockAuthStorage = MockAuthStorage();
    authRepository = AuthRepositoryImpl(
      mockPublicApiService,
      mockPrivateApiService,
      mockAuthStorage,
    );
  });

  group('AuthRepositoryImpl', () {
    test('login - failure', () async {
      const username = 'testuser';
      const password = 'wrongpass';

      when(mockPublicApiService.post<Token>(
        'authentication/login',
        data: {'user_name': username, 'password': password},
      )).thenThrow(ApiException(message: 'Login failed'));
      verifyNever(mockAuthStorage.saveAuthData(any, any, any));
    });

    test('login - success', () async {
      const username = 'testuser';
      const password = 'password';
      const token = Token('', 123);

      when(mockPublicApiService.post<Token>(
        'authentication/login',
        data: {'user_name': username, 'password': password},
      )).thenAnswer((_) async => token);
    });

    test('logout', () async {
      when(mockPrivateApiService.post('authentication/logout'))
          .thenAnswer((_) async {});
      when(mockAuthStorage.clearAuthData()).thenAnswer((_) async {});

      await authRepository.logout();

      verify(mockPrivateApiService.post('authentication/logout')).called(1);
      verify(mockAuthStorage.clearAuthData()).called(1);
    });

    test('isLoggedIn', () async {
      when(mockAuthStorage.hasValidToken()).thenAnswer((_) async => true);

      final result = await authRepository.isLoggedIn();

      expect(result, true);
      verify(mockAuthStorage.hasValidToken()).called(1);
    });

    test('getAccessToken', () async {
      const token = 'access_token';
      when(mockAuthStorage.getToken()).thenAnswer((_) async => token);

      final result = await authRepository.getAccessToken();

      expect(result, token);
      verify(mockAuthStorage.getToken()).called(1);
    });

    test('refreshToken', () async {
      final result = await authRepository.refreshToken();

      expect(result, false);
    });

    test('resetPassword', () async {
      const username = 'testuser';
      when(mockPublicApiService.post(
        'authentication/password/request-reset',
        data: {'user_name': username},
      )).thenAnswer((_) async {});

      await authRepository.resetPassword(username);

      verify(mockPublicApiService.post(
        'authentication/password/request-reset',
        data: {'user_name': username},
      )).called(1);
    });
  });
}
