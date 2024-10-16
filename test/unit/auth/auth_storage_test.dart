import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/auth/data/auth_storage.dart';

// This will generate a mock class for Box
@GenerateMocks([Box])
import 'auth_storage_test.mocks.dart';

void main() {
  late AuthStorage authStorage;
  late MockBox mockBox;

  setUp(() {
    mockBox = MockBox();
    authStorage = AuthStorage();
    authStorage.box = mockBox;
  });

  group('AuthStorage', () {
    test('saveAuthData stores data correctly', () async {
      const token = 'test_token';
      const refreshToken = 'test_refresh_token';
      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      when(mockBox.put(any, any)).thenAnswer((_) => Future.value());

      await authStorage.saveAuthData(token, refreshToken, expiresAt);

      verify(mockBox.put(AuthStorage.tokenKey, token)).called(1);
      verify(mockBox.put(AuthStorage.refreshTokenKey, refreshToken)).called(1);
      verify(mockBox.put(AuthStorage.expiresAtKey, expiresAt.toIso8601String()))
          .called(1);
    });

    test('getToken returns correct token', () async {
      const token = 'test_token';
      when(mockBox.get(AuthStorage.tokenKey)).thenReturn(token);

      final result = await authStorage.getToken();

      expect(result, equals(token));
    });

    test('getRefreshToken returns correct refresh token', () async {
      const refreshToken = 'test_refresh_token';
      when(mockBox.get(AuthStorage.refreshTokenKey)).thenReturn(refreshToken);

      final result = await authStorage.getRefreshToken();

      expect(result, equals(refreshToken));
    });

    test('getExpiresAt returns correct DateTime', () async {
      final expiresAt = DateTime.now().add(const Duration(hours: 1));
      when(mockBox.get(AuthStorage.expiresAtKey))
          .thenReturn(expiresAt.toIso8601String());

      final result = await authStorage.getExpiresAt();

      expect(result, equals(expiresAt));
    });

    test('clearAuthData deletes all auth data', () async {
      when(mockBox.delete(any)).thenAnswer((_) => Future.value());

      await authStorage.clearAuthData();

      verify(mockBox.delete(AuthStorage.tokenKey)).called(1);
      verify(mockBox.delete(AuthStorage.refreshTokenKey)).called(1);
      verify(mockBox.delete(AuthStorage.expiresAtKey)).called(1);
    });

    test('hasValidToken returns true for valid token', () async {
      const token = 'test_token';
      final expiresAt = DateTime.now().add(const Duration(hours: 1));

      when(mockBox.get(AuthStorage.tokenKey)).thenReturn(token);
      when(mockBox.get(AuthStorage.expiresAtKey))
          .thenReturn(expiresAt.toIso8601String());

      final result = await authStorage.hasValidToken();

      expect(result, isTrue);
    });

    test('hasValidToken returns false for expired token', () async {
      const token = 'test_token';
      final expiresAt = DateTime.now().subtract(const Duration(hours: 1));

      when(mockBox.get(AuthStorage.tokenKey)).thenReturn(token);
      when(mockBox.get(AuthStorage.expiresAtKey))
          .thenReturn(expiresAt.toIso8601String());

      final result = await authStorage.hasValidToken();

      expect(result, isFalse);
    });
  });
}
