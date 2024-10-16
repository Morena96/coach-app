import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/features/other/not_found_screen.dart';

import '../../widget_tree.dart';

void main() {
  group('NotFoundScreen', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        createWidgetTree(child: const NotFoundScreen()),
      );

      // Verify that the NotFoundScreen is rendered.
      expect(find.byType(NotFoundScreen), findsOneWidget);

      // Verify that the Scaffold is present.
      expect(find.byType(Scaffold), findsWidgets);

      // Verify that the Center widget is present.
      expect(find.byType(Center), findsOneWidget);

      // Verify that the Text widget is present with the correct text.
      expect(find.text('404 - Screen Not Found Found'), findsOneWidget);

      // Verify that the text style is correct.
      final Text textWidget =
          tester.widget(find.text('404 - Screen Not Found Found'));
      expect(textWidget.style, isA<TextStyle>());
      expect(textWidget.style!.fontSize, isNotNull);
    });
  });
}
