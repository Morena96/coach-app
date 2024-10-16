import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/widgets/square_icon_button.dart';

import '../../widget_tree.dart';

void main() {
  group('SquareIconButton', () {
    const iconPath = 'assets/icons/add.svg';
    const size = 48.0;

    testWidgets('renders correctly with default properties',
        (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetTree(
        child: SquareIconButton(
          iconPath: iconPath,
          onPressed: () {},
          size: size,
        ),
      ));

      final buttonFinder = find.byType(ElevatedButton);
      expect(buttonFinder, findsOneWidget);

      final button = tester.widget<ElevatedButton>(buttonFinder);
      expect(
          button.style?.backgroundColor?.resolve({}), AppColors.primaryGreen);
      expect(button.style?.foregroundColor?.resolve({}), AppColors.black);

      final svgFinder = find.byType(SvgPicture);
      expect(svgFinder, findsOneWidget);

      final svg = tester.widget<SvgPicture>(svgFinder);
      expect(svg.width, size * 0.5);
    });

    testWidgets('applies custom colors', (WidgetTester tester) async {
      const customBackgroundColor = Colors.red;
      const customIconColor = Colors.white;

      await tester.pumpWidget(createWidgetTree(
        child: SquareIconButton(
          iconPath: iconPath,
          onPressed: () {},
          size: size,
          backgroundColor: customBackgroundColor,
          iconColor: customIconColor,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.style?.backgroundColor?.resolve({}), customBackgroundColor);
      expect(button.style?.foregroundColor?.resolve({}), customIconColor);

      final svg = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(svg.colorFilter,
          const ColorFilter.mode(customIconColor, BlendMode.srcIn));
    });

    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      bool wasCalled = false;
      await tester.pumpWidget(createWidgetTree(
        child: SquareIconButton(
          iconPath: iconPath,
          onPressed: () => wasCalled = true,
          size: size,
        ),
      ));

      await tester.tap(find.byType(ElevatedButton));
      expect(wasCalled, isTrue);
    });

    testWidgets('has correct border radius', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetTree(
        child: SquareIconButton(
          iconPath: iconPath,
          onPressed: () {},
          size: size,
        ),
      ));

      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      final shape = button.style?.shape?.resolve({}) as RoundedRectangleBorder?;
      expect(shape?.borderRadius, BorderRadius.circular(6));
    });
  });
}
