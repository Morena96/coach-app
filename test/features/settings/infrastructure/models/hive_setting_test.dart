import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:domain/features/settings/entities/setting.dart';

void main() {
  group('HiveSetting', () {
    test('should create HiveSetting with string value', () {
      final hiveSetting =
          HiveSetting(settingKey: 'test', settingValue: 'value');
      expect(hiveSetting.settingKey, 'test');
      expect(hiveSetting.settingValue, 'value');
    });

    test('should create HiveSetting with int value', () {
      final hiveSetting = HiveSetting(settingKey: 'test', settingValue: 42);
      expect(hiveSetting.settingKey, 'test');
      expect(hiveSetting.settingValue, 42);
    });

    test('should create HiveSetting from domain Setting', () {
      const setting = Setting('test', 'value');
      final hiveSetting = HiveSetting.fromDomain(setting);
      expect(hiveSetting.settingKey, 'test');
      expect(hiveSetting.settingValue, 'value');
    });

    test('should create HiveSetting from Map', () {
      final map = {'key': 'test', 'value': 'mapValue'};
      final hiveSetting = HiveSetting.fromMap(map);
      expect(hiveSetting.settingKey, 'test');
      expect(hiveSetting.settingValue, 'mapValue');
    });

    test('should convert HiveSetting to domain Setting', () {
      final hiveSetting =
          HiveSetting(settingKey: 'test', settingValue: 'value');
      final setting = hiveSetting.toDomain();
      expect(setting.key, 'test');
      expect(setting.value, 'value');
    });

    test('should return correct key', () {
      final hiveSetting =
          HiveSetting(settingKey: 'testKey', settingValue: 'value');
      expect(hiveSetting.key, 'testKey');
    });
  });
}
