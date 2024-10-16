import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:coach_app/features/settings/presentation/providers/settings_view_model.dart';
import 'package:coach_app/features/settings/presentation/widgets/settings_language_selector.dart';

import '../../fake_settings_view_model.dart';

void main() {
  late FakeSettingsViewModel fakeViewModel;

  setUp(() {
    fakeViewModel = FakeSettingsViewModel();
  });

  ProviderContainer createProviderContainer() {
    return ProviderContainer(
      overrides: [
        settingsViewModelProvider.overrideWith(() => fakeViewModel),
      ],
    );
  }

  Widget createTestableWidget(Widget child) {
    final container = createProviderContainer();
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('SettingsLanguageSelector displays correct initial language',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(createTestableWidget(const SettingsLanguageSelector()));
    await tester.pumpAndSettle();

    expect(
      find.text(AppLocalizations.of(
              tester.element(find.byType(SettingsLanguageSelector)))!
          .englishLanguage),
      findsOneWidget,
    );
  });

  testWidgets('SettingsLanguageSelector updates language when selected',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(createTestableWidget(const SettingsLanguageSelector()));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();

    await tester.tap(find
        .text(AppLocalizations.of(
                tester.element(find.byType(SettingsLanguageSelector)))!
            .spanishLanguage)
        .last);
    await tester.pumpAndSettle();

    expect(fakeViewModel.selectedLanguage, 'es');
  });

  testWidgets('SettingsLanguageSelector shows error message on error',
      (WidgetTester tester) async {
    fakeViewModel.setError('Test Error');

    await tester
        .pumpWidget(createTestableWidget(const SettingsLanguageSelector()));
    await tester.pumpAndSettle();

    expect(
      find.text(AppLocalizations.of(
              tester.element(find.byType(SettingsLanguageSelector)))!
          .errorText('Test Error')),
      findsOneWidget,
    );
  });

  testWidgets('SettingsLanguageSelector has correct styling',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(createTestableWidget(const SettingsLanguageSelector()));
    await tester.pumpAndSettle();

    final InputDecorator decorator = tester.widget(find.descendant(
      of: find.byType(SettingsLanguageSelector),
      matching: find.byType(InputDecorator),
    ));

    expect(decorator.decoration.fillColor, isNotNull);
    expect(decorator.decoration.border, isA<OutlineInputBorder>());
    expect((decorator.decoration.border as OutlineInputBorder).borderRadius,
        BorderRadius.circular(8));
  });
}
