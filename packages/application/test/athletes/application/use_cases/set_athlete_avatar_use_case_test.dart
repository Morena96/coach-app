import 'package:application/athletes/use_cases/set_athlete_avatar_use_case.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'image_mocks.dart';
@GenerateMocks([Athletes, AvatarRepository, LoggerRepository])
import 'set_athlete_avatar_use_case_test.mocks.dart';

void main() {
  late SetAthleteAvatarUseCase useCase;
  late MockAthletes mockAthletes;
  late MockAvatarRepository mockAvatarRepository;
  late MockLoggerRepository mockLogger;

  setUp(() {
    mockAthletes = MockAthletes();
    mockAvatarRepository = MockAvatarRepository();
    mockLogger = MockLoggerRepository();
    useCase = SetAthleteAvatarUseCase(mockAthletes, mockAvatarRepository, mockLogger);
  });

  test('should successfully set athlete avatar', () async {
    // Arrange
    const athleteId = '123';
    const athlete = Athlete(id: athleteId, name: 'John Doe');
    final avatarImage = MockImageData();
    final avatar = Avatar(id: 'avatar1', localPath: 'path', lastUpdated: DateTime.now(), syncStatus: SyncStatus.synced);

    when(mockAthletes.getAthleteById(athleteId))
        .thenAnswer((_) async => Result.success(athlete));
    when(mockAvatarRepository.saveAvatar(athleteId, avatarImage))
        .thenAnswer((_) async => avatar);
    when(mockAthletes.updateAthlete(any))
        .thenAnswer((_) async => Result.success(null));

    // Act
    await useCase.execute(athleteId, avatarImage);

    // Assert
    verify(mockAthletes.getAthleteById(athleteId)).called(1);
    verify(mockAvatarRepository.saveAvatar(athleteId, avatarImage)).called(1);
    verify(mockAthletes.updateAthlete(any)).called(1);
    verify(mockLogger.info('Saving avatar')).called(1);
    verify(mockLogger.info('Saved avatar')).called(1);
  });

  test('should throw AthleteNotFoundException when athlete is not found', () async {
    // Arrange
    const athleteId = '123';
    final avatarImage = MockImageData();

    when(mockAthletes.getAthleteById(athleteId))
        .thenAnswer((_) async => Result.success(null));

    // Act & Assert
    expect(() => useCase.execute(athleteId, avatarImage), throwsA(isA<AthleteNotFoundException>()));
  });

  test('should throw AthleteNotFoundException when getting athlete fails', () async {
    // Arrange
    const athleteId = '123';
    final avatarImage = MockImageData();

    when(mockAthletes.getAthleteById(athleteId))
        .thenAnswer((_) async => Result.failure('Database error'));

    // Act & Assert
    expect(() => useCase.execute(athleteId, avatarImage), throwsA(isA<AthleteNotFoundException>()));
  });

  test('should throw AthleteUpdateException when updating athlete fails', () async {
    // Arrange
    const athleteId = '123';
    const athlete = Athlete(id: athleteId, name: 'John Doe');
    final avatarImage = MockImageData();
    final avatar = Avatar(id: 'avatar1', localPath: 'path', lastUpdated: DateTime.now(), syncStatus: SyncStatus.synced);

    when(mockAthletes.getAthleteById(athleteId))
        .thenAnswer((_) async => Result.success(athlete));
    when(mockAvatarRepository.saveAvatar(athleteId, avatarImage))
        .thenAnswer((_) async => avatar);
    when(mockAthletes.updateAthlete(any))
        .thenAnswer((_) async => Result.failure('Update failed'));

    // Act & Assert
    expect(() => useCase.execute(athleteId, avatarImage), throwsA(isA<AthleteUpdateException>()));
  });

  test('should log error and rethrow when an exception occurs', () async {
    // Arrange
    const athleteId = '123';
    final avatarImage = MockImageData();

    when(mockAthletes.getAthleteById(athleteId))
        .thenThrow(Exception('Unexpected error'));

    // Act & Assert
    expect(() => useCase.execute(athleteId, avatarImage), throwsException);
  });
}
