import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthStorage {
  static const String _boxName = 'secureStorage';
  Box? box;

  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String expiresAtKey = 'expires_at';

  bool get isInitialized => box != null;

  Future<void> init() async {
    if (isInitialized) return;

    final encryptionKey = await _getEncryptionKey();
    box = await Hive.openBox(
      _boxName,
      encryptionCipher: HiveAesCipher(encryptionKey),
    );
  }

  Future<void> _ensureInitialized() async {
    if (!isInitialized) {
      await init();
    }
  }

  Future<void> saveAuthData(
      String token, String refreshToken, DateTime expiresAt) async {
    await _ensureInitialized();
    await box?.put(tokenKey, token);
    await box?.put(refreshTokenKey, refreshToken);
    await box?.put(expiresAtKey, expiresAt.toIso8601String());
  }

  Future<String?> getToken() async {
    await _ensureInitialized();
    return box?.get(tokenKey);
  }

  Future<String?> getRefreshToken() async {
    await _ensureInitialized();
    return box?.get(refreshTokenKey);
  }

  Future<DateTime?> getExpiresAt() async {
    await _ensureInitialized();
    final expiresAtString = box?.get(expiresAtKey);
    return expiresAtString != null ? DateTime.parse(expiresAtString) : null;
  }

  Future<void> clearAuthData() async {
    await _ensureInitialized();
    await box?.delete(tokenKey);
    await box?.delete(refreshTokenKey);
    await box?.delete(expiresAtKey);
  }

  Future<bool> hasValidToken() async {
    await _ensureInitialized();
    final token = await getToken();
    final expiresAt = await getExpiresAt();
    return token != null &&
        expiresAt != null &&
        expiresAt.isAfter(DateTime.now());
  }

  Future<List<int>> _getEncryptionKey() async {
    const String passphrase =
        '1f0874hthIHOija0d9h*HEFioht09q8ht32hfwoe8hw83gh203hry';
    final List<int> passphraseBytes = utf8.encode(passphrase);
    final Digest digest = sha256.convert(passphraseBytes);
    return digest.bytes;
  }
}
