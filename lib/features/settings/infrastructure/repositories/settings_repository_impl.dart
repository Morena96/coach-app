import 'package:domain/features/settings/entities/setting.dart';
import 'package:domain/features/settings/repositories/settings.dart';
import 'package:coach_app/features/settings/infrastructure/datasources/settings_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource _dataSource;

  SettingsRepositoryImpl(this._dataSource);

  @override
  Future<List<Setting>> getAllSettings() async {
    final settingsData = await _dataSource.getAllSettings();
    return settingsData.map((settingMap) => Setting(settingMap['key'], settingMap['value'])).toList();
  }

  @override
  Future<Setting?> getSettingByKey(String key) async {
    final settingData = await _dataSource.getSettingByKey(key);
    if (settingData != null) {
      return Setting(settingData['key'], settingData['value']);
    }
    return null;
  }

  @override
  Future<void> saveSetting(Setting setting) async {
    await _dataSource.saveSetting({
      'key': setting.key,
      'value': setting.value,
    });
  }

  @override
  Future<void> deleteSetting(String key) async {
    await _dataSource.deleteSetting(key);
  }
}