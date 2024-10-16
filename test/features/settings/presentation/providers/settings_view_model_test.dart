import 'dart:async';

import 'package:application/settings/use_cases/get_all_settings_use_case.dart';
import 'package:application/settings/use_cases/get_setting_use_case.dart';
import 'package:application/settings/use_cases/save_setting_use_case.dart';
import 'package:coach_app/features/settings/presentation/providers/get_all_settings_use_case_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/get_setting_use_case_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/save_setting_use_case_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Mock classes
@GenerateMocks([GetAllSettingsUseCase, GetSettingUseCase, SaveSettingUseCase])
import 'settings_view_model_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockGetAllSettingsUseCase mockGetAllSettingsUseCase;
  late MockGetSettingUseCase mockGetSettingUseCase;
  late MockSaveSettingUseCase mockSaveSettingUseCase;

  setUp(() {
    mockGetAllSettingsUseCase = MockGetAllSettingsUseCase();
    mockGetSettingUseCase = MockGetSettingUseCase();
    mockSaveSettingUseCase = MockSaveSettingUseCase();

    container = ProviderContainer(
      overrides: [
        getAllSettingsUseCaseProvider
            .overrideWithValue(mockGetAllSettingsUseCase),
        getSettingUseCaseProvider.overrideWithValue(mockGetSettingUseCase),
        saveSettingUseCaseProvider.overrideWith((_) => mockSaveSettingUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('initial state is loading', () {
    final settingsState = container.read(settingsViewModelProvider);
    expect(settingsState, isA<AsyncLoading>());
  });

  test('loadSettings updates state correctly', () async {
    when(mockGetAllSettingsUseCase.execute()).thenAnswer(
      (_) async => [
        const Setting('themeMode', 'light'),
        const Setting('language', 'en'),
      ],
    );

    // Use a Completer to wait for the state to be updated
    final completer = Completer<void>();

    container.listen<AsyncValue<List<Setting>>>(
      settingsViewModelProvider,
      (_, next) {
        if (next is AsyncData) {
          completer.complete();
        }
      },
      fireImmediately: true,
    );

    // Wait for the state to be updated
    await completer.future;

    final settingsState = container.read(settingsViewModelProvider);
    expect(settingsState.value, [
      const Setting('themeMode', 'light'),
      const Setting('language', 'en'),
    ]);
  });

  test('updateSetting updates state and calls saveSettingUseCase', () async {
    when(mockGetAllSettingsUseCase.execute())
        .thenAnswer((_) async => [const Setting('themeMode', 'light')]);
    when(mockSaveSettingUseCase.execute(const Setting('themeMode', 'dark')))
        .thenAnswer((_) async => {});

    final completer = Completer<void>();
    late final ProviderSubscription<AsyncValue<List<Setting>>> subscription;

    subscription = container.listen<AsyncValue<List<Setting>>>(
      settingsViewModelProvider,
      (_, next) {
        if (next is AsyncData && !completer.isCompleted) {
          completer.complete();
          subscription.close();
        }
      },
      fireImmediately: true,
    );

    await completer.future;

    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    await settingsViewModel.updateSetting('themeMode', 'dark');

    final settingsState = container.read(settingsViewModelProvider);
    expect(settingsState.value, contains(const Setting('themeMode', 'dark')));
  });

  test('getSetting returns correct setting', () async {
    when(mockGetSettingUseCase.execute('themeMode'))
        .thenAnswer((_) async => const Setting('themeMode', 'light'));

    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    final setting = await settingsViewModel.getSetting('themeMode');

    expect(setting, const Setting('themeMode', 'light'));
  });

  test('themeMode getter returns correct ThemeMode', () async {
    when(mockGetAllSettingsUseCase.execute())
        .thenAnswer((_) async => [const Setting('themeMode', 'light')]);

    final completer = Completer<void>();
    container.listen<AsyncValue<List<Setting>>>(
      settingsViewModelProvider,
      (_, next) {
        if (next is AsyncData) {
          completer.complete();
        }
      },
      fireImmediately: true,
    );

    await completer.future;

    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    expect(settingsViewModel.themeMode, ThemeMode.light);
  });

  test('language getter returns correct language', () async {
    when(mockGetAllSettingsUseCase.execute())
        .thenAnswer((_) async => [const Setting('language', 'es')]);

    final completer = Completer<void>();
    container.listen<AsyncValue<List<Setting>>>(
      settingsViewModelProvider,
      (_, next) {
        if (next is AsyncData) {
          completer.complete();
        }
      },
      fireImmediately: true,
    );

    await completer.future;

    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    expect(settingsViewModel.language, 'es');
  });

  test('setLanguage updates language setting', () async {
    when(mockGetAllSettingsUseCase.execute())
        .thenAnswer((_) async => [const Setting('language', 'en')]);
    when(mockSaveSettingUseCase.execute(const Setting('language', 'fr')))
        .thenAnswer((_) async => {});

    final completer = Completer<void>();
    late final ProviderSubscription<AsyncValue<List<Setting>>> subscription;
    subscription = container.listen<AsyncValue<List<Setting>>>(
      settingsViewModelProvider,
      (_, next) {
        if (next is AsyncData) {
          if (next is AsyncData && !completer.isCompleted) {
            completer.complete();
            subscription.close();
          }
        }
      },
      fireImmediately: true,
    );

    await completer.future;

    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    await settingsViewModel.setLanguage('fr');

    expect(settingsViewModel.language, 'fr');
  });

  test('locale getter returns correct Locale', () async {
    when(mockGetAllSettingsUseCase.execute())
        .thenAnswer((_) async => [const Setting('language', 'es')]);

    final completer = Completer<void>();
    container.listen<AsyncValue<List<Setting>>>(
      settingsViewModelProvider,
      (_, next) {
        if (next is AsyncData) {
          completer.complete();
        }
      },
      fireImmediately: true,
    );

    await completer.future;

    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    expect(settingsViewModel.locale, const Locale('es', ''));
  });

  test('supportedLocales returns correct list of Locales', () {
    final settingsViewModel =
        container.read(settingsViewModelProvider.notifier);
    expect(
        settingsViewModel.supportedLocales, AppLocalizations.supportedLocales);
  });
}
