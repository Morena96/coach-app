import 'package:domain/features/settings/entities/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/router/app_router.dart';
import 'package:coach_app/core/widgets/screens/initialized_app.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_view_model.dart';

class MockSettingsViewModel extends SettingsViewModel {
  @override
  SettingsState build() => const AsyncValue.data([
        Setting('themeMode', 'system'),
        Setting('language', 'en'),
      ]);

  @override
  ThemeMode get themeMode => ThemeMode.system;

  @override
  Locale get locale => const Locale('en', '');
}

void main() {
  testWidgets('InitializedApp renders correctly', (WidgetTester tester) async {
    final mockRouter = GoRouter(routes: []);

    final container = ProviderContainer(
      overrides: [
        settingsViewModelProvider.overrideWith(() => MockSettingsViewModel()),
        goRouterProvider.overrideWithValue(mockRouter),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const InitializedApp(),
      ),
    );

    // Allow for async operations to complete
    await tester.pumpAndSettle();

    // Verify that MaterialApp is rendered
    expect(find.byType(MaterialApp), findsOneWidget);

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

    // Verify properties
    expect(materialApp.title, '1Tul Coach App');
    expect(materialApp.debugShowCheckedModeBanner, false);
    expect(materialApp.theme, isNotNull);
    expect(materialApp.darkTheme, isNotNull);
    expect(materialApp.themeMode, ThemeMode.system);
    expect(materialApp.routerConfig, mockRouter);
    expect(materialApp.locale, const Locale('en', ''));

    // Clean up
    container.dispose();
  });
}
