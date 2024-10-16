import 'package:application/pods/use_cases/update_pod_use_case.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';

@GenerateMocks([Pods])
import 'update_pod_use_case_test.mocks.dart';

void main() {
  late UpdatePodUseCase updatePodUseCase;
  late MockPods mockPodsRepository;

  setUp(() {
    mockPodsRepository = MockPods();
    updatePodUseCase = UpdatePodUseCase(mockPodsRepository);
  });

  group('UpdatePodUseCase', () {
    test('should call updatePod on the repository with the given pod', () async {
      // Arrange
      final pod = Pod(id: '1', number: 1, rfSlot: 1);
      when(mockPodsRepository.updatePod(pod)).thenAnswer((_) async {});

      // Act
      await updatePodUseCase.execute(pod);

      // Assert
      verify(mockPodsRepository.updatePod(pod)).called(1);
    });

    test('should successfully update a pod with an athleteId', () async {
      // Arrange
      final pod = Pod(id: '2', number: 2, athleteId: 'athlete1', rfSlot: 2);
      when(mockPodsRepository.updatePod(pod)).thenAnswer((_) async {});

      // Act
      await updatePodUseCase.execute(pod);

      // Assert
      verify(mockPodsRepository.updatePod(pod)).called(1);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      final pod = Pod(id: '3', number: 3, rfSlot: 3);
      when(mockPodsRepository.updatePod(pod)).thenThrow(Exception('Failed to update pod'));

      // Act & Assert
      expect(() => updatePodUseCase.execute(pod), throwsException);
      verify(mockPodsRepository.updatePod(pod)).called(1);
    });

    test('should update a pod created with copyWith method', () async {
      // Arrange
      final originalPod = Pod(id: '4', number: 4, rfSlot: 4);
      final updatedPod = originalPod.copyWith(athleteId: 'athlete2');
      when(mockPodsRepository.updatePod(updatedPod)).thenAnswer((_) async {});

      // Act
      await updatePodUseCase.execute(updatedPod);

      // Assert
      verify(mockPodsRepository.updatePod(updatedPod)).called(1);
      expect(updatedPod.id, equals('4'));
      expect(updatedPod.number, equals(4));
      expect(updatedPod.athleteId, equals('athlete2'));
      expect(updatedPod.rfSlot, equals(4));
    });
  });
}
