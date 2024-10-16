import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/auth/data/auth_storage.dart';
import 'package:coach_app/shared/providers/riverpod_singletons.dart';
import 'package:coach_app/shared/repositories/connectivity_repository.dart';
import 'package:coach_app/shared/services/api/api_service.dart';
import 'package:coach_app/shared/services/connectivity/connectivity_service.dart';

// Mock classes
class MockDio extends Mock implements Dio {}

class MockAuthStorage extends Mock implements AuthStorage {}

class MockPublicApiService extends Mock implements PublicApiService {}

class MockPrivateApiService extends Mock implements PrivateApiService {}

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(MockDio()),
        authStorageProvider.overrideWithValue(MockAuthStorage()),
        publicApiServiceProvider.overrideWith((ref) => MockPublicApiService()),
        privateApiServiceProvider
            .overrideWith((ref) => MockPrivateApiService()),
        connectivityServiceProvider
            .overrideWith((ref) => MockConnectivityService()),
      ],
    );
  });

  test('dioProvider returns a Dio instance', () {
    expect(container.read(dioProvider), isA<Dio>());
  });

  test('authStorageProvider returns an AuthStorage instance', () {
    expect(container.read(authStorageProvider), isA<AuthStorage>());
  });

  test('publicApiServiceProvider returns a PublicApiService instance', () {
    expect(container.read(publicApiServiceProvider), isA<PublicApiService>());
  });

  test('privateApiServiceProvider returns a PrivateApiService instance', () {
    expect(container.read(privateApiServiceProvider), isA<PrivateApiService>());
  });

  test('connectivityServiceProvider returns a ConnectivityService instance',
      () {
    expect(container.read(connectivityServiceProvider),
        isA<ConnectivityService>());
  });

  test(
      'connectivityRepositoryProvider returns a ConnectivityRepositoryImpl instance',
      () {
    expect(container.read(connectivityRepositoryProvider),
        isA<ConnectivityRepositoryImpl>());
  });

  // You can add more specific tests for each provider if needed
}
