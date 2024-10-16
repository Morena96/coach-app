import 'package:application/settings/use_cases/get_all_settings_use_case.dart';
import 'package:application/settings/use_cases/get_setting_use_case.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/settings/presentation/providers/get_all_settings_use_case_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/get_setting_use_case_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/save_setting_use_case_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


part 'settings_view_model.g.dart';

/// The state of the settings, represented as a list of Setting objects.
typedef SettingsState = AsyncValue<List<Setting>>;

/// ViewModel for managing settings state and operations.
@riverpod
class SettingsViewModel extends _$SettingsViewModel {
  late GetAllSettingsUseCase _getAllSettingsUseCase;
  late GetSettingUseCase _getSettingUseCase;

  @override
  SettingsState build() {
    _getAllSettingsUseCase = ref.watch(getAllSettingsUseCaseProvider);
    _getSettingUseCase = ref.watch(getSettingUseCaseProvider);
    _loadSettings();
    return const AsyncValue.loading();
  }

  /// Loads all settings from the repository.
  Future<void> _loadSettings() async {
    state = const AsyncValue.loading();
    try {
      final settings = await _getAllSettingsUseCase.execute();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Updates or creates a setting with the given key and value.
  Future<void> updateSetting(String key, dynamic value) async {
    try {
      final newSetting = Setting(key, value);
      await ref.read(saveSettingUseCaseProvider(newSetting).future);
      state = AsyncValue.data([
        ...state.value?.where((setting) => setting.key != key) ?? [],
        newSetting,
      ]);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Retrieves a setting by its key.
  Future<Setting?> getSetting(String key) async {
    try {
      return await _getSettingUseCase.execute(key);
    } catch (e) {
      // Handle error or rethrow
      return null;
    }
  }

  /// Gets the current theme mode setting.
  ThemeMode get themeMode {
    final modeSetting = state.value?.firstWhere(
      (setting) => setting.key == 'themeMode',
      orElse: () => const Setting('themeMode', 'system'),
    );
    return _parseThemeMode(modeSetting?.value);
  }

  /// Gets the current language setting.
  String get language {
    final languageSetting = state.value?.firstWhere(
      (setting) => setting.key == 'language',
      orElse: () => const Setting('language', 'en'),
    );
    return languageSetting?.value ?? 'en';
  }

  /// Parses a string value to a ThemeMode enum.
  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  /// Gets the current language setting.
  Locale get locale {
    final languageSetting = state.value?.firstWhere(
      (setting) => setting.key == 'language',
      orElse: () => const Setting('language', 'system'),
    );
    return _parseLocale(languageSetting?.value);
  }

  /// Updates the language setting.
  Future<void> setLanguage(String languageCode) async {
    await updateSetting('language', languageCode);
  }

  /// Parses a string value to a Locale.
  Locale _parseLocale(String? value) {
    switch (value) {
      case 'en':
        return const Locale('en', '');
      case 'es':
        return const Locale('es', '');
      case 'fr':
        return const Locale('fr', '');
      default:
        return _getSystemLocale();
    }
  }

  /// Gets the system locale.
  Locale _getSystemLocale() {
    final systemLocale = WidgetsBinding.instance.window.locales.first;
    if (['en', 'es', 'fr'].contains(systemLocale.languageCode)) {
      return systemLocale;
    }
    return const Locale(
        'en', ''); // Default to English if system language is not supported
  }

  /// Gets the list of supported locales.
  List<Locale> get supportedLocales => AppLocalizations.supportedLocales;
}
