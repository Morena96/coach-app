import 'package:domain/features/settings/entities/setting.dart';
import 'package:hive/hive.dart';

part 'hive_setting.g.dart';

@HiveType(typeId: 0)
class HiveSetting extends HiveObject {
  @HiveField(0)
  String settingKey;

  @HiveField(1)
  dynamic settingValue;

  HiveSetting({required this.settingKey, required this.settingValue});

  // Convert domain Setting to HiveSetting
  factory HiveSetting.fromDomain(Setting setting) {
    return HiveSetting(
      settingKey: setting.key,
      settingValue: setting.value,
    );
  }

  factory HiveSetting.fromMap(Map<String, dynamic> map) {
    return HiveSetting(
      settingKey: map['key'],
      settingValue: map['value'],
    );
  }

  // Convert HiveSetting to domain Setting
  Setting toDomain() {
    return Setting(settingKey, settingValue);
  }

  @override
  String get key => settingKey;
}