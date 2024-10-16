  abstract class SettingsDataSource {
  Future<List<Map<String, dynamic>>> getAllSettings();
  Future<Map<String, dynamic>?> getSettingByKey(String key);
  Future<void> saveSetting(Map<String, dynamic> settingMap);
  Future<void> deleteSetting(String key);
}