import 'dart:ui';

import 'package:coach_app/core/router/navbar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/widgets/layout/navbar.dart';
import 'package:coach_app/core/widgets/layout/navbar_item_tile.dart';
import 'package:coach_app/core/widgets/layout/navbar_logo.dart';
import 'package:coach_app/shared/providers/navbar_state_provider.dart';

import '../../test_helper.dart';
import '../../widget_tree.dart';

void main() {
  Widget createWidgetUnderTest(NavbarState state) {
    return ProviderScope(
      overrides: [
        navbarStateProvider.overrideWith((ref) => state),
      ],
      child: createWidgetTree(
        child: const NavBar(),
      ),
    );
  }

  group('NavBar Widget Tests', () {
    testWidgets('NavBar displays correct layout when expanded',
        (WidgetTester tester) async {
      final navbarState =
          NavbarState(expanded: true, selectedItem: NavbarItem.dashboard.id);
      await tester.pumpWidget(createWidgetUnderTest(navbarState));
      await tester.pumpAndSettle();

      expect(find.byType(NavbarLogo), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(NavbarItemTile), findsWidgets);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);

      // Verify expanded state
      _verifyExpanded(tester, isExpanded: true);
    });

    testWidgets('NavBar displays correct layout when collapsed',
        (WidgetTester tester) async {
      final navbarState =
          NavbarState(expanded: false, selectedItem: NavbarItem.dashboard.id);

      await tester.pumpWidget(createWidgetUnderTest(navbarState));
      await tester.pumpAndSettle();

      expect(find.byType(NavbarLogo), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(NavbarItemTile), findsWidgets);
      expect(find.byType(IconButton), findsOneWidget);
      expect(find.text('Overview'), findsOneWidget);

      // Verify collapsed state
      _verifyExpanded(tester, isExpanded: false);
    });

    testWidgets('NavBar expands and collapses when button is tapped',
        (WidgetTester tester) async {
      final initialState = NavbarState(
          expanded: false, selectedItem: NavbarItem.values.first.id);

      await tester.pumpWidget(createWidgetUnderTest(initialState));
      await tester.pumpAndSettle();

      // Initial state: collapsed
      _verifyExpanded(tester, isExpanded: false);

      // Tap to expand
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      _verifyExpanded(tester, isExpanded: true);

      // Tap to collapse
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      _verifyExpanded(tester, isExpanded: false);
    });
  });

  group('NavbarLogo Widget Tests', () {
    testWidgets('NavbarLogo displays correctly when expanded',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetTree(
          child: const NavbarLogo(isExpanded: true),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
      TestHelper.expectRichTextWithText(tester, 'FIYRPOD');

      final paddingWidget = tester.widget<Padding>(find.ancestor(
          of: find.byType(SvgPicture), matching: find.byType(Padding)));
      expect(paddingWidget.padding, equals(const EdgeInsets.only(left: 40)));
    });

    testWidgets('NavbarLogo displays correctly when collapsed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createWidgetTree(
          child: const NavbarLogo(isExpanded: false),
        ),
      );

      expect(find.byType(SvgPicture), findsOneWidget);
      TestHelper.expectRichTextWithText(tester, 'FIYRPOD');

      final paddingWidget = tester.widget<Padding>(find.ancestor(
          of: find.byType(SvgPicture), matching: find.byType(Padding)));
      expect(paddingWidget.padding, equals(const EdgeInsets.only(left: 20)));
    });
  });

  group('NavbarItemTile Widget Tests', () {
    Widget createWidgetUnderTest(NavbarState state, NavbarItem item) {
      return ProviderScope(
        overrides: [
          navbarStateProvider.overrideWith((ref) => state),
        ],
        child: createWidgetTree(
          child: NavbarItemTile(
            item: item,
            navbarState: state,
          ),
        ),
      );
    }

    testWidgets('NavbarItemTile displays correctly when expanded and selected',
        (WidgetTester tester) async {
      final state =
          NavbarState(expanded: true, selectedItem: NavbarItem.dashboard.id);
      await tester
          .pumpWidget(createWidgetUnderTest(state, NavbarItem.dashboard));

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.color, equals(AppColors.primaryGreen.withOpacity(.14)));
    });

    testWidgets(
        'NavbarItemTile displays correctly when expanded and not selected',
        (WidgetTester tester) async {
      final state =
          NavbarState(expanded: true, selectedItem: NavbarItem.dashboard.id);
      await tester
          .pumpWidget(createWidgetUnderTest(state, NavbarItem.dashboard));

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('NavbarItemTile displays correctly when collapsed',
        (WidgetTester tester) async {
      final state =
          NavbarState(expanded: false, selectedItem: NavbarItem.dashboard.id);
      await tester
          .pumpWidget(createWidgetUnderTest(state, NavbarItem.dashboard));

      expect(find.text('Dashboard'), findsNothing);
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('NavbarItemTile responds to hover',
        (WidgetTester tester) async {
      final state =
          NavbarState(expanded: true, selectedItem: NavbarItem.dashboard.id);
      await tester
          .pumpWidget(createWidgetUnderTest(state, NavbarItem.dashboard));

      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(NavbarItemTile)));
      await tester.pumpAndSettle();

      final text = tester.widget<Text>(find.text('Dashboard'));
      expect(
          text.style?.color,
          equals(Theme.of(tester.element(find.byType(NavbarItemTile)))
              .colorScheme
              .onSurface));
    });
  });
}

void _verifyExpanded(WidgetTester tester, {required bool isExpanded}) {
  expect(
    tester.widget(find.byType(AnimatedAlign).first),
    isA<AnimatedAlign>().having(
      (t) => t.alignment,
      'alignment',
      isExpanded ? Alignment.centerLeft : Alignment.center,
    ),
  );
}
