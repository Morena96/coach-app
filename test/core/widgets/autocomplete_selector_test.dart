import 'package:coach_app/core/widgets/autocomplete_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';

import '../../widget_tree.dart';

// This will generate the mock classes
@GenerateMocks([])
void main() {
  group('AutocompleteSelector', () {
    late StateNotifierProvider<TestNotifier, AsyncValue<List<String>>>
        testProvider;

    setUp(() {
      testProvider =
          StateNotifierProvider<TestNotifier, AsyncValue<List<String>>>(
        (ref) => TestNotifier(),
      );
    });

    testWidgets('renders correctly with initial state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: createWidgetTree(
            child: AutocompleteSelector<String>(
              onItemSelected: (_) {},
              itemsProvider: testProvider,
              labelBuilder: (item) => item,
              filterOption: (item, query) =>
                  item.toLowerCase().contains(query.toLowerCase()),
              selectedItems: const [],
              hintText: 'Test hint',
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Test hint'), findsOneWidget);
    });

    testWidgets('shows options when typing', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: createWidgetTree(
            child: AutocompleteSelector<String>(
              onItemSelected: (_) {},
              itemsProvider: testProvider,
              labelBuilder: (item) => item,
              filterOption: (item, query) =>
                  item.toLowerCase().contains(query.toLowerCase()),
              selectedItems: const [],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'ap');
      await tester.pump();

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('calls onItemSelected when an option is tapped',
        (WidgetTester tester) async {
      String? selectedItem;
      await tester.pumpWidget(
        ProviderScope(
          child: createWidgetTree(
            child: AutocompleteSelector<String>(
              onItemSelected: (item) => selectedItem = item,
              itemsProvider: testProvider,
              labelBuilder: (item) => item,
              filterOption: (item, query) =>
                  item.toLowerCase().contains(query.toLowerCase()),
              selectedItems: const [],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();
      await tester.tap(find.text('Apple'));
      await tester.pump();

      expect(selectedItem, 'Apple');
    });

    testWidgets('clears field after selection', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: createWidgetTree(
            child: AutocompleteSelector<String>(
              onItemSelected: (_) {},
              itemsProvider: testProvider,
              labelBuilder: (item) => item,
              filterOption: (item, query) =>
                  item.toLowerCase().contains(query.toLowerCase()),
              selectedItems: const [],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();
      await tester.tap(find.text('Apple'));
      await tester.pump();

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('shows clear button when text is entered',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: createWidgetTree(
            child: AutocompleteSelector<String>(
              onItemSelected: (_) {},
              itemsProvider: testProvider,
              labelBuilder: (item) => item,
              filterOption: (item, query) =>
                  item.toLowerCase().contains(query.toLowerCase()),
              selectedItems: const [],
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('clears text when clear button is tapped',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: createWidgetTree(
            child: AutocompleteSelector<String>(
              onItemSelected: (_) {},
              itemsProvider: testProvider,
              labelBuilder: (item) => item,
              filterOption: (item, query) =>
                  item.toLowerCase().contains(query.toLowerCase()),
              selectedItems: const [],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();
      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      expect(
          (tester.widget(find.byType(TextFormField)) as TextFormField)
              .controller
              ?.text,
          '');
    });

    testWidgets('does not show selected items in options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: createWidgetTree(
            child: AutocompleteSelector<String>(
              onItemSelected: (_) {},
              itemsProvider: testProvider,
              labelBuilder: (item) => item,
              filterOption: (item, query) =>
                  item.toLowerCase().contains(query.toLowerCase()),
              selectedItems: const ['Apple'],
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'a');
      await tester.pump();

      expect(find.text('Apple'), findsNothing);
      expect(find.text('Banana'), findsOneWidget);
    });
  });
}

class TestNotifier extends StateNotifier<AsyncValue<List<String>>> {
  TestNotifier() : super(const AsyncValue.data(['Apple', 'Banana', 'Cherry']));
}
