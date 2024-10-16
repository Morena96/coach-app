import 'package:coach_app/features/settings/infrastructure/datasources/settings_data_source.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';
import 'package:hive/hive.dart';

class HiveSettingsDataSource implements SettingsDataSource {
  final Box<HiveSetting> _box;

  HiveSettingsDataSource(this._box);

  @override
  Future<List<Map<String, dynamic>>> getAllSettings() async {
    return _box.values.map((hiveSetting) => {
      'key': hiveSetting.settingKey,
      'value': hiveSetting.settingValue,
    }).toList();
  }

  @override
  Future<Map<String, dynamic>?> getSettingByKey(String key) async {
    final hiveSetting = _box.get(key);
    if (hiveSetting != null) {
      return {
        'key': hiveSetting.settingKey,
        'value': hiveSetting.settingValue,
      };
    }
    return null;
  }

  @override
  Future<void> saveSetting(Map<String, dynamic> settingMap) async {
    final hiveSetting = HiveSetting(
      settingKey: settingMap['key'],
      settingValue: settingMap['value'],
    );
    await _box.put(hiveSetting.settingKey, hiveSetting);
  }

  @override
  Future<void> deleteSetting(String key) async {
    await _box.delete(key);
  }
}