import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/core/widgets/screens/loading_screen.dart';

void main() {
  group('LoadingScreen', () {
    testWidgets('displays circular progress indicator', (WidgetTester tester) async {
      await tester.pumpWidget(const LoadingScreen());

      // Verify that the widget tree structure is correct
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify that only one CircularProgressIndicator is present
      expect(find.byType(CircularProgressIndicator), findsNWidgets(1));

      // Verify that no other widgets are present
      expect(find.byType(Text), findsNothing);
    });
  });
}
