import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';
import 'package:coach_app/features/pods/infrastructure/data/pods_data_source.dart';
import 'package:coach_app/features/pods/infrastructure/repositories/pods_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([PodsDataSource])
import 'pods_impl_test.mocks.dart';

void main() {
  late PodsImpl podsImpl;
  late MockPodsDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockPodsDataSource();
    podsImpl = PodsImpl(mockDataSource);
  });

  group('PodsImpl', () {
    test('getAllPods returns list of Pods', () async {
      final pods = [
        Pod(id: '1', number: 1, rfSlot: 1),
        Pod(id: '2', number: 2, rfSlot: 2),
      ];
      when(mockDataSource.getAllPods())
          .thenAnswer((_) async => pods.toList());

      final result = await podsImpl.getAllPods();
      expect(result, isA<List<Pod>>());
      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[1].id, equals('2'));
      verify(mockDataSource.getAllPods()).called(1);
    });

    test('getAllPods throws PodRepositoryException on error', () async {
      when(mockDataSource.getAllPods()).thenThrow(Exception('Database error'));

      expect(
          () => podsImpl.getAllPods(), throwsA(isA<PodRepositoryException>()));
    });

    test('getPodById returns correct Pod', () async {
      when(mockDataSource.getPodById('1'))
          .thenAnswer((_) async =>Pod(id: '1', number: 1, rfSlot: 1));

      final result = await podsImpl.getPodById('1');
      expect(result, isA<Pod>());
      expect(result.id, equals('1'));
      verify(mockDataSource.getPodById('1')).called(1);
    });

    test('getPodById throws PodNotFoundException when pod not found', () async {
      when(mockDataSource.getPodById('1')).thenAnswer((_) async => null);

      expect(
          () => podsImpl.getPodById('1'), throwsA(isA<PodNotFoundException>()));
    });

    test('getPodById throws PodRepositoryException on error', () async {
      when(mockDataSource.getPodById('1'))
          .thenThrow(Exception('Database error'));

      expect(() => podsImpl.getPodById('1'),
          throwsA(isA<PodRepositoryException>()));
    });

    test('savePod calls data source', () async {
      final pod = Pod(id: '1', number: 1, rfSlot: 1);
      await podsImpl.savePod(pod);
      verify(mockDataSource.savePod(any)).called(1);
    });

    test('savePod throws PodRepositoryException on error', () async {
      final pod = Pod(id: '1', number: 1, rfSlot: 1);
      when(mockDataSource.savePod(any)).thenThrow(Exception('Database error'));

      expect(
          () => podsImpl.savePod(pod), throwsA(isA<PodRepositoryException>()));
    });

    test('deletePod calls data source', () async {
      await podsImpl.deletePod('1');
      verify(mockDataSource.deletePod('1')).called(1);
    });

    test('deletePod throws PodRepositoryException on error', () async {
      when(mockDataSource.deletePod('1'))
          .thenThrow(Exception('Database error'));

      expect(() => podsImpl.deletePod('1'),
          throwsA(isA<PodRepositoryException>()));
    });

    test('updatePod calls data source when pod exists', () async {
      final pod = Pod(id: '1', number: 1, rfSlot: 1);
      when(mockDataSource.getPodById('1')).thenAnswer((_) async => pod);

      await podsImpl.updatePod(pod);
      verify(mockDataSource.getPodById('1')).called(1);
      verify(mockDataSource.savePod(pod)).called(1);
    });

    test('updatePod throws PodNotFoundException when pod does not exist',
        () async {
      final pod = Pod(id: '1', number: 1, rfSlot: 1);
      when(mockDataSource.getPodById('1')).thenAnswer((_) async => null);

      expect(
          () => podsImpl.updatePod(pod), throwsA(isA<PodNotFoundException>()));
    });

    test('updatePod throws PodRepositoryException on error', () async {
      final pod = Pod(id: '1', number: 1, rfSlot: 1);
      when(mockDataSource.getPodById('1'))
          .thenThrow(Exception('Database error'));

      expect(() => podsImpl.updatePod(pod),
          throwsA(isA<PodRepositoryException>()));
    });

    test('batchUpdateAthleteAssociations updates pods correctly', () async {
      final podIdToAthleteId = {'1': 'athlete1', '2': 'athlete2'};
      final pod1 = Pod(id: '1', number: 1, rfSlot: 1);
      final pod2 = Pod(id: '2', number: 2, rfSlot: 2);

      when(mockDataSource.getPodById('1')).thenAnswer((_) async => pod1);
      when(mockDataSource.getPodById('2')).thenAnswer((_) async => pod2);

      await podsImpl.batchUpdateAthleteAssociations(podIdToAthleteId);

      verify(mockDataSource.savePod(any)).called(2);
    });

    test(
        'batchUpdateAthleteAssociations throws PodRepositoryException on error',
        () async {
      final podIdToAthleteId = {'1': 'athlete1'};
      when(mockDataSource.getPodById('1'))
          .thenThrow(Exception('Database error'));

      expect(() => podsImpl.batchUpdateAthleteAssociations(podIdToAthleteId),
          throwsA(isA<PodRepositoryException>()));
    });
  });
}
