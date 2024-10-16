import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/auth/data/models/token_model.dart';
import 'package:domain/features/auth/entities/token.dart';

void main() {
  group('TokenModel', () {
    test('fromJson creates TokenModel correctly', () {
      final json = {
        'access_token': 'test_token',
        'expires_at': 1625097600, // July 1, 2021
      };
      final tokenModel = TokenModel.fromJson(json);

      expect(tokenModel.accessToken, 'test_token');
      expect(tokenModel.expiresAt, 1625097600);
    });

    test('toJson returns correct Map', () {
      const tokenModel = TokenModel('test_token', 1625097600);
      final json = tokenModel.toJson();

      expect(json, {
        'access_token': 'test_token',
        'expires_at': 1625097600,
      });
    });
  });

  group('Token', () {
    test('isExpired returns true for expired token', () {
      final expiredToken = Token(
          'test_token', (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 3600);
      expect(expiredToken.isExpired(), true);
    });

    test('isExpired returns false for non-expired token', () {
      final validToken = Token(
          'test_token', (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600);
      expect(validToken.isExpired(), false);
    });

    test('toString returns correct string representation', () {
      const token = Token('test_token', 1625097600);
      expect(token.toString(), 'test_token 1625097600');
    });
  });
}
