import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/widgets/arrow_tooltip.dart';

void main() {
  testWidgets('ArrowTooltip displays child widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArrowTooltip(
            tooltipText: 'Test Tooltip',
            child: Text('Click me'),
          ),
        ),
      ),
    );

    expect(find.text('Click me'), findsOneWidget);
  });

  testWidgets('ArrowTooltip displays tooltip text when clicked',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ArrowTooltip(
            tooltipText: 'Test Tooltip',
            child: Text('Click me'),
          ),
        ),
      ),
    );

    // Initially, the tooltip should not be visible
    expect(find.text('Test Tooltip'), findsNothing);

    // Click on the child widget
    await tester.tap(find.text('Click me'));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Now the tooltip should be visible
    expect(find.text('Test Tooltip'), findsOneWidget);
  });

  testWidgets('ArrowTooltip displays custom widget when provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArrowTooltip(
            tooltipWidget: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue,
              child: const Text('Custom Tooltip'),
            ),
            child: const Text('Click me'),
          ),
        ),
      ),
    );

    // Click on the child widget
    await tester.tap(find.text('Click me'));
    await tester.pumpAndSettle(); // Wait for animations to complete

    // Check if the custom tooltip widget is displayed
    expect(find.text('Custom Tooltip'), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('ArrowTooltip onInit callback is called',
      (WidgetTester tester) async {
    bool showCalled = false;
    bool hideCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArrowTooltip(
            tooltipText: 'Test Tooltip',
            onInit: (show, hide) {
              showCalled = true;
              hideCalled = true;
            },
            child: const Text('Click me'),
          ),
        ),
      ),
    );

    // Verify that the onInit callback was called
    expect(showCalled, isTrue);
    expect(hideCalled, isTrue);
  });

  testWidgets('ArrowTooltip can be shown and hidden programmatically',
      (WidgetTester tester) async {
    late Function showTooltip;
    late Function hideTooltip;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArrowTooltip(
            tooltipText: 'Test Tooltip',
            onInit: (show, hide) {
              showTooltip = show;
              hideTooltip = hide;
            },
            child: const Text('Click me'),
          ),
        ),
      ),
    );

    // Initially, the tooltip should not be visible
    expect(find.text('Test Tooltip'), findsNothing);

    // Show the tooltip programmatically
    showTooltip();
    await tester.pumpAndSettle();
    expect(find.text('Test Tooltip'), findsOneWidget);

    // Hide the tooltip programmatically
    hideTooltip();
    await tester.pumpAndSettle();
    expect(find.text('Test Tooltip'), findsNothing);
  });
}
