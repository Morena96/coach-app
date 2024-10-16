import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:application/pods/use_cases/batch_update_athlete_associations_to_pods_use_case.dart';
import 'package:domain/features/pods/repositories/pods.dart';

@GenerateMocks([Pods])
import 'batch_update_athlete_associations_to_pods_use_case_test.mocks.dart';

void main() {
  late BatchUpdateAthleteAssociationsToPodsUseCase batchUpdateUseCase;
  late MockPods mockPodsRepository;

  setUp(() {
    mockPodsRepository = MockPods();
    batchUpdateUseCase = BatchUpdateAthleteAssociationsToPodsUseCase(mockPodsRepository);
  });

  group('BatchUpdateAthleteAssociationsToPodsUseCase', () {
    test('should call batchUpdateAthleteAssociations on the repository with the given map', () async {
      // Arrange
      final podIdToAthleteIdMap = {
        'pod1': 'athlete1',
        'pod2': 'athlete2',
        'pod3': null,
      };
      when(mockPodsRepository.batchUpdateAthleteAssociations(podIdToAthleteIdMap))
          .thenAnswer((_) async {});

      // Act
      await batchUpdateUseCase.execute(podIdToAthleteIdMap);

      // Assert
      verify(mockPodsRepository.batchUpdateAthleteAssociations(podIdToAthleteIdMap)).called(1);
    });

    test('should handle empty map', () async {
      // Arrange
      final emptyMap = <String, String?>{};
      when(mockPodsRepository.batchUpdateAthleteAssociations(emptyMap))
          .thenAnswer((_) async {});

      // Act
      await batchUpdateUseCase.execute(emptyMap);

      // Assert
      verify(mockPodsRepository.batchUpdateAthleteAssociations(emptyMap)).called(1);
    });

    test('should throw an exception when repository throws an exception', () async {
      // Arrange
      final podIdToAthleteIdMap = {'pod1': 'athlete1'};
      when(mockPodsRepository.batchUpdateAthleteAssociations(podIdToAthleteIdMap))
          .thenThrow(Exception('Failed to update associations'));

      // Act & Assert
      expect(() => batchUpdateUseCase.execute(podIdToAthleteIdMap), throwsException);
      verify(mockPodsRepository.batchUpdateAthleteAssociations(podIdToAthleteIdMap)).called(1);
    });
  });
}
