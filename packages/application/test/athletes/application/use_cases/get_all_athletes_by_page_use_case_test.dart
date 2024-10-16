import 'package:application/athletes/use_cases/get_all_athletes_by_page_use_case.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate a Mock class for the Athletes repository
@GenerateMocks([Athletes])
import 'get_all_athletes_by_page_use_case_test.mocks.dart';

void main() {
  late GetAllAthletesByPageUseCase useCase;
  late MockAthletes mockRepository;

  setUp(() {
    mockRepository = MockAthletes();
    useCase = GetAllAthletesByPageUseCase(mockRepository);
  });

  group('GetAllAthletesByPageUseCase', () {
    test(
        'should return a list of athletes for a valid page when the repository call is successful',
        () async {
      // Arrange
      final athletes = [
        const Athlete(id: '1', name: 'John Doe'),
        const Athlete(id: '2', name: 'Jane Smith'),
      ];
      when(mockRepository.getAthletesByPage(1, 10))
          .thenAnswer((_) async => Result.success(athletes));

      // Act
      final result = await useCase.execute(1, 10);

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, athletes);
      verify(mockRepository.getAthletesByPage(1, 10)).called(1);
    });

    test(
        'should return an empty list when the repository returns an empty list for a page',
        () async {
      // Arrange
      when(mockRepository.getAthletesByPage(2, 10))
          .thenAnswer((_) async => Result.success([]));

      // Act
      final result = await useCase.execute(2, 10);

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, isEmpty);
      verify(mockRepository.getAthletesByPage(2, 10)).called(1);
    });

    test('should return a failure result when the repository call fails',
        () async {
      // Arrange
      const errorMessage = 'Failed to fetch athletes for the specified page';
      when(mockRepository.getAthletesByPage(1, 20))
          .thenAnswer((_) async => Result.failure(errorMessage));

      // Act
      final result = await useCase.execute(1, 20);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.getAthletesByPage(1, 20)).called(1);
    });

    test('should propagate exceptions from the repository', () async {
      // Arrange
      when(mockRepository.getAthletesByPage(1, 15))
          .thenThrow(Exception('Unexpected error'));

      // Act & Assert
      expect(() => useCase.execute(1, 15), throwsException);
      verify(mockRepository.getAthletesByPage(1, 15)).called(1);
    });

    test('should handle different page sizes correctly', () async {
      // Arrange
      final athletesPage1 = List.generate(
          5, (index) => Athlete(id: '$index', name: 'Athlete $index'));
      final athletesPage2 = List.generate(3,
          (index) => Athlete(id: '${index + 5}', name: 'Athlete ${index + 5}'));

      when(mockRepository.getAthletesByPage(1, 5))
          .thenAnswer((_) async => Result.success(athletesPage1));
      when(mockRepository.getAthletesByPage(2, 5))
          .thenAnswer((_) async => Result.success(athletesPage2));

      // Act
      final resultPage1 = await useCase.execute(1, 5);
      final resultPage2 = await useCase.execute(2, 5);

      // Assert
      expect(resultPage1.isSuccess, true);
      expect(resultPage1.value!.length, 5);
      expect(resultPage2.isSuccess, true);
      expect(resultPage2.value!.length, 3);
      verify(mockRepository.getAthletesByPage(1, 5)).called(1);
      verify(mockRepository.getAthletesByPage(2, 5)).called(1);
    });
  });
}
