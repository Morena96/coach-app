import 'dart:async';

import 'package:coach_app/shared/services/connectivity/connectivity_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Connectivity])
import 'connectivity_service_test.mocks.dart';

void main() {
  group('ConnectivityService Tests', () {
    late ConnectivityService connectivityService;
    late MockConnectivity mockConnectivity;
    late StreamController<List<ConnectivityResult>>
        connectivityStreamController;

    setUp(() {
      mockConnectivity = MockConnectivity();
      connectivityStreamController =
          StreamController<List<ConnectivityResult>>.broadcast();

      when(mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => connectivityStreamController.stream);

      connectivityService = ConnectivityService(connectivity: mockConnectivity);
    });

    tearDown(() {
      connectivityService.dispose();
      connectivityStreamController.close();
    });

    test('isConnected returns true for valid connectivity results', () {
      expect(
          connectivityService.isConnected([ConnectivityResult.wifi]), isTrue);
      expect(
          connectivityService.isConnected([ConnectivityResult.mobile]), isTrue);
      expect(connectivityService.isConnected([ConnectivityResult.ethernet]),
          isTrue);
    });

    test('isConnected returns false for invalid connectivity results', () {
      expect(
          connectivityService.isConnected([ConnectivityResult.none]), isFalse);
    });

    test('isConnected returns true for mixed connectivity results', () {
      expect(
          connectivityService
              .isConnected([ConnectivityResult.wifi, ConnectivityResult.none]),
          isTrue);
      expect(
          connectivityService.isConnected(
              [ConnectivityResult.mobile, ConnectivityResult.none]),
          isTrue);
      expect(
          connectivityService.isConnected(
              [ConnectivityResult.ethernet, ConnectivityResult.none]),
          isTrue);
    });

    test('isConnected returns false for empty list', () {
      expect(connectivityService.isConnected([]), isFalse);
    });

    test('isConnected returns true when at least one valid connection exists',
        () {
      expect(
          connectivityService.isConnected([
            ConnectivityResult.none,
            ConnectivityResult.wifi,
            ConnectivityResult.bluetooth
          ]),
          isTrue);
    });

    test('connectivityStream emits correct values', () async {
      expectLater(connectivityService.connectivityStream,
          emitsInOrder([true, false, true]));

      connectivityStreamController.add([ConnectivityResult.wifi]);
      connectivityStreamController.add([ConnectivityResult.none]);
      connectivityStreamController.add([ConnectivityResult.mobile]);
    });

    test('initialize sets initial connectivity state', () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);

      // Set up the listener before calling initialize
      final future =
          expectLater(connectivityService.connectivityStream, emits(true));

      await connectivityService.initialize();

      verify(mockConnectivity.checkConnectivity()).called(1);

      // Await the future to ensure the test completes
      await future;
    });
    test('initialize sets initial state as disconnected when no connectivity',
        () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.none]);

      // Set up the listener before calling initialize
      final future =
          expectLater(connectivityService.connectivityStream, emits(false));

      await connectivityService.initialize();

      verify(mockConnectivity.checkConnectivity()).called(1);

      // Await the future to ensure the test completes
      await future;
    });

    test('dispose cancels subscription', () {
      connectivityService.dispose();
      verify(mockConnectivity.onConnectivityChanged).called(1);
    });
  });
}
