import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:application/pods/use_cases/get_pod_by_id_use_case.dart';
import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';

@GenerateMocks([Pods])
import 'get_pod_by_id_use_case_test.mocks.dart';

void main() {
  late GetPodByIdUseCase getPodByIdUseCase;
  late MockPods mockPodsRepository;

  setUp(() {
    mockPodsRepository = MockPods();
    getPodByIdUseCase = GetPodByIdUseCase(mockPodsRepository);
  });

  group('GetPodByIdUseCase', () {
    test('should return a Pod when given a valid id', () async {
      // Arrange
      const podId = '1';
      final expectedPod = Pod(id: podId, number: 1, rfSlot: 1);
      when(mockPodsRepository.getPodById(podId)).thenAnswer((_) async => expectedPod);

      // Act
      final result = await getPodByIdUseCase.execute(podId);

      // Assert
      expect(result, equals(expectedPod));
      verify(mockPodsRepository.getPodById(podId)).called(1);
    });

    test('should return a Pod with athleteId when present', () async {
      // Arrange
      const podId = '2';
      final expectedPod = Pod(id: podId, number: 2, athleteId: 'athlete1', rfSlot: 2);
      when(mockPodsRepository.getPodById(podId)).thenAnswer((_) async => expectedPod);

      // Act
      final result = await getPodByIdUseCase.execute(podId);

      // Assert
      expect(result, equals(expectedPod));
      expect(result.athleteId, equals('athlete1'));
      verify(mockPodsRepository.getPodById(podId)).called(1);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      const podId = '3';
      when(mockPodsRepository.getPodById(podId)).thenThrow(Exception('Pod not found'));

      // Act & Assert
      expect(() => getPodByIdUseCase.execute(podId), throwsException);
      verify(mockPodsRepository.getPodById(podId)).called(1);
    });
  });
}
