import 'package:application/athletes/use_cases/create_new_athlete_use_case.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:domain/features/athletes/services/athlete_validation_service.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/utilities/validation/validation_error.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Athletes, AthleteValidationService, Sports, AvatarRepository])
import 'create_new_athlete_use_case_test.mocks.dart';
import 'image_mocks.dart';

void main() {
  late CreateNewAthleteUseCase useCase;
  late MockAthletes mockRepository;
  late MockAthleteValidationService mockValidationService;
  late MockSports mockSports;
  late MockAvatarRepository mockAvatarRepository;

  setUp(() {
    mockRepository = MockAthletes();
    mockSports = MockSports();
    mockValidationService = MockAthleteValidationService();
    mockAvatarRepository = MockAvatarRepository();
    useCase = CreateNewAthleteUseCase(mockRepository, mockSports, mockValidationService, mockAvatarRepository);
  });

  test('should create a new athlete when data is valid', () async {
    // Arrange
    final athleteData = {
      'id': '1',
      'name': 'John Doe',
    };
    final athlete = Athlete.fromJson(athleteData);
    final sportIds = ['sport1', 'sport2'];
    final sports = [const Sport(id: 'sport1', name: 'Sport 1'), const Sport(id: 'sport2', name: 'Sport 2')];

    when(mockValidationService.validateAthleteData(athleteData))
        .thenReturn(ValidationResult.valid());
    when(mockSports.getSportsByIds(sportIds))
        .thenAnswer((_) async => Result.success(sports));
    when(mockRepository.addAthlete(any))
        .thenAnswer((_) async => Result.success(athlete));

    // Act
    final result = await useCase.execute(athleteData, sportIds, null);

    // Assert
    expect(result.isSuccess, true);
    verify(mockValidationService.validateAthleteData(athleteData)).called(1);
    verify(mockSports.getSportsByIds(sportIds)).called(1);
    verify(mockRepository.addAthlete(argThat(predicate<Athlete>(
        (a) => a.id == athlete.id && a.name == athlete.name && a.sports == sports)))).called(1);
  });

  test('should return failure when athlete data is invalid', () async {
    // Arrange
    final invalidAthleteData = {
      'id': '',
      'name': '',
    };
    final validationErrors = [
      ValidationError('name', 'Athlete name cannot be empty')
    ];

    when(mockValidationService.validateAthleteData(invalidAthleteData))
        .thenReturn(ValidationResult.invalid(validationErrors));

    // Act
    final result = await useCase.execute(invalidAthleteData, [], null);

    // Assert
    expect(result.isFailure, true);
    expect(result.error, 'Athlete name cannot be empty');
    verify(mockValidationService.validateAthleteData(invalidAthleteData))
        .called(1);
    verifyNever(mockSports.getSportsByIds(any));
    verifyNever(mockRepository.addAthlete(any));
  });

  test('should return failure when repository fails', () async {
    // Arrange
    final athleteData = {
      'id': '1',
      'name': 'John Doe',
    };
    final sportIds = ['sport1'];
    final sports = [const Sport(id: 'sport1', name: 'Sport 1')];

    when(mockValidationService.validateAthleteData(athleteData))
        .thenReturn(ValidationResult.valid());
    when(mockSports.getSportsByIds(sportIds))
        .thenAnswer((_) async => Result.success(sports));
    when(mockRepository.addAthlete(any))
        .thenAnswer((_) async => Result.failure('Database error'));

    // Act
    final result = await useCase.execute(athleteData, sportIds, null);

    // Assert
    expect(result.isFailure, true);
    expect(result.error, 'Database error');
    verify(mockValidationService.validateAthleteData(athleteData)).called(1);
    verify(mockSports.getSportsByIds(sportIds)).called(1);
    verify(mockRepository.addAthlete(any)).called(1);
  });

  test('should create athlete with avatar when provided', () async {
    // Arrange
    final athleteData = {
      'id': '1',
      'name': 'John Doe',
    };
    final athlete = Athlete.fromJson(athleteData);
    final sportIds = ['sport1'];
    final sports = [const Sport(id: 'sport1', name: 'Sport 1')];
    final avatar = MockImageData();


    when(mockValidationService.validateAthleteData(athleteData))
        .thenReturn(ValidationResult.valid());
    when(mockSports.getSportsByIds(sportIds))
        .thenAnswer((_) async => Result.success(sports));
    when(mockRepository.addAthlete(any))
        .thenAnswer((_) async => Result.success(athlete));
    when(mockAvatarRepository.saveAvatar(athlete.id, avatar))
        .thenAnswer((_) async => Avatar(id: 'avatar1', localPath: 'path', lastUpdated: DateTime.now(), syncStatus: SyncStatus.synced));
    when(mockRepository.updateAthlete(any))
        .thenAnswer((_) async => Result.success(null));

    // Act
    final result = await useCase.execute(athleteData, sportIds, avatar);

    // Assert
    expect(result.isSuccess, true);
    verify(mockValidationService.validateAthleteData(athleteData)).called(1);
    verify(mockSports.getSportsByIds(sportIds)).called(1);
    verify(mockRepository.addAthlete(any)).called(1);
    verify(mockAvatarRepository.saveAvatar(athlete.id, avatar)).called(1);
    verify(mockRepository.updateAthlete(argThat(predicate<Athlete>(
        (a) => a.id == athlete.id && a.avatarId == 'avatar1')))).called(1);
  });
}
