import 'package:coach_app/core/widgets/screens/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../widget_tree.dart';

void main() {
  group('ErrorScreen', () {
    testWidgets('displays error message without retry button',
        (WidgetTester tester) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
        createWidgetTree(
          child: const ErrorScreen(error: errorMessage),
        ),
      );

      expect(find.text('Error: $errorMessage'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNothing);
    });

    testWidgets(
        'displays error message with retry button when onRetry is provided',
        (WidgetTester tester) async {
      const errorMessage = 'Test error message';
      bool retryPressed = false;

      await tester.pumpWidget(
        createWidgetTree(
          child: ErrorScreen(
            error: errorMessage,
            onRetry: () => retryPressed = true,
          ),
        ),
      );

      expect(find.text('Error: $errorMessage'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      expect(retryPressed, isTrue);
    });

    testWidgets('applies correct padding to error message',
        (WidgetTester tester) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
        createWidgetTree(
          child: const ErrorScreen(error: errorMessage),
        ),
      );

      final paddingFinder = find.byType(Padding);
      expect(paddingFinder, findsOneWidget);

      final paddingWidget = tester.widget<Padding>(paddingFinder);
      expect(paddingWidget.padding, const EdgeInsets.all(80));
    });

    testWidgets('respects vertical spacing when retry button is present',
        (WidgetTester tester) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
        createWidgetTree(
          child: ErrorScreen(
            error: errorMessage,
            onRetry: () {},
          ),
        ),
      );

      final sizedBoxFinder = find.byType(SizedBox);
      expect(sizedBoxFinder, findsOneWidget);

      final sizedBoxWidget = tester.widget<SizedBox>(sizedBoxFinder);
      expect(sizedBoxWidget.height, 20);
    });
  });
}
