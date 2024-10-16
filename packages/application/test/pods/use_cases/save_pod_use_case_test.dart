import 'package:application/pods/use_cases/save_pod_use_case.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';

@GenerateMocks([Pods])
import 'save_pod_use_case_test.mocks.dart';

void main() {
  late SavePodUseCase savePodUseCase;
  late MockPods mockPodsRepository;

  setUp(() {
    mockPodsRepository = MockPods();
    savePodUseCase = SavePodUseCase(mockPodsRepository);
  });

  group('SavePodUseCase', () {
    test('should call savePod on the repository with the given pod', () async {
      // Arrange
      final pod = Pod(id: '1', number: 1, rfSlot: 1);
      when(mockPodsRepository.savePod(pod)).thenAnswer((_) async {});

      // Act
      await savePodUseCase.execute(pod);

      // Assert
      verify(mockPodsRepository.savePod(pod)).called(1);
    });

    test('should successfully save a pod with an athleteId', () async {
      // Arrange
      final pod = Pod(id: '2', number: 2, athleteId: 'athlete1', rfSlot: 2);
      when(mockPodsRepository.savePod(pod)).thenAnswer((_) async {});

      // Act
      await savePodUseCase.execute(pod);

      // Assert
      verify(mockPodsRepository.savePod(pod)).called(1);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      final pod = Pod(id: '3', number: 3, rfSlot: 3);
      when(mockPodsRepository.savePod(pod)).thenThrow(Exception('Failed to save pod'));

      // Act & Assert
      expect(() => savePodUseCase.execute(pod), throwsException);
      verify(mockPodsRepository.savePod(pod)).called(1);
    });

    test('should save a pod created with copyWith method', () async {
      // Arrange
      final originalPod = Pod(id: '4', number: 4, rfSlot: 4);
      final updatedPod = originalPod.copyWith(athleteId: 'athlete2');
      when(mockPodsRepository.savePod(updatedPod)).thenAnswer((_) async {});

      // Act
      await savePodUseCase.execute(updatedPod);

      // Assert
      verify(mockPodsRepository.savePod(updatedPod)).called(1);
      expect(updatedPod.id, equals('4'));
      expect(updatedPod.number, equals(4));
      expect(updatedPod.athleteId, equals('athlete2'));
      expect(updatedPod.rfSlot, equals(4));
    });
  });
}
