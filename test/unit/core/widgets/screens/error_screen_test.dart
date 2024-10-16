import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/core/widgets/screens/error_screen.dart';

import '../../../../widget_tree.dart';

void main() {
  group('ErrorScreen', () {
    testWidgets('displays error message correctly',
        (WidgetTester tester) async {
      const errorMessage = 'Test error message';

      await tester.pumpWidget(
          createWidgetTree(child: const ErrorScreen(error: errorMessage)));

      await tester.pump();

      // Verify that the error message is displayed
      expect(find.text('Error: $errorMessage'), findsOneWidget);
      // Verify that the widget tree structure is correct
      expect(find.byType(Column), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
