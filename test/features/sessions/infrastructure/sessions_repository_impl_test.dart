
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/features/sessions/data/sessions_data_service.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/sessions/entities/gps_data_representation.dart';
import 'package:coach_app/features/sessions/infrastructure/repositories/sessions_repository_impl.dart';

@GenerateMocks([SessionsDataService, LoggerRepository])
import 'sessions_repository_impl_test.mocks.dart';

void main() {
  late SessionsRepositoryImpl sessionsRepository;
  late MockSessionsDataService mockDataService;
  late MockLoggerRepository mockLoggerRepository;

  setUp(() {
    mockDataService = MockSessionsDataService();
    mockLoggerRepository = MockLoggerRepository();
    sessionsRepository = SessionsRepositoryImpl(mockDataService, mockLoggerRepository);
  });

  group('SessionsRepositoryImpl', () {
    const testGroup = Group(id: 'group1', name: 'Test Group', members: []);
    const testAthlete = Athlete(id: 'athlete1', name: 'Test Athlete');
    const testSport = Sport(id: 'sport1', name: 'Test Sport');
    final testSession = Session(
      id: 'session1',
      title: 'Test Session',
      sport: testSport,
      startTime: DateTime.now(),
      duration: const Duration(hours: 1),
      assignedGroup: testGroup,
      selectedAthletes: [testAthlete],
      gpsDataRepresentations: [],
    );

    test('getAllSessions should return success result with list of sessions', () async {
      when(mockDataService.getAllSessions()).thenAnswer((_) => Future.value([testSession]));

      final result = await sessionsRepository.getAllSessions();

      expect(result.isSuccess, isTrue);
      expect(result.value, [testSession]);
      verify(mockDataService.getAllSessions()).called(1);
    });

    test('getAllSessions should return failure result when an error occurs', () async {
      when(mockDataService.getAllSessions()).thenThrow(Exception('Failed to get sessions'));

      final result = await sessionsRepository.getAllSessions();

      expect(result.isFailure, isTrue);
      expect(result.error, 'Exception: Failed to get sessions');
      verify(mockLoggerRepository.error('Exception: Failed to get sessions')).called(1);
    });

    test('getSessionsByFilterCriteria should return success result with filtered sessions', () async {
      final filterCriteria = SessionsFilterCriteria();
      when(mockDataService.getSessionsByFilterCriteria(filterCriteria))
          .thenAnswer((_) => Future.value([testSession]));

      final result = await sessionsRepository.getSessionsByFilterCriteria(filterCriteria);

      expect(result.isSuccess, isTrue);
      expect(result.value, [testSession]);
      verify(mockDataService.getSessionsByFilterCriteria(filterCriteria)).called(1);
    });

    test('getSessionById should return success result with the correct session', () async {
      when(mockDataService.getSessionById('session1')).thenAnswer((_) => Future.value(testSession));

      final result = await sessionsRepository.getSessionById('session1');

      expect(result.isSuccess, isTrue);
      expect(result.value, testSession);
      verify(mockDataService.getSessionById('session1')).called(1);
    });

    test('addSession should return success result when session is added', () async {
      when(mockDataService.addSession(testSession)).thenAnswer((_) => Future.value(testSession));

      final result = await sessionsRepository.addSession(testSession);

      expect(result.isSuccess, isTrue);
      expect(result.value, testSession);
      verify(mockDataService.addSession(testSession)).called(1);
    });

    test('updateSession should return success result when session is updated', () async {
      when(mockDataService.updateSession(testSession)).thenAnswer((_) => Future.value());

      final result = await sessionsRepository.updateSession(testSession);

      expect(result.isSuccess, isTrue);
      verify(mockDataService.updateSession(testSession)).called(1);
    });

    test('deleteSession should return success result when session is deleted', () async {
      when(mockDataService.deleteSession('session1')).thenAnswer((_) => Future.value());

      final result = await sessionsRepository.deleteSession('session1');

      expect(result.isSuccess, isTrue);
      verify(mockDataService.deleteSession('session1')).called(1);
    });

    test('getSessionsByIds should return success result with correct sessions', () async {
      when(mockDataService.getSessionsByIds(['session1'])).thenAnswer((_) => Future.value([testSession]));

      final result = await sessionsRepository.getSessionsByIds(['session1']);

      expect(result.isSuccess, isTrue);
      expect(result.value, [testSession]);
      verify(mockDataService.getSessionsByIds(['session1'])).called(1);
    });

    test('getSessionsForGroup should return success result with correct sessions', () async {
      when(mockDataService.getSessionsForGroup('group1')).thenAnswer((_) => Future.value([testSession]));

      final result = await sessionsRepository.getSessionsForGroup('group1');

      expect(result.isSuccess, isTrue);
      expect(result.value, [testSession]);
      verify(mockDataService.getSessionsForGroup('group1')).called(1);
    });

    test('getSessionsForAthlete should return success result with correct sessions', () async {
      when(mockDataService.getSessionsForAthlete('athlete1')).thenAnswer((_) => Future.value([testSession]));

      final result = await sessionsRepository.getSessionsForAthlete('athlete1');

      expect(result.isSuccess, isTrue);
      expect(result.value, [testSession]);
      verify(mockDataService.getSessionsForAthlete('athlete1')).called(1);
    });

    test('addGpsDataRepresentationToSession should return success result', () async {
      final gpsData = GpsDataRepresentation(filePath: 'path', format: 'format');
      when(mockDataService.addGpsDataRepresentationToSession('session1', gpsData)).thenAnswer((_) => Future.value());

      final result = await sessionsRepository.addGpsDataRepresentationToSession('session1', gpsData);

      expect(result.isSuccess, isTrue);
      verify(mockDataService.addGpsDataRepresentationToSession('session1', gpsData)).called(1);
    });

    test('removeGpsDataRepresentationFromSession should return success result', () async {
      when(mockDataService.removeGpsDataRepresentationFromSession('session1', 'gps1')).thenAnswer((_) => Future.value());

      final result = await sessionsRepository.removeGpsDataRepresentationFromSession('session1', 'gps1');

      expect(result.isSuccess, isTrue);
      verify(mockDataService.removeGpsDataRepresentationFromSession('session1', 'gps1')).called(1);
    });
  });
}
