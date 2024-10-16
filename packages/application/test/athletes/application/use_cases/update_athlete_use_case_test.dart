import 'package:application/athletes/use_cases/update_athlete_use_case.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/services/athlete_validation_service.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/utilities/validation/validation_error.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'create_new_athlete_use_case_test.mocks.dart';

@GenerateMocks([Athletes, AthleteValidationService, AvatarRepository])
void main() {
  late UpdateAthleteUseCase useCase;
  late MockAthletes mockRepository;
  late MockAthleteValidationService mockValidationService;
  late MockAvatarRepository mockAvatarRepository;

  setUp(() {
    mockRepository = MockAthletes();
    mockValidationService = MockAthleteValidationService();
    mockAvatarRepository = MockAvatarRepository();
    useCase = UpdateAthleteUseCase(
        mockRepository, mockValidationService, mockAvatarRepository);
  });

  test('should update a new athlete when data is valid', () async {
    // Arrange
    final updatedData = {
      'id': '1',
      'name': 'John Doe',
    };
    var athlete = const Athlete(id: '1', name: 'John Doe');

    when(mockValidationService.validateAthleteData(updatedData))
        .thenReturn(ValidationResult.valid());
    when(mockRepository.updateAthlete(argThat(isA<Athlete>())))
        .thenAnswer((_) async => Result.success(null));

    // Act
    final result = await useCase.execute(athlete, updatedData, null);

    // Assert
    expect(result.isSuccess, true);
    verify(mockValidationService.validateAthleteData(updatedData)).called(1);
    verify(mockRepository.updateAthlete(argThat(predicate<Athlete>(
        (a) => a.id == athlete.id && a.name == athlete.name)))).called(1);
  });

  test('should return failure when athlete data is invalid', () async {
    // Arrange
    final invalidAthleteData = {
      'id': '',
      'name': '',
    };
    const athlete = Athlete(id: '1', name: 'John Doe');
    final validationErrors = [
      ValidationError('name', 'Athlete name cannot be empty')
    ];

    when(mockValidationService.validateAthleteData(invalidAthleteData))
        .thenReturn(ValidationResult.invalid(validationErrors));

    // Act
    final result = await useCase.execute(athlete, invalidAthleteData, null);

    // Assert
    expect(result.isFailure, true);
    expect(result.error, 'Athlete name cannot be empty');
    verify(mockValidationService.validateAthleteData(invalidAthleteData))
        .called(1);
    verifyNever(mockRepository.updateAthlete(any));
  });

  test('should return failure when repository fails', () async {
    // Arrange
    final athleteData = {
      'id': '1',
      'name': 'Jane Doe',
    };
    final athlete = Athlete.fromJson(const {
      'id': '1',
      'name': 'John Doe',
    });

    when(mockValidationService.validateAthleteData(athleteData))
        .thenReturn(ValidationResult.valid());
    when(mockRepository.updateAthlete(argThat(predicate<Athlete>((a) =>
            a.id == athleteData['id'] && a.name == athleteData['name']))))
        .thenAnswer((_) async => Result.failure('Database error'));

    // Act
    final result = await useCase.execute(athlete, athleteData, null);

    // Assert
    expect(result.isFailure, true);
    expect(result.error, 'Database error');
    verify(mockValidationService.validateAthleteData(athleteData)).called(1);
    verify(mockRepository.updateAthlete(argThat(predicate<Athlete>((a) =>
            a.id == athleteData['id'] && a.name == athleteData['name']))))
        .called(1);
  });
}
