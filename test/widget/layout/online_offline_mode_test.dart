import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/core/app_state.dart';
import 'package:coach_app/core/widgets/arrow_tooltip.dart';
import 'package:coach_app/core/widgets/layout/online_offline_mode.dart';

import '../../mocks.mocks.dart';
import '../../widget_tree.dart';

void main() {
  late MockAppState mockAppState;
  late MockAppStateNotifier mockAppStateNotifier;

  setUp(() {
    mockAppState = MockAppState();
    mockAppStateNotifier = MockAppStateNotifier();

    // Stub the addListener method
    when(mockAppStateNotifier.addListener(any,
            fireImmediately: anyNamed('fireImmediately')))
        .thenAnswer((invocation) {
      final listener =
          invocation.positionalArguments[0] as void Function(AppState);
      final fireImmediately =
          invocation.namedArguments[#fireImmediately] as bool;
      if (fireImmediately) {
        listener(mockAppState);
      }
      return () {}; // Return a remove listener function
    });

    // Stub the state getter
    when(mockAppStateNotifier.state).thenReturn(mockAppState);
  });

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        appStateProvider.overrideWith((ref) => mockAppStateNotifier),
      ],
      child: createWidgetTree(
        child: OnlineOfflineMode(),
      ),
    );
  }

  testWidgets('OnlineOfflineMode displays correct UI for online mode',
      (WidgetTester tester) async {
    when(mockAppState.isConnected).thenReturn(true);

    await tester.pumpWidget(createWidgetUnderTest());

    // Rebuild the widget tree and wait for any animations
    await tester.pump();
    await tester.pumpAndSettle();

    // Debug: Find the OnlineOfflineMode widget
    final onlineOfflineModeWidget = find.byType(OnlineOfflineMode);
    expect(onlineOfflineModeWidget, findsOneWidget,
        reason: 'OnlineOfflineMode widget not found');

    // Try to find the text with more flexible matchers
    final onlineModeText = find.text('Online Mode', findRichText: true);

    expect(onlineModeText, findsOneWidget,
        reason: 'Online Mode text not found');
    expect(find.byType(SvgPicture), findsNWidgets(2),
        reason: 'Expected 2 SvgPicture widgets');
  });

  testWidgets('OnlineOfflineMode displays correct UI for offline mode',
      (WidgetTester tester) async {
    when(mockAppStateNotifier.state).thenReturn(mockAppState);
    when(mockAppState.isConnected).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Offline Mode'), findsOneWidget);
    expect(find.byType(SvgPicture),
        findsNWidgets(2)); // One for status icon, one for tooltip
  });

  testWidgets('OnlineOfflineMode tooltip shows correct text for online mode',
      (WidgetTester tester) async {
    when(mockAppStateNotifier.state).thenReturn(mockAppState);
    when(mockAppState.isConnected).thenReturn(true);

    await tester.pumpWidget(createWidgetUnderTest());

    // Tap the tooltip icon
    await tester.tap(find.byType(ArrowTooltip));
    await tester.pump();

    expect(
        find.text(
            'Your data is up to date and in sync\nwith the latest updates.'),
        findsOneWidget);
  });

  testWidgets('OnlineOfflineMode tooltip shows correct text for offline mode',
      (WidgetTester tester) async {
    when(mockAppStateNotifier.state).thenReturn(mockAppState);
    when(mockAppState.isConnected).thenReturn(false);

    await tester.pumpWidget(createWidgetUnderTest());

    // Tap the tooltip icon
    await tester.tap(find.byType(ArrowTooltip));
    await tester.pump();

    expect(
        find.text(
            'Monitor your athletes\' sessions offline.\nAll updates will sync automatically when\nyou reconnect to the internet.'),
        findsOneWidget);
  });
}
