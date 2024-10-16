import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';

import 'package:coach_app/features/settings/infrastructure/datasources/hive_settings_data_source.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';

@GenerateMocks([Box, HiveInterface])
import 'settings_data_source_provider_test.mocks.dart';

// Create a testable version of the provider
final testableSettingsDataSourceProvider = Provider((ref) {
  final hive = ref.watch(hiveProvider);
  var box = hive.box<HiveSetting>('settings');
  return HiveSettingsDataSource(box);
});

// Create a provider for Hive
final hiveProvider =
    Provider<HiveInterface>((ref) => throw UnimplementedError());

void main() {
  late MockBox<HiveSetting> mockBox;
  late MockHiveInterface mockHive;
  late ProviderContainer container;

  setUp(() {
    mockBox = MockBox<HiveSetting>();
    mockHive = MockHiveInterface();

    when(mockHive.box<HiveSetting>('settings')).thenReturn(mockBox);

    container = ProviderContainer(
      overrides: [
        hiveProvider.overrideWithValue(mockHive),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('settingsDataSource should return a HiveSettingsDataSource', () {
    final dataSource = container.read(testableSettingsDataSourceProvider);
    expect(dataSource, isA<HiveSettingsDataSource>());
  });

  test('settingsDataSource should be a singleton', () {
    final dataSource1 = container.read(testableSettingsDataSourceProvider);
    final dataSource2 = container.read(testableSettingsDataSourceProvider);
    expect(identical(dataSource1, dataSource2), isTrue);
  });

  test('settingsDataSource should use the correct box name', () {
    container.read(testableSettingsDataSourceProvider);
    verify(mockHive.box<HiveSetting>('settings')).called(1);
  });
}
