import 'package:domain/features/settings/entities/setting.dart';

abstract class SettingsRepository {
  Future<List<Setting>> getAllSettings();
  Future<Setting?> getSettingByKey(String key);
  Future<void> saveSetting(Setting setting);
  Future<void> deleteSetting(String key);
}