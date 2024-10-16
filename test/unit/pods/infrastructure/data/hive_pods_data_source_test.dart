import 'package:coach_app/features/pods/infrastructure/data/pods_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:coach_app/features/pods/infrastructure/data/hive_pods_data_source.dart';
import 'package:coach_app/features/pods/infrastructure/models/hive_pod.dart';

@GenerateMocks([Box<HivePod>])
import 'hive_pods_data_source_test.mocks.dart';

void main() {
  late HivePodsDataSource dataSource;
  late MockBox<HivePod> mockBox;

  setUp(() {
    mockBox = MockBox<HivePod>();
    dataSource = HivePodsDataSource(mockBox);
  });

  group('HivePodsDataSource', () {
    test('getAllPods returns all pods', () async {
      final pods = [
        HivePod(id: '1', number: 1, rfSlot: 1),
        HivePod(id: '2', number: 2, rfSlot: 2),
      ];
      when(mockBox.values).thenReturn(pods);

      final result = await dataSource.getAllPods();

      expect(result.map((e) => e.id).toList(),
          equals(pods.map((e) => e.id).toList()));
      expect(result.map((e) => e.number).toList(),
          equals(pods.map((e) => e.number).toList()));
      expect(result.map((e) => e.rfSlot).toList(),
          equals(pods.map((e) => e.rfSlot).toList()));
    });

    test('getPodById returns correct pod', () async {
      final pod = HivePod(id: '1', number: 1, rfSlot: 1);
      when(mockBox.get('1')).thenReturn(pod);

      final result = await dataSource.getPodById('1');

      expect(result!.id, equals(pod.id));
    });

    test('getPodById throws PodDataSourceException on HiveError', () async {
      when(mockBox.get('1')).thenThrow(HiveError('Test Hive error'));

      expect(() => dataSource.getPodById('1'),
          throwsA(isA<PodDataSourceException>()));
    });

    test('getPodById throws PodDataSourceException on unexpected error',
        () async {
      when(mockBox.get('1')).thenThrow(Exception('Unexpected error'));

      expect(() => dataSource.getPodById('1'),
          throwsA(isA<PodDataSourceException>()));
    });

    test('savePod calls put on box', () async {
      final pod = HivePod(id: '1', number: 1, rfSlot: 1);

      await dataSource.savePod(pod.toDomain());

      verify(mockBox.put('1', any)).called(1);
    });

    test('savePod throws PodDataSourceException on HiveError', () async {
      final pod = HivePod(id: '1', number: 1, rfSlot: 1);
      when(mockBox.put('1', any)).thenThrow(HiveError('Test Hive error'));

      expect(() => dataSource.savePod(pod.toDomain()),
          throwsA(isA<PodDataSourceException>()));
    });

    test('savePod throws PodDataSourceException on unexpected error', () async {
      final pod = HivePod(id: '1', number: 1, rfSlot: 1);
      when(mockBox.put('1', any)).thenThrow(Exception('Unexpected error'));

      expect(() => dataSource.savePod(pod.toDomain()),
          throwsA(isA<PodDataSourceException>()));
    });

    test('deletePod calls delete on box', () async {
      await dataSource.deletePod('1');

      verify(mockBox.delete('1')).called(1);
    });

    test('deletePod throws PodDataSourceException on HiveError', () async {
      when(mockBox.delete('1')).thenThrow(HiveError('Test Hive error'));

      expect(() => dataSource.deletePod('1'),
          throwsA(isA<PodDataSourceException>()));
    });

    test('deletePod throws PodDataSourceException on unexpected error',
        () async {
      when(mockBox.delete('1')).thenThrow(Exception('Unexpected error'));

      expect(() => dataSource.deletePod('1'),
          throwsA(isA<PodDataSourceException>()));
    });
  });
}
