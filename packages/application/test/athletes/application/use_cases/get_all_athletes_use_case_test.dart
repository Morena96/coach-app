import 'package:application/athletes/use_cases/get_all_athletes_use_case.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate a Mock class for the Athletes repository
@GenerateMocks([Athletes])
import 'get_all_athletes_use_case_test.mocks.dart';

void main() {
  late GetAllAthletesUseCase useCase;
  late MockAthletes mockRepository;

  setUp(() {
    mockRepository = MockAthletes();
    useCase = GetAllAthletesUseCase(mockRepository);
  });

  group('GetAllAthletesUseCase', () {
    test(
        'should return a list of athletes when the repository call is successful',
        () async {
      // Arrange
      final athletes = [
        const Athlete(id: '1', name: 'John Doe'),
        const Athlete(id: '2', name: 'Jane Smith'),
      ];
      when(mockRepository.getAllAthletes())
          .thenAnswer((_) async => Result.success(athletes));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, athletes);
      verify(mockRepository.getAllAthletes()).called(1);
    });

    test('can pass in filter criteria into the use case', () async {
      // Arrange
      final athletes = [
        const Athlete(id: '1', name: 'John Doe'),
        const Athlete(id: '2', name: 'Jane Smith'),
      ];
      final filterCriteria = AthleteFilterCriteria(name: 'John Doe');

      when(mockRepository.getAthletesByFilterCriteria(any))
          .thenAnswer((_) async => Result.success(athletes));

      // Act
      final result = await useCase.execute(filterCriteria: filterCriteria);

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, athletes);
      verify(mockRepository.getAthletesByFilterCriteria(any)).called(1);
    });

    test(
        'should return an empty list when the repository returns an empty list',
        () async {
      // Arrange
      when(mockRepository.getAllAthletes())
          .thenAnswer((_) async => Result.success([]));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, isEmpty);
      verify(mockRepository.getAllAthletes()).called(1);
    });

    test('should return a failure result when the repository call fails',
        () async {
      // Arrange
      const errorMessage = 'Failed to fetch athletes';
      when(mockRepository.getAllAthletes())
          .thenAnswer((_) async => Result.failure(errorMessage));

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.getAllAthletes()).called(1);
    });

    test('should propagate exceptions from the repository', () async {
      // Arrange
      when(mockRepository.getAllAthletes())
          .thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(() => useCase.execute(), throwsException);
      verify(mockRepository.getAllAthletes()).called(1);
    });
  });
}
