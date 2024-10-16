import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/widgets/layout/app_layout.dart';
import 'package:coach_app/core/widgets/layout/custom_app_bar.dart';
import 'package:coach_app/core/widgets/layout/navbar.dart';
import 'package:coach_app/shared/constants/app_constants.dart';
import 'package:coach_app/shared/providers/navbar_state_provider.dart';

import '../../widget_tree.dart';

void main() {
  Widget createTestWidget({required Widget child}) {
    return ProviderScope(
      overrides: [
        navbarStateProvider.overrideWith(
            (ref) => NavbarState(expanded: true, selectedItem: 'dashboard')),
      ],
      child: createWidgetTree(
        child: child,
      ),
    );
  }

  testWidgets('AppLayout renders child widget', (WidgetTester tester) async {
    final child = Container(key: const Key('child'));

    await tester.pumpWidget(
      createTestWidget(
        child: AppLayout(child: child),
      ),
    );

    expect(find.byKey(const Key('child')), findsOneWidget);
  });

  testWidgets('AppLayout renders sidebar for non-mobile devices',
      (WidgetTester tester) async {
    // Set up a custom MediaQuery to simulate a non-mobile device
    const mediaQueryData = MediaQueryData(size: Size(1000, 800)); // width > 600

    await tester.pumpWidget(
      MediaQuery(
        data: mediaQueryData,
        child: createTestWidget(
          child: AppLayout(child: Container()),
        ),
      ),
    );

    expect(find.byType(NavBar), findsOneWidget);
    expect(find.byKey(const ValueKey('desktop_navbar')), findsOneWidget);
    expect(find.byKey(const ValueKey('mobile_navbar')), findsNothing);
  });

  testWidgets('AppLayout does not render sidebar for mobile devices',
      (WidgetTester tester) async {
    // Set up a custom MediaQuery to simulate a mobile device
    const mediaQueryData = MediaQueryData(size: Size(599, 800)); // width < 600

    await tester.pumpWidget(
      MediaQuery(
        data: mediaQueryData,
        child: createTestWidget(
          child: AppLayout(child: Container()),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('desktop_navbar')), findsNothing);
    expect(find.byKey(const ValueKey('mobile_navbar')), findsOneWidget);
  });

  testWidgets('AppLayout adjusts sidebar width based on expanded state',
      (WidgetTester tester) async {
    // Set up a custom MediaQuery to simulate a non-mobile device
    const mediaQueryData = MediaQueryData(size: Size(1000, 800)); // width > 600

    await tester.pumpWidget(
      MediaQuery(
        data: mediaQueryData,
        child: createTestWidget(
          child: AppLayout(child: Container()),
        ),
      ),
    );

    final expandedContainer = find.byKey(const ValueKey('desktop_navbar'));
    expect(expandedContainer, findsWidgets);

    final containerWidget = tester.widget<AnimatedContainer>(expandedContainer);
    expect(containerWidget.constraints!.maxWidth,
        equals(AppConstants.sidebarExpandedWidth));
  });

  testWidgets('AppLayout renders CustomAppBar', (WidgetTester tester) async {
    await tester.pumpWidget(
      createTestWidget(
        child: AppLayout(child: Container()),
      ),
    );

    expect(find.byType(CustomAppBar), findsOneWidget);
  });
}
