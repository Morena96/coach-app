import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/features/settings/presentation/widgets/settings_theme_mode_selector.dart';
import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  group('SettingsThemeModeSelector', () {
    testWidgets('displays all theme mode options', (WidgetTester tester) async {
      ThemeMode selectedMode = ThemeMode.system;

      await tester.pumpWidget(createTestableWidget(
        SettingsThemeModeSelector(
          selectedMode: selectedMode,
          onModeChanged: (ThemeMode mode) {
            selectedMode = mode;
          },
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('displays correct labels for each mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        SettingsThemeModeSelector(
          selectedMode: ThemeMode.system,
          onModeChanged: (ThemeMode mode) {},
        ),
      ));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(SettingsThemeModeSelector));

      expect(find.text(AppLocalizations.of(context)!.system), findsOneWidget);
      expect(find.text(AppLocalizations.of(context)!.light), findsOneWidget);
      expect(find.text(AppLocalizations.of(context)!.dark), findsOneWidget);
    });

    testWidgets('highlights selected mode', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        SettingsThemeModeSelector(
          selectedMode: ThemeMode.light,
          onModeChanged: (ThemeMode mode) {},
        ),
      ));
      await tester.pumpAndSettle();

      final selectedSegment = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>),
      );

      expect(selectedSegment.selected, equals({ThemeMode.light}));
    });

    testWidgets('calls onModeChanged when a new mode is selected',
        (WidgetTester tester) async {
      ThemeMode selectedMode = ThemeMode.system;

      await tester.pumpWidget(createTestableWidget(
        SettingsThemeModeSelector(
          selectedMode: selectedMode,
          onModeChanged: (ThemeMode mode) {
            selectedMode = mode;
          },
        ),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.light_mode));
      await tester.pumpAndSettle();

      expect(selectedMode, equals(ThemeMode.light));
    });

    testWidgets('has correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        SettingsThemeModeSelector(
          selectedMode: ThemeMode.system,
          onModeChanged: (ThemeMode mode) {},
        ),
      ));
      await tester.pumpAndSettle();

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isA<BoxDecoration>());
      final boxDecoration = container.decoration as BoxDecoration;
      expect(boxDecoration.borderRadius, equals(BorderRadius.circular(8)));

      final segmentedButton = tester.widget<SegmentedButton<ThemeMode>>(
        find.byType(SegmentedButton<ThemeMode>),
      );
      expect(
          segmentedButton.style!.backgroundColor!
              .resolve({WidgetState.selected}),
          equals(AppColors.primaryGreen));
      expect(
          segmentedButton.style!.side!.resolve({})!, equals(BorderSide.none));
      expect(segmentedButton.style!.shape!.resolve({})!,
          isA<RoundedRectangleBorder>());
    });

    testWidgets('segments have correct text style',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(
        SettingsThemeModeSelector(
          selectedMode: ThemeMode.system,
          onModeChanged: (ThemeMode mode) {},
        ),
      ));
      await tester.pumpAndSettle();

      final textWidgets = tester.widgetList<Text>(find.byType(Text));
      for (final textWidget in textWidgets) {
        expect(textWidget.style, equals(AppTextStyle.primary14r));
      }
    });
  });
}
