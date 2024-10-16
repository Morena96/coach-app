import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/widgets/layout/custom_app_bar.dart';
import 'package:coach_app/shared/providers/navbar_state_provider.dart';

import '../../widget_tree.dart';

void main() {
  Widget createTestWidget(
      {required Widget child, required MediaQueryData mediaQueryData}) {
    return MediaQuery(
      data: mediaQueryData,
      child: createWidgetTree(
        child: ProviderScope(
          overrides: [
            navbarStateProvider.overrideWith((ref) =>
                NavbarState(expanded: false, selectedItem: 'dashboard')),
          ],
          child: child,
        ),
      ),
    );
  }

  testWidgets('CustomAppBar renders correctly on mobile',
      (WidgetTester tester) async {
    // Set up a custom MediaQuery to simulate a mobile device
    const mediaQueryData = MediaQueryData(size: Size(599, 800)); // width < 600

    await tester.pumpWidget(
      createTestWidget(
        mediaQueryData: mediaQueryData,
        child: const Scaffold(appBar: CustomAppBar()),
      ),
    );

    // Check if menu icon is present
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Check if the title row is present
    expect(find.byType(Row), findsNWidgets(2));
  });

  testWidgets('CustomAppBar renders correctly on desktop',
      (WidgetTester tester) async {
    // Set up a custom MediaQuery to simulate a desktop device
    const mediaQueryData = MediaQueryData(size: Size(1000, 800)); // width > 600

    await tester.pumpWidget(
      createTestWidget(
        mediaQueryData: mediaQueryData,
        child: const Scaffold(appBar: CustomAppBar()),
      ),
    );

    // Check that menu icon is not present on desktop
    expect(find.byIcon(Icons.menu), findsNothing);

    // Check if the title row is present
    expect(find.byType(Row), findsNWidgets(2));
  });

  testWidgets('CustomAppBar toggles navbar state on mobile',
      (WidgetTester tester) async {
    // Set up a custom MediaQuery to simulate a mobile device
    const mediaQueryData = MediaQueryData(size: Size(599, 800)); // width < 600

    await tester.pumpWidget(
      createTestWidget(
        mediaQueryData: mediaQueryData,
        child: const Scaffold(appBar: CustomAppBar()),
      ),
    );

    // Initially, the menu should be collapsed (menu icon visible)
    expect(find.byIcon(Icons.menu), findsOneWidget);

    // Tap the menu icon
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pumpAndSettle();

    // After tapping, the close icon should be visible
    expect(find.byIcon(Icons.close), findsOneWidget);

    // Tap the close icon
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // After tapping close, the menu icon should be visible again
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });

  testWidgets('CustomAppBar has correct preferred size',
      (WidgetTester tester) async {
    const customAppBar = CustomAppBar();
    expect(customAppBar.preferredSize,
        equals(const Size.fromHeight(kToolbarHeight)));
  });
}
