import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:coach_app/features/settings/infrastructure/datasources/hive_settings_data_source.dart';
import 'package:coach_app/features/settings/infrastructure/repositories/settings_repository_impl.dart';
import 'package:application/settings/use_cases/save_setting_use_case.dart';
import 'package:application/settings/use_cases/get_setting_use_case.dart';
import 'package:application/settings/use_cases/get_all_settings_use_case.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late HiveSettingsDataSource dataSource;
  late SettingsRepositoryImpl repository;
  late SaveSettingUseCase saveSettingUseCase;
  late GetSettingUseCase getSettingUseCase;
  late GetAllSettingsUseCase getAllSettingsUseCase;
  late Directory testDir;

  setUpAll(() async {
    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(HiveSettingAdapter());

    // Get a directory that's safe to use in the app's sandbox
    final appSupportDir = await getApplicationSupportDirectory();
    testDir = Directory(path.join(appSupportDir.path, 'integration_test_settings'));

    // Ensure the test directory exists
    if (!await testDir.exists()) {
      await testDir.create(recursive: true);
    }

    // Initialize the settings data source, repository and use cases
    final box = await Hive.openBox<HiveSetting>('settings_test', path: testDir.path);
    dataSource = HiveSettingsDataSource(box);
    repository = SettingsRepositoryImpl(dataSource);
    saveSettingUseCase = SaveSettingUseCase(repository);
    getSettingUseCase = GetSettingUseCase(repository);
    getAllSettingsUseCase = GetAllSettingsUseCase(repository);
  });

  tearDownAll(() async {
    // Clean up: delete test data and close Hive
    await Hive.deleteFromDisk();
    await testDir.delete(recursive: true);
  });

  testWidgets('Settings integration test', (WidgetTester tester) async {
    // Test saving a setting
    const settingToSave = Setting('test_key', 'test_value');
    await saveSettingUseCase.execute(settingToSave);

    // Test getting a specific setting
    final retrievedSetting = await getSettingUseCase.execute('test_key');
    expect(retrievedSetting, isNotNull);
    expect(retrievedSetting!.key, equals('test_key'));
    expect(retrievedSetting.value, equals('test_value'));

    // Test getting all settings
    final allSettings = await getAllSettingsUseCase.execute();
    expect(allSettings, isNotEmpty);
    expect(allSettings.length, equals(1));
    expect(allSettings.first.key, equals('test_key'));
    expect(allSettings.first.value, equals('test_value'));

    // Test updating a setting
    const updatedSetting = Setting('test_key', 'updated_value');
    await saveSettingUseCase.execute(updatedSetting);

    final retrievedUpdatedSetting = await getSettingUseCase.execute('test_key');
    expect(retrievedUpdatedSetting, isNotNull);
    expect(retrievedUpdatedSetting!.key, equals('test_key'));
    expect(retrievedUpdatedSetting.value, equals('updated_value'));

    // Test saving multiple settings
    await saveSettingUseCase.execute(const Setting('key2', 'value2'));
    await saveSettingUseCase.execute(const Setting('key3', 'value3'));

    final allSettingsAfterMultipleSaves = await getAllSettingsUseCase.execute();
    expect(allSettingsAfterMultipleSaves.length, equals(3));
  });
}
