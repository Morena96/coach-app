import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:application/pods/use_cases/get_all_pods_use_case.dart';
import 'package:domain/features/pods/entities/pod.dart';
import 'package:domain/features/pods/repositories/pods.dart';

@GenerateMocks([Pods])
import 'get_all_pods_use_case_test.mocks.dart';

void main() {
  late GetAllPodsUseCase getAllPodsUseCase;
  late MockPods mockPodsRepository;

  setUp(() {
    mockPodsRepository = MockPods();
    getAllPodsUseCase = GetAllPodsUseCase(mockPodsRepository);
  });

  group('GetAllPodsUseCase', () {
    test('should return a list of Pods when execute is called', () async {
      // Arrange
      final expectedPods = [
        Pod(id: '1', number: 1, rfSlot: 1),
        Pod(id: '2', number: 2, athleteId: 'athlete1', rfSlot: 2),
        Pod(id: '3', number: 3, rfSlot: 3),
      ];
      when(mockPodsRepository.getAllPods()).thenAnswer((_) async => expectedPods);

      // Act
      final result = await getAllPodsUseCase.execute();

      // Assert
      expect(result, equals(expectedPods));
      verify(mockPodsRepository.getAllPods()).called(1);
    });

    test('should return an empty list when no pods are available', () async {
      // Arrange
      when(mockPodsRepository.getAllPods()).thenAnswer((_) async => []);

      // Act
      final result = await getAllPodsUseCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(mockPodsRepository.getAllPods()).called(1);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      when(mockPodsRepository.getAllPods()).thenThrow(Exception('Failed to get pods'));

      // Act & Assert
      expect(() => getAllPodsUseCase.execute(), throwsException);
      verify(mockPodsRepository.getAllPods()).called(1);
    });

    test('should return pods with correct structure', () async {
      // Arrange
      final expectedPods = [
        Pod(id: '1', number: 1, rfSlot: 1),
        Pod(id: '2', number: 2, athleteId: 'athlete1', rfSlot: 2),
      ];
      when(mockPodsRepository.getAllPods()).thenAnswer((_) async => expectedPods);

      // Act
      final result = await getAllPodsUseCase.execute();

      // Assert
      expect(result, hasLength(2));
      expect(result[0], isA<Pod>());
      expect(result[0].id, equals('1'));
      expect(result[0].number, equals(1));
      expect(result[0].athleteId, isNull);
      expect(result[0].rfSlot, equals(1));
      expect(result[1].id, equals('2'));
      expect(result[1].number, equals(2));
      expect(result[1].athleteId, equals('athlete1'));
      expect(result[1].rfSlot, equals(2));
    });
  });
}
