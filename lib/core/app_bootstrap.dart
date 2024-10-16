import 'package:hive_flutter/hive_flutter.dart';

import 'package:coach_app/features/auth/data/auth_storage.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/hive_avatar.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';

Future<void> bootstrapApp() async {
  await Hive.initFlutter();

  await Hive.deleteFromDisk();

  Hive.registerAdapter(HiveAvatarAdapter());
  Hive.registerAdapter(HiveSettingAdapter());

  await AuthStorage().init();
}
