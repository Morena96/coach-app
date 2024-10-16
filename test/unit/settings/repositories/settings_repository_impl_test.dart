import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:coach_app/features/settings/infrastructure/datasources/settings_data_source.dart';
import 'package:coach_app/features/settings/infrastructure/repositories/settings_repository_impl.dart';

@GenerateMocks([SettingsDataSource])
import 'settings_repository_impl_test.mocks.dart';

void main() {
  late SettingsRepositoryImpl repository;
  late MockSettingsDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockSettingsDataSource();
    repository = SettingsRepositoryImpl(mockDataSource);
  });

  group('SettingsRepositoryImpl', () {
    test('getAllSettings returns list of Settings', () async {
      final mockSettingsData = [
        {'key': 'key1', 'value': 'value1'},
        {'key': 'key2', 'value': 'value2'},
      ];
      when(mockDataSource.getAllSettings()).thenAnswer((_) async => mockSettingsData);

      final result = await repository.getAllSettings();

      expect(result, isA<List<Setting>>());
      expect(result.length, 2);
      expect(result[0], isA<Setting>());
      expect(result[0].key, 'key1');
      expect(result[0].value, 'value1');
      expect(result[1].key, 'key2');
      expect(result[1].value, 'value2');
      verify(mockDataSource.getAllSettings()).called(1);
    });

    test('getSettingByKey returns Setting when it exists', () async {
      final mockSettingData = {'key': 'testKey', 'value': 'testValue'};
      when(mockDataSource.getSettingByKey('testKey')).thenAnswer((_) async => mockSettingData);

      final result = await repository.getSettingByKey('testKey');

      expect(result, isA<Setting>());
      expect(result!.key, 'testKey');
      expect(result.value, 'testValue');
      verify(mockDataSource.getSettingByKey('testKey')).called(1);
    });

    test('getSettingByKey returns null when setting does not exist', () async {
      when(mockDataSource.getSettingByKey('nonexistentKey')).thenAnswer((_) async => null);

      final result = await repository.getSettingByKey('nonexistentKey');

      expect(result, isNull);
      verify(mockDataSource.getSettingByKey('nonexistentKey')).called(1);
    });

    test('saveSetting calls data source with correct parameters', () async {
      const setting = Setting('newKey', 'newValue');
      when(mockDataSource.saveSetting(any)).thenAnswer((_) async {});

      await repository.saveSetting(setting);

      verify(mockDataSource.saveSetting({'key': 'newKey', 'value': 'newValue'})).called(1);
    });

    test('deleteSetting calls data source with correct key', () async {
      when(mockDataSource.deleteSetting(any)).thenAnswer((_) async {});

      await repository.deleteSetting('keyToDelete');

      verify(mockDataSource.deleteSetting('keyToDelete')).called(1);
    });
  });
}
