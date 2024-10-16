import 'package:coach_app/features/auth/data/auth_storage.dart';
import 'package:coach_app/features/auth/data/repositories/auth_repository.dart';
import 'package:coach_app/shared/repositories/connectivity_repository.dart';
import 'package:coach_app/shared/services/api/api_service.dart';
import 'package:coach_app/shared/services/connectivity/connectivity_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a Dio instance for HTTP requests
final dioProvider = Provider((ref) => Dio());

/// Provides an AuthStorage instance for managing authentication data
final authStorageProvider = Provider((ref) => AuthStorage());

/// Provides a PublicApiService instance for non-authenticated API calls
final publicApiServiceProvider = Provider((ref) => createPublicApiService(ref));

/// Provides a PrivateApiService instance for authenticated API calls
final privateApiServiceProvider =
    Provider((ref) => createPrivateApiService(ref));

/// Provides an AuthRepository instance for authentication operations
final authRepositoryProvider = Provider((ref) => createAuthRepository(ref));

/// Provides a ConnectivityService instance for network connectivity checks
final connectivityServiceProvider = Provider((ref) => ConnectivityService());

/// Provides a ConnectivityRepository instance for managing network connectivity state
final connectivityRepositoryProvider = Provider<ConnectivityRepository>(
    (ref) => createConnectivityRepository(ref));

// Factory functions for better testability
PublicApiService createPublicApiService(Ref ref) => PublicApiService(
      ref.watch(dioProvider),
      ref.watch(authStorageProvider),
    );

PrivateApiService createPrivateApiService(Ref ref) => PrivateApiService(
      ref.watch(dioProvider),
      ref.watch(authStorageProvider),
    );

AuthRepositoryImpl createAuthRepository(Ref ref) => AuthRepositoryImpl(
      ref.watch(publicApiServiceProvider),
      ref.watch(privateApiServiceProvider),
      ref.watch(authStorageProvider),
    );

ConnectivityRepositoryImpl createConnectivityRepository(Ref ref) {
  final service = ref.watch(connectivityServiceProvider);
  return ConnectivityRepositoryImpl(service);
}
