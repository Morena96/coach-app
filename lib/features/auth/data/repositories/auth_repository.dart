import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/auth/data/auth_storage.dart';
import 'package:coach_app/features/auth/data/models/token_model.dart';
import 'package:domain/features/auth/entities/token.dart';
import 'package:domain/features/auth/repositories/auth_repository.dart';
import 'package:coach_app/shared/providers/riverpod_singletons.dart';
import 'package:coach_app/shared/services/api/api_service.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) => AuthRepositoryImpl(
      ref.watch(publicApiServiceProvider),
      ref.watch(privateApiServiceProvider),
      ref.watch(authStorageProvider),
    );

class AuthRepositoryImpl implements AuthRepository {
  final PublicApiService _publicApiService;
  final PrivateApiService _privateApiService;
  final AuthStorage _authStorage;

  AuthRepositoryImpl(
    this._publicApiService,
    this._privateApiService,
    this._authStorage,
  );

  @override
  Future<bool> login(String username, String password) async {
    final tokenDetails = await _publicApiService.post<Token>(
      'authentication/login',
      data: {'user_name': username, 'password': password},
      fromJson: (json) => TokenModel.fromJson(json),
    );

    await _authStorage.saveAuthData(
      tokenDetails.accessToken,
      '', // TODO Refresh token?
      DateTime.fromMillisecondsSinceEpoch(tokenDetails.expiresAt * 1000),
    );
    return true;
  }

  @override
  Future<void> logout() async {
    try {
      await _privateApiService.post('authentication/logout');
    } finally {
      await _authStorage.clearAuthData();
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _authStorage.hasValidToken();
  }

  @override
  Future<String?> getAccessToken() async {
    return await _authStorage.getToken();
  }

  @override
  Future<bool> refreshToken() async {
    // TODO Implement refresh token
    return false;
  }

  // Additional method not in the interface, but might be useful
  Future<void> resetPassword(String userName) async {
    await _publicApiService.post(
      'authentication/password/request-reset',
      data: {'user_name': userName},
    );
  }
}
