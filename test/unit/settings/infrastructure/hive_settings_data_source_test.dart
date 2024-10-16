import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:hive/hive.dart';
import 'package:coach_app/features/settings/infrastructure/datasources/hive_settings_data_source.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';

@GenerateMocks([Box<HiveSetting>])

import 'hive_settings_data_source_test.mocks.dart';

void main() {
  late HiveSettingsDataSource dataSource;
  late MockBox<HiveSetting> mockBox;

  setUp(() {
    mockBox = MockBox();
    dataSource = HiveSettingsDataSource(mockBox);
  });

  group('HiveSettingsDataSource', () {
    test('getAllSettings returns all settings', () async {
      final hiveSetting1 = HiveSetting(settingKey: 'key1', settingValue: 'value1');
      final hiveSetting2 = HiveSetting(settingKey: 'key2', settingValue: 'value2');
      when(mockBox.values).thenReturn([hiveSetting1, hiveSetting2]);

      final result = await dataSource.getAllSettings();

      expect(result, [
        {'key': 'key1', 'value': 'value1'},
        {'key': 'key2', 'value': 'value2'},
      ]);
    });

    test('getSettingByKey returns setting when it exists', () async {
      final hiveSetting = HiveSetting(settingKey: 'key1', settingValue: 'value1');
      when(mockBox.get('key1')).thenReturn(hiveSetting);

      final result = await dataSource.getSettingByKey('key1');

      expect(result, {'key': 'key1', 'value': 'value1'});
    });

    test('getSettingByKey returns null when setting does not exist', () async {
      when(mockBox.get('nonexistent')).thenReturn(null);

      final result = await dataSource.getSettingByKey('nonexistent');

      expect(result, null);
    });

    test('saveSetting saves the setting to the box', () async {
      final settingMap = {'key': 'newKey', 'value': 'newValue'};

      
      await dataSource.saveSetting(settingMap);

      verify(mockBox.put('newKey', argThat(predicate<HiveSetting>((setting) => setting.settingKey == 'newKey' && setting.settingValue == 'newValue')))).called(1);
    });

    test('deleteSetting deletes the setting from the box', () async {
      await dataSource.deleteSetting('keyToDelete');

      verify(mockBox.delete('keyToDelete')).called(1);
    });
  });
}
