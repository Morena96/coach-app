import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';

part 'settings_box_provider.g.dart';

@riverpod
Box<HiveSetting> settingsBox(SettingsBoxRef ref) {
  throw UnimplementedError();
}
