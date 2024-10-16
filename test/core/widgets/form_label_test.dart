import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/form_label.dart';

void main() {
  group('FormLabel', () {
    testWidgets('renders label and child correctly',
        (WidgetTester tester) async {
      const labelText = 'Test Label';
      const childText = 'Child Widget';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FormLabel(
              label: labelText,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Check if the label is rendered
      expect(find.text(labelText), findsOneWidget);

      // Check if the child is rendered
      expect(find.text(childText), findsOneWidget);
    });

    testWidgets('applies correct text style to label',
        (WidgetTester tester) async {
      const labelText = 'Test Label';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormLabel(
              label: labelText,
              child: Container(),
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text(labelText));
      expect(textWidget.style, AppTextStyle.primary16r);
    });

    testWidgets('maintains correct layout', (WidgetTester tester) async {
      const labelText = 'Test Label';
      const childText = 'Child Widget';

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FormLabel(
              label: labelText,
              child: Text(childText),
            ),
          ),
        ),
      );

      // Check if the widget uses a Column
      expect(find.byType(Column), findsOneWidget);

      // Check if the Column has the correct crossAxisAlignment
      final column = tester.widget<Column>(find.byType(Column));
      expect(column.crossAxisAlignment, CrossAxisAlignment.start);

      // Check if there's a SizedBox with correct height between label and child
      expect(find.byType(SizedBox), findsOneWidget);
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, 6);

      // Check the order of widgets: Text (label), SizedBox, Text (child)
      final columnChildren = column.children;
      expect(columnChildren[0], isA<Text>());
      expect(columnChildren[1], isA<SizedBox>());
      expect(columnChildren[2], isA<Text>());
    });

    testWidgets('works with various child widgets',
        (WidgetTester tester) async {
      const labelText = 'Test Label';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormLabel(
              label: labelText,
              child: TextFormField(),
            ),
          ),
        ),
      );

      expect(find.text(labelText), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });
  });
}
