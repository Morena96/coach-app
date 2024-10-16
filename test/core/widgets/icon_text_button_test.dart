import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/widgets/icon_text_button.dart';

void main() {
  setUpAll(() {
    // This registers a fake implementation of a method channel to allow asset loading in tests
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('IconTextButton displays label', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: IconTextButton(
          label: 'Test Button',
          onPressed: () {},
        ),
      ),
    );

    expect(find.text('Test Button'), findsOneWidget);
  });

  testWidgets('IconTextButton calls onPressed when tapped',
      (WidgetTester tester) async {
    bool wasPressed = false;
    await tester.pumpWidget(
      MaterialApp(
        home: IconTextButton(
          label: 'Test Button',
          onPressed: () {
            wasPressed = true;
          },
        ),
      ),
    );

    await tester.tap(find.byType(IconTextButton));
    expect(wasPressed, isTrue);
  });

  testWidgets('IconTextButton displays icon when iconPath is provided',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: IconTextButton(
          label: 'Test Button',
          iconPath: 'assets/icons/upload.svg',
          onPressed: () {},
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('IconTextButton does not display icon when iconPath is null',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: IconTextButton(
          label: 'Test Button',
          onPressed: () {},
        ),
      ),
    );

    expect(find.byType(SvgPicture), findsNothing);
  });

  testWidgets('IconTextButton applies custom color',
      (WidgetTester tester) async {
    const customColor = Colors.red;
    await tester.pumpWidget(
      MaterialApp(
        home: IconTextButton(
          label: 'Test Button',
          color: customColor,
          onPressed: () {},
        ),
      ),
    );

    final textWidget = tester.widget<Text>(find.byType(Text));
    expect(textWidget.style?.color, equals(customColor));
  });

  testWidgets('IconTextButton applies color to icon',
      (WidgetTester tester) async {
    const customColor = Colors.blue;
    await tester.pumpWidget(
      MaterialApp(
        home: IconTextButton(
          label: 'Test Button',
          iconPath: 'assets/icons/upload.svg',
          color: customColor,
          onPressed: () {},
        ),
      ),
    );

    final svgPicture = tester.widget<SvgPicture>(find.byType(SvgPicture));
    expect(svgPicture.colorFilter, isNotNull);
  });
}
