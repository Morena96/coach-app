import 'package:domain/features/settings/entities/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/settings/presentation/providers/settings_view_model.dart';

class FakeSettingsViewModel extends SettingsViewModel {
  AsyncValue<List<Setting>> _state = const AsyncValue.data([]);
  String selectedLanguage = 'en';
  String themeModeString = 'system';

  @override
  Locale get locale => Locale(selectedLanguage, '');

  @override
  ThemeMode get themeMode => _parseThemeMode(themeModeString);

  @override
  AsyncValue<List<Setting>> build() => _state;

  @override
  Future<void> setLanguage(String languageCode) async {
    selectedLanguage = languageCode;
  }

  @override
  Future<void> updateSetting(String key, dynamic value) async {
    if (key == 'themeMode') {
      themeModeString = value;
    }
  }

  void setLoading() {
    _state = const AsyncValue.loading();
  }

  void setError(String error) {
    _state = AsyncValue.error(error, StackTrace.current);
  }

  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
