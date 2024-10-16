import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/shared/constants/app_constants.dart';
import 'package:coach_app/shared/extensions/context.dart';

void main() {
  group('ContextX Extension Tests', () {
    testWidgets('isMobile returns true for small screen width',
        (WidgetTester tester) async {
      late bool isMobile;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
              size: Size(AppConstants.mobileBreakpoint - 1, 600)),
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                isMobile = context.isMobile;
                return Text(isMobile.toString());
              },
            ),
          ),
        ),
      );

      expect(isMobile, isTrue);
      expect(find.text('true'), findsOneWidget);
    });

    testWidgets('isMobile returns false for large screen width',
        (WidgetTester tester) async {
      late bool isMobile;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
              size: Size(AppConstants.mobileBreakpoint + 1, 600)),
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                isMobile = context.isMobile;
                return Text(isMobile.toString());
              },
            ),
          ),
        ),
      );

      expect(isMobile, isFalse);
      expect(find.text('false'), findsOneWidget);
    });

    testWidgets('color returns the current ColorScheme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(colorScheme: const ColorScheme.light()),
          home: Builder(
            builder: (BuildContext context) {
              return Text(context.color.primary.value.toString());
            },
          ),
        ),
      );

      expect(find.text(const ColorScheme.light().primary.value.toString()),
          findsOneWidget);
    });

    testWidgets('pagePadding returns correct padding for mobile',
        (WidgetTester tester) async {
      late EdgeInsets padding;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
              size: Size(AppConstants.mobileBreakpoint - 1, 600)),
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                padding = context.pagePadding();
                return Text(
                    '${padding.left},${padding.top},${padding.right},${padding.bottom}');
              },
            ),
          ),
        ),
      );

      expect(padding, const EdgeInsets.all(20));
      expect(find.text('20.0,20.0,20.0,20.0'), findsOneWidget);
    });

    testWidgets('pagePadding returns correct padding for desktop',
        (WidgetTester tester) async {
      late EdgeInsets padding;

      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(
              size: Size(AppConstants.mobileBreakpoint + 1, 600)),
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                padding = context.pagePadding();
                return Text(
                    '${padding.left},${padding.top},${padding.right},${padding.bottom}');
              },
            ),
          ),
        ),
      );

      expect(padding, const EdgeInsets.fromLTRB(40, 40, 60, 60));
      expect(find.text('40.0,40.0,60.0,60.0'), findsOneWidget);
    });
  });
}
