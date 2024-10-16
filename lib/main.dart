import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:coach_app/app.dart';
import 'package:coach_app/core/app_bootstrap.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/hive_avatar.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';
import 'package:coach_app/shared/providers/avatar_box_provider.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:coach_app/shared/providers/settings_box_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await bootstrapApp();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final directory = await getApplicationDocumentsDirectory();
  Box<HiveAvatar> avatarBox;

  try {
    avatarBox = await Hive.openBox<HiveAvatar>('avatars');
  } catch (e) {
    await Hive.deleteBoxFromDisk('avatars');
    avatarBox = await Hive.openBox<HiveAvatar>('avatars');
  }

  final settingsBox = await Hive.openBox<HiveSetting>('settings');

  runApp(
    ProviderScope(
      overrides: [
        directoryProvider.overrideWithValue(directory),
        avatarBoxProvider.overrideWithValue(avatarBox),
        settingsBoxProvider.overrideWithValue(settingsBox),
      ],
      child: const CoachApp(),
    ),
  );
}
