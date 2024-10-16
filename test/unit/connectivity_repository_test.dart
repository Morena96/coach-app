import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'dart:async';

import 'package:coach_app/shared/services/connectivity/connectivity_service.dart';
import 'package:coach_app/shared/repositories//connectivity_repository.dart';

// This will generate a MockConnectivityService class
@GenerateMocks([ConnectivityService])
import 'connectivity_repository_test.mocks.dart';

void main() {
  late MockConnectivityService mockService;
  late ConnectivityRepository repository;

  setUp(() {
    mockService = MockConnectivityService();
    repository = ConnectivityRepositoryImpl(mockService);
  });

  test('connectivityStream should return the stream from the service', () {
    final testStream = Stream<bool>.fromIterable([true, false, true]);
    when(mockService.connectivityStream).thenAnswer((_) => testStream);

    expect(repository.connectivityStream, equals(testStream));
  });

  test('initialize should call initialize on the service', () async {
    when(mockService.initialize()).thenAnswer((_) async {});

    await repository.initialize();

    verify(mockService.initialize()).called(1);
  });

  test('dispose should call dispose on the service', () {
    repository.dispose();

    verify(mockService.dispose()).called(1);
  });

  test('connectivityStream should emit values from the service', () async {
    final testStream = Stream<bool>.fromIterable([true, false, true]);
    when(mockService.connectivityStream).thenAnswer((_) => testStream);

    expect(await repository.connectivityStream.toList(), equals([true, false, true]));
  });
}