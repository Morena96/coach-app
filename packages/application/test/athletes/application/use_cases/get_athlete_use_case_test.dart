import 'package:application/athletes/use_cases/get_athlete_use_case.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([Athletes])
import 'get_athlete_use_case_test.mocks.dart';

void main() {
  late GetAthleteByIdUseCase getAthleteByIdUseCase;
  late MockAthletes mockAthletes;

  setUp(() {
    mockAthletes = MockAthletes();
    getAthleteByIdUseCase = GetAthleteByIdUseCase(mockAthletes);
  });

  group('GetAthleteByIdUseCase', () {
    test('should return Success with Athlete when repository returns Success', () async {
      // Arrange
      const athleteId = '123';
      const athlete = Athlete(id: athleteId, name: 'John Doe');
      when(mockAthletes.getAthleteById(athleteId))
          .thenAnswer((_) async => Result.success(athlete));

      // Act
      final result = await getAthleteByIdUseCase.execute(athleteId);

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, athlete);
      verify(mockAthletes.getAthleteById(athleteId)).called(1);
    });

    test('should return Failure when repository returns Failure', () async {
      // Arrange
      const athleteId = '123';
      const errorMessage = 'Athlete not found';
      when(mockAthletes.getAthleteById(athleteId))
          .thenAnswer((_) async => Result.failure(errorMessage));

      // Act
      final result = await getAthleteByIdUseCase.execute(athleteId);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockAthletes.getAthleteById(athleteId)).called(1);
    });
  });
}

