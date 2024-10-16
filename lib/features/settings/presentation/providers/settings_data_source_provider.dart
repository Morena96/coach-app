import 'package:coach_app/features/settings/infrastructure/datasources/hive_settings_data_source.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_data_source_provider.g.dart';
@riverpod
HiveSettingsDataSource settingsDataSource(SettingsDataSourceRef ref) {
  var box =  Hive.box<HiveSetting>('settings');
  return HiveSettingsDataSource(box);
}
