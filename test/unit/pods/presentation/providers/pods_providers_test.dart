import 'package:coach_app/features/pods/infrastructure/data/hive_pods_data_source.dart';
import 'package:coach_app/features/pods/infrastructure/models/hive_pod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:coach_app/features/pods/infrastructure/data/pods_data_source.dart';
import 'package:coach_app/features/pods/infrastructure/repositories/pods_impl.dart';
import 'package:coach_app/features/pods/presentation/providers/pods_providers.dart';

import '../../../settings/infrastructure/hive_settings_data_source_test.mocks.dart';
import 'pods_providers_test.mocks.dart';

@GenerateMocks([PodsDataSource])
void main() {
  group('PodsProviders', () {
    late ProviderContainer container;
    late MockPodsDataSource mockPodsDataSource;

    setUp(() {
      mockPodsDataSource = MockPodsDataSource();
      container = ProviderContainer(
        overrides: [
          podsDataSourceProvider.overrideWithValue(mockPodsDataSource),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('podsProvider returns a PodsImpl instance', () {
      final pods = container.read(podsProvider);
      expect(pods, isA<PodsImpl>());
    });

    test('podsDataSourceProvider returns the mocked PodsDataSource', () {
      final dataSource = container.read(podsDataSourceProvider);
      expect(dataSource, equals(mockPodsDataSource));
    });

    test('pods provider uses the correct data source', () {
      final pods = container.read(podsProvider);
      expect(pods, isA<PodsImpl>());

      // This test verifies that the PodsImpl is created with the correct data source
      // We can't directly access the private _dataSource field, so we'll verify
      // indirectly by calling a method and ensuring it uses our mock
      when(mockPodsDataSource.getAllPods()).thenAnswer((_) async => []);

      pods.getAllPods();
      verify(mockPodsDataSource.getAllPods()).called(1);
    });
  });

  group('PodsProviders', () {
    late ProviderContainer container;
    late MockBox<HivePod> mockHiveBox;

    setUp(() {
      mockHiveBox = MockBox<HivePod>();
      container = ProviderContainer(
        overrides: [
          podsDataSourceProvider.overrideWith(
            ((ref) => HivePodsDataSource(mockHiveBox)),
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('podsDataSourceProvider returns a HivePodsDataSource instance', () {
      final dataSource = container.read(podsDataSourceProvider);
      expect(dataSource, isA<HivePodsDataSource>());
    });

    test('podsDataSourceProvider uses the correct Hive box', () {
      final dataSource = container.read(podsDataSourceProvider);
      expect(dataSource, isA<HivePodsDataSource>());

      // Verify that the HivePodsDataSource is using the correct box
      when(mockHiveBox.values).thenReturn([]);

      dataSource.getAllPods();
      verify(mockHiveBox.values).called(1);
    });
  });
}
