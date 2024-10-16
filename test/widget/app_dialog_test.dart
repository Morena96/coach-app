import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/widgets/app_dialog.dart';

void main() {
  testWidgets('AppDialog displays title, content, and actions',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDialog(
            title: 'Test Dialog',
            actions: [
              ElevatedButton(onPressed: () {}, child: const Text('Action 1')),
              ElevatedButton(onPressed: () {}, child: const Text('Action 2')),
            ],
            content: const Text('Dialog content'),
          ),
        ),
      ),
    );

    // Verify that the dialog title is displayed
    expect(find.text('Test Dialog'), findsOneWidget);

    // Verify that the dialog content is displayed
    expect(find.text('Dialog content'), findsOneWidget);

    // Verify that both action buttons are present
    expect(find.text('Action 1'), findsOneWidget);
    expect(find.text('Action 2'), findsOneWidget);

    // Verify that there are two ElevatedButtons
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });

  testWidgets('AppDialog close button dismisses the dialog',
      (WidgetTester tester) async {
    bool dialogDismissed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AppDialog(
                      title: 'Test Dialog',
                      actions: [
                        ElevatedButton(
                            onPressed: () {}, child: const Text('Action')),
                      ],
                      content: const Text('Dialog content'),
                    ),
                  ).then((_) => dialogDismissed = true);
                },
                child: const Text('Show Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // Show the dialog
    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    // Verify that the dialog is displayed
    expect(find.byType(AppDialog), findsOneWidget);

    // Find and tap the close button
    final closeButton = find.byType(IconButton);
    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    // Verify that the dialog is dismissed
    expect(find.byType(AppDialog), findsNothing);
    expect(dialogDismissed, isTrue);
  });

  testWidgets('AppDialog actions span full width', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppDialog(
            title: 'Test Dialog',
            actions: [
              ElevatedButton(
                  onPressed: () {}, child: const Text('Full Width Action')),
            ],
            content: const Text('Dialog content'),
          ),
        ),
      ),
    );

    // Find the SizedBox wrapping the action button
    final sizedBox = find.ancestor(
      of: find.byType(ElevatedButton),
      matching: find.byType(SizedBox),
    );

    // Verify that the SizedBox has width set to double.infinity
    expect(tester.widget<SizedBox>(sizedBox).width, equals(double.infinity));
  });
}
