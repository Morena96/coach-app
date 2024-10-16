import 'package:coach_app/core/widgets/app_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../widget_tree.dart';

void main() {
  group('AppTabs', () {
    testWidgets('renders correct number of tabs', (WidgetTester tester) async {
      final tabs = ['Tab 1', 'Tab 2', 'Tab 3'];
      final tabContents = [
        const Center(child: Text('Content 1')),
        const Center(child: Text('Content 2')),
        const Center(child: Text('Content 3')),
      ];

      await tester.pumpWidget(createWidgetTree(
        child: AppTabs(tabs: tabs, tabContents: tabContents),
      ));

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('shows correct content for selected tab',
        (WidgetTester tester) async {
      final tabs = ['Tab 1', 'Tab 2'];
      final tabContents = [
        const Center(child: Text('Content 1')),
        const Center(child: Text('Content 2')),
      ];

      await tester.pumpWidget(createWidgetTree(
        child: AppTabs(tabs: tabs, tabContents: tabContents),
      ));

      expect(find.text('Content 1'), findsOneWidget);
      expect(find.text('Content 2'), findsNothing);

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.text('Content 1'), findsNothing);
      expect(find.text('Content 2'), findsOneWidget);
    });

    testWidgets('applies correct styling', (WidgetTester tester) async {
      final tabs = ['Tab 1', 'Tab 2'];
      final tabContents = [
        const Center(child: Text('Content 1')),
        const Center(child: Text('Content 2')),
      ];

      await tester.pumpWidget(createWidgetTree(
        child: AppTabs(tabs: tabs, tabContents: tabContents),
      ));

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.isScrollable, isTrue);
      expect(tabBar.indicator, isA<BoxDecoration>());

      final container = tester.widget<Container>(find
          .ancestor(
            of: find.byType(TabBar),
            matching: find.byType(Container),
          )
          .first);
      expect(container.decoration, isA<BoxDecoration>());
    });

    testWidgets('respects isScrollable parameter', (WidgetTester tester) async {
      final tabs = ['Tab 1', 'Tab 2'];
      final tabContents = [
        const Center(child: Text('Content 1')),
        const Center(child: Text('Content 2')),
      ];

      await tester.pumpWidget(createWidgetTree(
        child: SizedBox(
          width: 300,
          height: 100,
          child: AppTabs(tabs: tabs, tabContents: tabContents),
        ),
      ));

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.isScrollable, isTrue);
    });

    testWidgets('throws assertion error when tabs and contents length mismatch',
        (WidgetTester tester) async {
      final tabs = ['Tab 1', 'Tab 2'];
      final tabContents = [
        const Center(child: Text('Content 1')),
      ];

      expect(
        () => AppTabs(tabs: tabs, tabContents: tabContents),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
