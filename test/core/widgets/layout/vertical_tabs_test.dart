import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:coach_app/core/widgets/layout/vertical_tabs.dart';

// This will generate the mock classes
@GenerateMocks([])
void main() {
  group('VerticalTab', () {
    test('should create a VerticalTab with required parameters', () {
      final tab = VerticalTab(
        title: 'Test Tab',
        content: const Text('Test Content'),
      );

      expect(tab.title, 'Test Tab');
      expect(tab.content, isA<Text>());
      expect(tab.iconPath, isNull);
      expect(tab.paintIcon, isFalse);
    });

    test('should create a VerticalTab with all parameters', () {
      final tab = VerticalTab(
        title: 'Test Tab',
        content: const Text('Test Content'),
        iconPath: 'assets/icon.svg',
        paintIcon: true,
      );

      expect(tab.title, 'Test Tab');
      expect(tab.content, isA<Text>());
      expect(tab.iconPath, 'assets/icon.svg');
      expect(tab.paintIcon, isTrue);
    });
  });

  group('VerticalTabItem', () {
    testWidgets('should render correctly when not selected',
        (WidgetTester tester) async {
      final tab = VerticalTab(
        title: 'Test Tab',
        content: const Text('Test Content'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalTabItem(
              tab: tab,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Tab'), findsOneWidget);
      expect(find.byType(SvgPicture), findsNothing);
    });
  });

  group('VerticalTabs', () {
    testWidgets('should render desktop layout for large screen',
        (WidgetTester tester) async {
      final tabs = [
        VerticalTab(title: 'Tab 1', content: const Text('Content 1')),
        VerticalTab(title: 'Tab 2', content: const Text('Content 2')),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000, // Simulating a large screen
              child: VerticalTabs(tabs: tabs),
            ),
          ),
        ),
      );

      expect(find.byType(VerticalTabItem), findsNWidgets(2));
      expect(find.text('Tab 1'), findsNWidgets(2));
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('should render mobile layout for small screen',
        (WidgetTester tester) async {
      final tabs = [
        VerticalTab(title: 'Tab 1', content: const Text('Content 1')),
        VerticalTab(title: 'Tab 2', content: const Text('Content 2')),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 500, // Simulating a small screen
              child: VerticalTabs(tabs: tabs),
            ),
          ),
        ),
      );

      expect(find.byType(ExpansionTile), findsNWidgets(2));
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);

      // Expand the first tab
      await tester.tap(find.text('Tab 1'));
      await tester.pumpAndSettle();
      expect(find.text('Content 1'), findsOneWidget);
    });

    testWidgets('should change selected tab on desktop layout',
        (WidgetTester tester) async {
      final tabs = [
        VerticalTab(title: 'Tab 1', content: const Text('Content 1')),
        VerticalTab(title: 'Tab 2', content: const Text('Content 2')),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000, // Simulating a large screen
              child: VerticalTabs(tabs: tabs),
            ),
          ),
        ),
      );

      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Content 2'), findsOneWidget);
    });
  });
}
