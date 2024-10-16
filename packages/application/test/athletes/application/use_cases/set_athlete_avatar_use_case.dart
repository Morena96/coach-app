
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

// Generate mocks
import 'image_mocks.dart';
@GenerateMocks([Athletes, AvatarRepository, LoggerRepository])

import 'set_athlete_avatar_use_case.mocks.dart';

void main() {
  late SetAthleteAvatarUseCase useCase;
  late MockAthletes mockAthleteRepository;
  late MockAvatarRepository mockAvatarRepository;
  late LoggerRepository mockLogger;

  setUp(() {
    mockAthleteRepository = MockAthletes();
    mockAvatarRepository = MockAvatarRepository();
    mockLogger = MockLoggerRepository();

    useCase = SetAthleteAvatarUseCase(
        mockAthleteRepository, mockAvatarRepository, mockLogger);
  });

  group('SetAthleteAvatarUseCase', () {
    const testAthleteId = 'test-athlete-id';
    const testAvatarId = 'test-avatar-id';
    var imageDataFactory = MockImageDataFactory();
    var testImageData = imageDataFactory.createFromBytes([1,2,3]);// Dummy image data
    const testAthlete = Athlete(id: testAthleteId, name: 'Test Athlete');
    final testAvatar = Avatar(
        id: testAvatarId,
        localPath: 'path/to/avatar.jpg',
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.synced);

    test('should successfully set athlete avatar', () async {
      // Arrange
      when(mockAthleteRepository.getAthleteById(testAthleteId))
          .thenAnswer((_) async => Result.success(testAthlete));
      when(mockAvatarRepository.saveAvatar(testAthleteId, testImageData))
          .thenAnswer((_) async => testAvatar);
      when(mockAthleteRepository.updateAthlete(any))
          .thenAnswer((_) async => Result.success(null));

      // Act
      await useCase.execute(testAthleteId, testImageData);

      // Assert
      verify(mockAthleteRepository.getAthleteById(testAthleteId)).called(1);
      verify(mockAvatarRepository.saveAvatar(testAthleteId, testImageData))
          .called(1);

      final updatedAthleteMatcher = predicate<Athlete>((athlete) =>
          athlete.id == testAthleteId && athlete.avatarId == testAvatarId);
      verify(mockAthleteRepository
              .updateAthlete(captureThat(updatedAthleteMatcher)))
          .called(1);
    });

    test('should throw exception when athlete is not found', () async {
      // Arrange
      when(mockAthleteRepository.getAthleteById(testAthleteId))
          .thenAnswer((_) async => Result.success(null));

      // Act & Assert
      expect(
          () => useCase.execute(testAthleteId, testImageData),
          throwsA(isA<Exception>().having(
              (e) => e.toString(), 'message', contains('Athlete not found'))));

      verifyNever(mockAvatarRepository.saveAvatar(any, any));
      verifyNever(mockAthleteRepository.updateAthlete(any));
    });

    test('should throw exception when getAthleteById fails', () async {
      // Arrange
      when(mockAthleteRepository.getAthleteById(testAthleteId))
          .thenAnswer((_) async => Result.failure('Database error'));

      // Act & Assert
      expect(
          () => useCase.execute(testAthleteId, testImageData),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('Failed to get athlete: Database error'))));

      verifyNever(mockAvatarRepository.saveAvatar(any, any));
      verifyNever(mockAthleteRepository.updateAthlete(any));
    });

    test('should throw exception when saveAvatar fails', () async {
      // Arrange
      when(mockAthleteRepository.getAthleteById(testAthleteId))
          .thenAnswer((_) async => Result.success(testAthlete));
      when(mockAvatarRepository.saveAvatar(testAthleteId, testImageData))
          .thenThrow(Exception('Failed to save avatar'));

      // Act & Assert
      expect(
          () => useCase.execute(testAthleteId, testImageData),
          throwsA(isA<Exception>().having((e) => e.toString(), 'message',
              contains('Failed to save avatar'))));

      verify(mockAthleteRepository.getAthleteById(testAthleteId)).called(1);
      verifyNever(mockAthleteRepository.updateAthlete(any));
    });

  });
}
