import 'package:coach_app/core/widgets/playback_timer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockPlaybackTimerController extends Mock
    implements PlaybackTimerController {
  @override
  final ValueNotifier<Duration> currentPosition = ValueNotifier(Duration.zero);
  @override
  final ValueNotifier<bool> isPlaying = ValueNotifier(false);
  @override
  final ValueNotifier<double> speedNotifier = ValueNotifier(1.0);

  @override
  Duration get totalDuration => const Duration(minutes: 5);

  @override
  List<double> get availableSpeeds => [1.0, 1.5, 2.0];
}

void main() {
  late MockPlaybackTimerController mockController;

  setUp(() {
    mockController = MockPlaybackTimerController();
  });

  testWidgets('PlaybackTimerWidget displays correct initial state',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackTimerWidget(controller: mockController),
        ),
      ),
    );

    expect(find.text('00:00:00 / 00:05:00'), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsNothing);
    expect(find.text('1.0x'), findsOneWidget);
  });

  testWidgets('PlaybackTimerWidget responds to play/pause',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackTimerWidget(controller: mockController),
        ),
      ),
    );

    // Test play button
    await tester.tap(find.byIcon(Icons.play_arrow));
    verify(mockController.play()).called(1);

    // Simulate playing state
    mockController.isPlaying.value = true;
    await tester.pump();

    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);

    // Test pause button
    await tester.tap(find.byIcon(Icons.pause));
    verify(mockController.pause()).called(1);
  });

  testWidgets('PlaybackTimerWidget updates time display',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackTimerWidget(controller: mockController),
        ),
      ),
    );

    mockController.currentPosition.value =
        const Duration(minutes: 2, seconds: 30);
    await tester.pump();

    expect(find.text('00:02:30 / 00:05:00'), findsOneWidget);
  });

  testWidgets('PlaybackTimerWidget allows speed change',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PlaybackTimerWidget(controller: mockController),
        ),
      ),
    );

    await tester.tap(find.text('1.0x'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('1.5x').last);

    verify(mockController.speed = 1.5).called(1);
  });
}
