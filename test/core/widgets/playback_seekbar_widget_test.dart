import 'package:coach_app/core/widgets/playback_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPlaybackTimerController extends Mock
    implements PlaybackTimerController {
  @override
  final ValueNotifier<Duration> currentPosition = ValueNotifier(Duration.zero);

  @override
  Duration get totalDuration => const Duration(minutes: 5);
}

void main() {
  late MockPlaybackTimerController mockController;

  setUp(() {
    mockController = MockPlaybackTimerController();
  });

  testWidgets('PlaybackSeekBarWidget displays correct initial state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackSeekBarWidget(controller: mockController),
        ),
      ),
    );

    final Slider slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.value, 0.0);
    expect(slider.max, 300000.0); // 5 minutes in milliseconds
  });

  testWidgets('PlaybackSeekBarWidget updates on controller change',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackSeekBarWidget(controller: mockController),
        ),
      ),
    );

    mockController.currentPosition.value =
        const Duration(minutes: 2, seconds: 30);
    await tester.pump();

    final Slider slider = tester.widget<Slider>(find.byType(Slider));
    expect(slider.value, 150000.0); // 2.5 minutes in milliseconds
  });

  testWidgets('PlaybackSeekBarWidget calls seek on slide',
      (WidgetTester tester) async {
    bool onSeekChangedCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackSeekBarWidget(
            controller: mockController,
            onSeekChanged: (_) => onSeekChangedCalled = true,
          ),
        ),
      ),
    );

    await tester.drag(find.byType(Slider), const Offset(50.0, 0.0));
    await tester.pumpAndSettle();

    expect(onSeekChangedCalled, isTrue);
  });
}
