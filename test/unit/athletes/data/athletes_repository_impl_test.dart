import 'package:coach_app/features/athletes/infrastructure/repositories/athletes_impl.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/members_service.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AthletesService, LoggerRepository, MembersService])
import 'athletes_repository_impl_test.mocks.dart';

void main() {
  late AthletesImpl athletesRepository;
  late MockAthletesService mockService;
  late LoggerRepository mockLoggerRepository;
  late MockMembersService mockMembersService;

  setUp(() {
    mockService = MockAthletesService();
    mockLoggerRepository = MockLoggerRepository();
    mockMembersService = MockMembersService();
    athletesRepository = AthletesImpl(mockService, mockLoggerRepository, mockMembersService);
  });

  group('AthletesImpl', () {
    test('addAthlete should return success result when athlete is added',
        () async {
      const athlete = Athlete(id: '1', name: 'John Doe');
      when(mockService.createAthlete(athlete))
          .thenAnswer((_) => Future.value(athlete));

      final result = await athletesRepository.addAthlete(athlete);

      expect(result.isSuccess, isTrue);
    });

    test('addAthlete should return failure result when an error occurs',
        () async {
      const athlete = Athlete(id: '1', name: 'John Doe');
      when(mockService.createAthlete(athlete))
          .thenThrow(Exception('Failed to add athlete'));

      final result = await athletesRepository.addAthlete(athlete);

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Exception: Failed to add athlete'));
    });

    test('deleteAthlete should return success result when athlete is deleted',
        () async {
      when(mockService.deleteAthlete('1')).thenAnswer((_) => Future.value());

      final result = await athletesRepository.deleteAthlete('1');

      expect(result.isSuccess, isTrue);
    });


    test('restoreAthlete should return success result when athlete is restored',
        () async {
      const restoredAthlete = Athlete(id: '1', name: 'John Doe', archived: false);
      when(mockService.restoreAthlete('1')).thenAnswer((_) => Future.value(restoredAthlete));

      final result = await athletesRepository.restoreAthlete('1');

      expect(result.isSuccess, isTrue);
      verify(mockService.restoreAthlete('1')).called(1);
    });

    test('restoreAthlete should return failure result when an error occurs',
        () async {
      when(mockService.restoreAthlete('1'))
          .thenThrow(Exception('Failed to restore athlete'));

      final result = await athletesRepository.restoreAthlete('1');

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Exception: Failed to restore athlete'));
      verify(mockService.restoreAthlete('1')).called(1);
      verify(mockLoggerRepository.error('Exception: Failed to restore athlete')).called(1);
    });

    test('deleteAthlete should return failure result when an error occurs',
        () async {
      when(mockService.deleteAthlete('1'))
          .thenThrow(Exception('Failed to delete athlete'));

      final result = await athletesRepository.deleteAthlete('1');

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Exception: Failed to delete athlete'));
    });

    test('getAllAthletes should return success result with list of athletes',
        () async {
      final athletes = [
        const Athlete(id: '1', name: 'John Doe'),
        const Athlete(id: '2', name: 'Jane Doe'),
      ];
      when(mockService.getAllAthletes())
          .thenAnswer((_) => Future.value(athletes));

      final result = await athletesRepository.getAllAthletes();

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(athletes));
    });

    test('getAllAthletes should return failure result when an error occurs',
        () async {
      when(mockService.getAllAthletes())
          .thenThrow(Exception('Failed to get athletes'));

      final result = await athletesRepository.getAllAthletes();

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Exception: Failed to get athletes'));
    });

    test(
        'getAllAthletesByFilterCriteria should return success result with list of athletes',
        () async {
      final athletes = [
        const Athlete(id: '1', name: 'John Doe'),
        const Athlete(id: '2', name: 'Jane Doe'),
      ];
      when(mockService.getAthletesByFilterCriteria(any))
          .thenAnswer((_) => Future.value(athletes));

      final result = await athletesRepository
          .getAthletesByFilterCriteria(AthleteFilterCriteria(name: 'John'));

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(athletes));
    });

    test('getAthleteById should return success result with the correct athlete',
        () async {
      const athlete = Athlete(id: '1', name: 'John Doe');
      when(mockService.getAthleteById('1'))
          .thenAnswer((_) => Future.value(athlete));

      final result = await athletesRepository.getAthleteById('1');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(athlete));
    });

    test(
        'getAthleteById should return failure result when athlete is not found',
        () async {
      when(mockService.getAthleteById('1'))
          .thenThrow(Exception('Athlete not found'));

      final result = await athletesRepository.getAthleteById('1');

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Exception: Athlete not found'));
    });

    test(
        'getAthletesByPage should return success result with correct page of athletes',
        () async {
      final athletes = List.generate(
        5,
        (index) => Athlete(id: index.toString(), name: 'Athlete $index'),
      );
      when(mockService.getAthletesByPage(1, 5))
          .thenAnswer((_) => Future.value(athletes));
      when(mockMembersService.getGroupsForAthletes(any))
          .thenAnswer((_) => Future.value({}));

      final result = await athletesRepository.getAthletesByPage(1, 5);

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(athletes));
    });

    test('getAthletesByPage should return failure result when an error occurs',
        () async {
      when(mockService.getAthletesByPage(1, 5))
          .thenThrow(Exception('Failed to get athletes'));

      final result = await athletesRepository.getAthletesByPage(1, 5);

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Exception: Failed to get athletes'));
    });

    test('updateAthlete should return success result when athlete is updated',
        () async {
      const athlete = Athlete(id: '1', name: 'John Doe Updated');
      when(mockService.updateAthlete(athlete))
          .thenAnswer((_) => Future.value(athlete));

      final result = await athletesRepository.updateAthlete(athlete);

      expect(result.isSuccess, isTrue);
    });

    test('updateAthlete should return failure result when an error occurs',
        () async {
      const athlete = Athlete(id: '1', name: 'John Doe Updated');
      when(mockService.updateAthlete(athlete))
          .thenThrow(Exception('Failed to update athlete'));

      final result = await athletesRepository.updateAthlete(athlete);

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Exception: Failed to update athlete'));
    });
  });
}
