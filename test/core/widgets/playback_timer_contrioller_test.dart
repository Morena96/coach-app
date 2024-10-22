import 'package:coach_app/core/widgets/playback_timer_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PlaybackTimerController controller;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    controller = PlaybackTimerController(
      totalDuration: const Duration(minutes: 5),
      availableSpeeds: [1.0, 1.5, 2.0],
    );
  });

  tearDown(() {
    controller.dispose();
  });

  group('PlaybackTimerController', () {
    test('initializes with correct values', () {
      expect(controller.totalDuration, equals(const Duration(minutes: 5)));
      expect(controller.availableSpeeds, equals([1.0, 1.5, 2.0]));
      expect(controller.currentPosition.value, equals(Duration.zero));
      expect(controller.speedNotifier.value, equals(1.0));
      expect(controller.isPlaying.value, isFalse);
    });

    test('play() starts playback', () {
      controller.play();
      expect(controller.isPlaying.value, isTrue);
    });

    test('pause() stops playback', () {
      controller.play();
      controller.pause();
      expect(controller.isPlaying.value, isFalse);
    });

    test('reset() resets position to zero', () {
      controller.seek(const Duration(minutes: 2));
      controller.reset();
      expect(controller.currentPosition.value, equals(Duration.zero));
    });

    test('seek() updates position correctly', () {
      controller.seek(const Duration(minutes: 3));
      expect(
          controller.currentPosition.value, equals(const Duration(minutes: 3)));
    });
  });
}
