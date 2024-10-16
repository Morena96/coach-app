import 'package:coach_app/core/widgets/chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChipList', () {
    testWidgets('renders chips for each item', (WidgetTester tester) async {
      final items = ['Apple', 'Banana', 'Cherry'];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipList<String>(
              items: items,
              labelBuilder: (item) => item,
              onDeleted: (_) {},
            ),
          ),
        ),
      );

      for (final item in items) {
        expect(find.text(item), findsOneWidget);
      }
    });

    testWidgets('uses custom chip builder when provided',
        (WidgetTester tester) async {
      final items = ['Apple', 'Banana'];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipList<String>(
              items: items,
              labelBuilder: (item) => item,
              onDeleted: (_) {},
              chipBuilder: (context, item) => Container(
                key: Key(item),
                child: Text('Custom $item'),
              ),
            ),
          ),
        ),
      );

      for (final item in items) {
        expect(find.byKey(Key(item)), findsOneWidget);
        expect(find.text('Custom $item'), findsOneWidget);
      }
    });

    testWidgets('calls onDeleted when chip is deleted',
        (WidgetTester tester) async {
      final items = ['Apple', 'Banana'];
      String? deletedItem;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipList<String>(
              items: items,
              labelBuilder: (item) => item,
              onDeleted: (item) => deletedItem = item,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.close).first);
      expect(deletedItem, 'Apple');
    });

    testWidgets('uses custom delete icon when provided',
        (WidgetTester tester) async {
      final items = ['Apple'];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipList<String>(
              items: items,
              labelBuilder: (item) => item,
              onDeleted: (_) {},
              deleteIcon: const Icon(Icons.delete, key: Key('customDelete')),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('customDelete')), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('applies custom styles correctly', (WidgetTester tester) async {
      final items = ['Apple'];
      const customColor = Colors.red;
      const customBorderColor = Colors.blue;
      const customTextStyle = TextStyle(fontSize: 20, color: Colors.green);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipList<String>(
              items: items,
              labelBuilder: (item) => item,
              onDeleted: (_) {},
              chipBackgroundColor: customColor,
              chipBorderColor: customBorderColor,
              labelStyle: customTextStyle,
            ),
          ),
        ),
      );

      final chip = tester.widget<Chip>(find.byType(Chip));
      expect(chip.backgroundColor, customColor);
      expect(chip.side?.color, customBorderColor);

      final text = tester.widget<Text>(find.text('Apple'));
      expect(text.style, customTextStyle);
    });

    testWidgets('applies custom spacing correctly',
        (WidgetTester tester) async {
      final items = ['Apple', 'Banana', 'Cherry', 'Date'];
      const customSpacing = 20.0;
      const customRunSpacing = 30.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipList<String>(
              items: items,
              labelBuilder: (item) => item,
              onDeleted: (_) {},
              spacing: customSpacing,
              runSpacing: customRunSpacing,
            ),
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.spacing, customSpacing);
      expect(wrap.runSpacing, customRunSpacing);
    });

    testWidgets('renders empty widget when items list is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChipList<String>(
              items: const [],
              labelBuilder: (item) => item,
              onDeleted: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(Chip), findsNothing);
    });
  });
}
