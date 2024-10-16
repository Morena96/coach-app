import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';

import 'package:coach_app/features/settings/infrastructure/datasources/hive_settings_data_source.dart';
import 'package:coach_app/features/settings/infrastructure/repositories/settings_repository_impl.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_data_source_provider.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_repository_provider.dart';

@GenerateMocks([HiveSettingsDataSource])
import 'settings_repository_provider_test.mocks.dart';

void main() {
  late MockHiveSettingsDataSource mockDataSource;
  late ProviderContainer container;

  setUp(() {
    mockDataSource = MockHiveSettingsDataSource();
    container = ProviderContainer(
      overrides: [
        settingsDataSourceProvider.overrideWithValue(mockDataSource),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('settingsRepository should return a SettingsRepositoryImpl', () {
    final repository = container.read(settingsRepositoryProvider);
    expect(repository, isA<SettingsRepositoryImpl>());
  });

  test('settingsRepository should be a singleton', () {
    final repository1 = container.read(settingsRepositoryProvider);
    final repository2 = container.read(settingsRepositoryProvider);
    expect(identical(repository1, repository2), isTrue);
  });

  test('settingsRepository should update when data source changes', () {
    final initialRepository = container.read(settingsRepositoryProvider);

    final newMockDataSource = MockHiveSettingsDataSource();
    final newContainer = ProviderContainer(
      overrides: [
        settingsDataSourceProvider.overrideWithValue(newMockDataSource),
      ],
    );

    final updatedRepository = newContainer.read(settingsRepositoryProvider);

    expect(identical(initialRepository, updatedRepository), isFalse);
  });
}
