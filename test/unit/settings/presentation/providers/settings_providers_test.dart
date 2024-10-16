import 'package:application/settings/use_cases/get_all_settings_use_case.dart';
import 'package:application/settings/use_cases/get_setting_use_case.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:coach_app/features/settings/infrastructure/datasources/hive_settings_data_source.dart';
import 'package:coach_app/features/settings/infrastructure/repositories/settings_repository_impl.dart';
import 'package:coach_app/features/settings/presentation/providers/get_all_settings_use_case_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/get_setting_use_case_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/save_setting_use_case_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_data_source_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_repository_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

@GenerateMocks([SettingsRepositoryImpl, HiveSettingsDataSource])

import 'settings_providers_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockSettingsRepositoryImpl mockRepository;
  late MockHiveSettingsDataSource mockDataSource;

  setUp(() {
    mockRepository = MockSettingsRepositoryImpl();
    mockDataSource = MockHiveSettingsDataSource();
    container = ProviderContainer(
      overrides: [
        settingsRepositoryProvider.overrideWithValue(mockRepository),
        settingsDataSourceProvider.overrideWithValue(mockDataSource),
      ],
    );
  });

  group('getAllSettingsUseCase', () {
    test('should return GetAllSettingsUseCase with correct repository', () {
      final useCase = container.read(getAllSettingsUseCaseProvider);
      expect(useCase, isA<GetAllSettingsUseCase>());
    });
  });

  group('getSettingUseCase', () {
    test('should return GetSettingUseCase with correct repository', () {
      final useCase = container.read(getSettingUseCaseProvider);
      expect(useCase, isA<GetSettingUseCase>());
    });
  });

  group('saveSettingUseCase', () {
    test('should call execute on SaveSettingUseCase with correct parameters', () async {
      const setting = Setting('testKey',  'testValue');
      when(mockRepository.saveSetting(setting)).thenAnswer((_) async {});

      await container.read(saveSettingUseCaseProvider(setting).future);

      verify(mockRepository.saveSetting(setting)).called(1);
    });
  });

  group('settingsDataSource', () {
    test('should return HiveSettingsDataSource', () {
      final dataSource = container.read(settingsDataSourceProvider);
      expect(dataSource, isA<HiveSettingsDataSource>());
    });
  });

  group('settingsRepository', () {
    test('should return SettingsRepositoryImpl with correct data source', () {
      final repository = container.read(settingsRepositoryProvider);
      expect(repository, isA<SettingsRepositoryImpl>());
    });
  });
}
