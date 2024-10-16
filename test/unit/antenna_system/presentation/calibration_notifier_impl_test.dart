
import 'package:coach_app/features/antenna_system/presentation/antenna_system/calibration_notifier_impl.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CalibrationNotifierImpl', () {
    late CalibrationNotifierImpl notifier;

    setUp(() {
      notifier = CalibrationNotifierImpl();
    });

    test('initial values are correct', () {
      expect(notifier.progress, 0.0);
      expect(notifier.error, isNull);
      expect(notifier.isComplete, false);
    });

    test('onProgress updates progress and notifies listeners', () {
      bool listenerCalled = false;
      notifier.addListener(() => listenerCalled = true);

      notifier.onProgress(0.5);

      expect(notifier.progress, 0.5);
      expect(listenerCalled, true);
    });

    test('onComplete sets isComplete to true and notifies listeners', () {
      bool listenerCalled = false;
      notifier.addListener(() => listenerCalled = true);

      notifier.onComplete();

      expect(notifier.isComplete, true);
      expect(listenerCalled, true);
    });

    test('onError sets error message and notifies listeners', () {
      bool listenerCalled = false;
      notifier.addListener(() => listenerCalled = true);

      notifier.onError('Test error');

      expect(notifier.error, 'Test error');
      expect(listenerCalled, true);
    });

    test('reset sets all values to initial state and notifies listeners', () {
      notifier.onProgress(0.5);
      notifier.onError('Test error');
      notifier.onComplete();

      bool listenerCalled = false;
      notifier.addListener(() => listenerCalled = true);

      notifier.reset();

      expect(notifier.progress, 0.0);
      expect(notifier.error, isNull);
      expect(notifier.isComplete, false);
      expect(listenerCalled, true);
    });

    test('multiple updates notify listeners only once per update', () {
      int listenerCallCount = 0;
      notifier.addListener(() => listenerCallCount++);

      notifier.onProgress(0.3);
      notifier.onError('Error 1');
      notifier.onComplete();

      expect(listenerCallCount, 3);
    });
  });
}
