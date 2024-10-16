import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:coach_app/core/app_state.dart';

class MockChangeNotifier extends Mock implements ChangeNotifier {}

void main() {
  group('AppState', () {
    late AppState appState;

    setUp(() {
      appState = AppState();
    });

    test('initial state is not connected', () {
      expect(appState.isConnected, false);
    });

    test('setConnectivityStatus updates state', () {
      appState.setConnectivityStatus(true);
      expect(appState.isConnected, true);
    });

  });

  group('AppStateNotifier', () {
    late AppStateNotifier appStateNotifier;

    setUp(() {
      appStateNotifier = AppStateNotifier();
    });

    test('initial state is not connected', () {
      expect(appStateNotifier.state.isConnected, false);
    });

    test('setConnectivityStatus updates state', () {
      appStateNotifier.setConnectivityStatus(true);
      expect(appStateNotifier.state.isConnected, true);
    });
  });

  group('appStateProvider', () {
    test('provides an instance of AppStateNotifier', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final appState = container.read(appStateProvider.notifier);
      expect(appState, isA<AppStateNotifier>());
    });

    test('initial state is not connected', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final isConnected = container.read(appStateProvider).isConnected;
      expect(isConnected, false);
    });

    test('state updates when connectivity status changes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(appStateProvider.notifier).setConnectivityStatus(true);
      final isConnected = container.read(appStateProvider).isConnected;
      expect(isConnected, true);
    });
  });
}
