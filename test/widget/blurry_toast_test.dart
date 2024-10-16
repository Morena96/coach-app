import 'package:coach_app/core/widgets/blurry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BlurryToast Widget Tests', () {
    testWidgets('BlurryToast displays message and close button',
        (WidgetTester tester) async {
      const testMessage = 'Test Message';
      bool dismissCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BlurryToast(
              message: testMessage,
              onDismiss: () => dismissCalled = true,
            ),
          ),
        ),
      );

      // Verify that the message is displayed
      expect(find.text(testMessage), findsOneWidget);

      // Verify that the close button is present
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Tap the close button and verify that onDismiss is called
      await tester.tap(find.byIcon(Icons.close));
      expect(dismissCalled, isTrue);
    });
  });

  group('FadeInToast Widget Tests', () {
    testWidgets('FadeInToast applies fade animation',
        (WidgetTester tester) async {
      const testDuration = Duration(milliseconds: 300);
      const testChild = Text('Fade In Test');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FadeInToast(
              duration: testDuration,
              child: testChild,
            ),
          ),
        ),
      );

      // Check initial opacity
      var opacity = tester
          .widget<FadeTransition>(find.byType(FadeTransition))
          .opacity
          .value;
      expect(opacity, 0.0);

      // Advance animation halfway
      await tester.pump(testDuration ~/ 2);
      opacity = tester
          .widget<FadeTransition>(find.byType(FadeTransition))
          .opacity
          .value;
      expect(opacity, greaterThan(0.0));
      expect(opacity, lessThan(1.0));

      // Advance animation to the end
      await tester.pumpAndSettle();
      opacity = tester
          .widget<FadeTransition>(find.byType(FadeTransition))
          .opacity
          .value;
      expect(opacity, 1.0);

      // Verify that the child is displayed
      expect(find.byWidget(testChild), findsOneWidget);
    });
  });
}
