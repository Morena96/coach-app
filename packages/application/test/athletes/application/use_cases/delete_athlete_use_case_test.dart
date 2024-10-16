import 'package:application/athletes/use_cases/delete_athlete_use_case.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Athletes])
import 'delete_athlete_use_case_test.mocks.dart';

void main() {
  late DeleteAthleteUseCase deleteAthleteUseCase;
  late MockAthletes mockAthletes;

  setUp(() {
    mockAthletes = MockAthletes();
    deleteAthleteUseCase = DeleteAthleteUseCase(mockAthletes);
  });

  group('DeleteAthleteUseCase', () {
    test('should return Success when repository successfully deletes athlete', () async {
      // Arrange
      const athleteId = '123';
      when(mockAthletes.deleteAthlete(athleteId))
          .thenAnswer((_) async => Result.success(null));

      // Act
      final result = await deleteAthleteUseCase.execute(athleteId);

      // Assert
      expect(result.isSuccess, true);
      verify(mockAthletes.deleteAthlete(athleteId)).called(1);
    });

    test('should return Failure when repository fails to delete athlete', () async {
      // Arrange
      const athleteId = '123';
      const errorMessage = 'Failed to delete athlete';
      when(mockAthletes.deleteAthlete(athleteId))
          .thenAnswer((_) async => Result.failure(errorMessage));

      // Act
      final result = await deleteAthleteUseCase.execute(athleteId);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockAthletes.deleteAthlete(athleteId)).called(1);
    });
  });
}
