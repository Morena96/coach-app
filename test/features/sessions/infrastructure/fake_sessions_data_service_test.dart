import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:domain/features/sessions/entities/gps_data_representation.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:coach_app/features/sessions/infrastructure/data/fake_sessions_data_service.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AthletesService, GroupsService, SportsService])

import 'fake_sessions_data_service_test.mocks.dart';

void main() {
  late FakeSessionsDataService fakeSessionsDataService;
  late MockAthletesService mockAthletesService;
  late MockGroupsService mockGroupsService;
  late MockSportsService mockSportsService;

  setUp(() {
    mockAthletesService = MockAthletesService();
    mockGroupsService = MockGroupsService();
    mockSportsService = MockSportsService();

    when(mockSportsService.getAllSports()).thenAnswer((_) async => [
      const Sport(id: '1', name: 'Test Sport'),
      const Sport(id: '2', name: 'Test Sport 2'),
    ]);

    when(mockGroupsService.getAllGroups()).thenAnswer((_) async => [
      const Group(id: '1', name: 'Test Group'),
      const Group(id: '2', name: 'Test Group 2'),
    ]);

    when(mockAthletesService.getAllAthletes()).thenAnswer((_) async => [
      const Athlete(id: '1', name: 'Test Athlete'),
      const Athlete(id: '2', name: 'Test Athlete 2'),
    ]);

    fakeSessionsDataService = FakeSessionsDataService(
      athletesService: mockAthletesService,
      groupsService: mockGroupsService,
      sportsService: mockSportsService,
    );
  });

  group('FakeSessionsDataService', () {
    test('getAllSessions returns a non-empty list', () async {
      final sessions = await fakeSessionsDataService.getAllSessions();
      expect(sessions, isNotEmpty);
    });

    test('getSessionsByFilterCriteria returns filtered sessions', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final sportToFilter = allSessions.first.sport.id;
      final filterCriteria = SessionsFilterCriteria(sports: [sportToFilter]);
      final filteredSessions = await fakeSessionsDataService.getSessionsByFilterCriteria(filterCriteria);
      expect(filteredSessions, isNotEmpty);
      expect(filteredSessions.every((session) => session.sport.id == sportToFilter), isTrue);
    });

    test('getSessionsByPage returns correct number of sessions', () async {
      final page1 = await fakeSessionsDataService.getSessionsByPage(1, 10);
      expect(page1.length, equals(10));

      final page2 = await fakeSessionsDataService.getSessionsByPage(2, 10);
      expect(page2.length, equals(10));
    });

    test('getSessionById returns correct session', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final targetSession = allSessions.first;
      final retrievedSession = await fakeSessionsDataService.getSessionById(targetSession.id);
      expect(retrievedSession, equals(targetSession));
    });

    test('addSession adds a new session', () async {
      const sport = Sport(id: '1', name: 'Test Sport');
      final newSession = SessionFactory.createRandomSession(sport, null, null);
      await fakeSessionsDataService.addSession(newSession);
      final retrievedSession = await fakeSessionsDataService.getSessionById(newSession.id);
      expect(retrievedSession, equals(newSession));
    });

    test('updateSession updates an existing session', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final sessionToUpdate = allSessions.first;
      final updatedSession = sessionToUpdate.copyWith(title: 'Updated Title');
      await fakeSessionsDataService.updateSession(updatedSession);
      final retrievedSession = await fakeSessionsDataService.getSessionById(sessionToUpdate.id);
      expect(retrievedSession?.title, equals('Updated Title'));
    });

    test('deleteSession removes a session', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final sessionToDelete = allSessions.first;
      await fakeSessionsDataService.deleteSession(sessionToDelete.id);
      final retrievedSession = await fakeSessionsDataService.getSessionById(sessionToDelete.id);
      expect(retrievedSession, isNull);
    });

    test('getSessionsByIds returns correct sessions', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final targetIds = allSessions.take(3).map((s) => s.id).toList();
      final retrievedSessions = await fakeSessionsDataService.getSessionsByIds(targetIds);
      expect(retrievedSessions.length, equals(3));
      expect(retrievedSessions.map((s) => s.id).toList(), equals(targetIds));
    });

    test('getSessionsForGroup returns sessions for a specific group', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final targetGroup = allSessions.first.assignedGroup;
      final groupSessions = await fakeSessionsDataService.getSessionsForGroup(targetGroup.id);
      expect(groupSessions, isNotEmpty);
      expect(groupSessions.every((s) => s.assignedGroup.id == targetGroup.id), isTrue);
    });

    test('getSessionsForAthlete returns sessions for a specific athlete', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final targetAthlete = allSessions.first.selectedAthletes.first;
      final athleteSessions = await fakeSessionsDataService.getSessionsForAthlete(targetAthlete.id);
      expect(athleteSessions, isNotEmpty);
      expect(athleteSessions.every((s) => s.selectedAthletes.any((a) => a.id == targetAthlete.id)), isTrue);
    });

    test('addGpsDataRepresentationToSession adds GPS data to a session', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final targetSession = allSessions.first;
      final newGpsData = GpsDataRepresentation(filePath: 'new/path', format: 'csv');
      await fakeSessionsDataService.addGpsDataRepresentationToSession(targetSession.id, newGpsData);
      final updatedSession = await fakeSessionsDataService.getSessionById(targetSession.id);
      expect(updatedSession?.gpsDataRepresentations, contains(newGpsData));
    });

    test('removeGpsDataRepresentationFromSession removes GPS data from a session', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final targetSession = allSessions.firstWhere((s) => s.gpsDataRepresentations.isNotEmpty);
      final gpsDataToRemove = targetSession.gpsDataRepresentations.first;
      await fakeSessionsDataService.removeGpsDataRepresentationFromSession(targetSession.id, gpsDataToRemove.filePath);
      final updatedSession = await fakeSessionsDataService.getSessionById(targetSession.id);
      expect(updatedSession?.gpsDataRepresentations, isNot(contains(gpsDataToRemove)));
    });

    test('getSessionsByFilterCriteria with multiple criteria', () async {
      final allSessions = await fakeSessionsDataService.getAllSessions();
      final sportToFilter = allSessions.first.sport.id;
      final groupToFilter = allSessions.first.assignedGroup.id;
      final athleteToFilter = allSessions.first.selectedAthletes.first.id;

      final filterCriteria = SessionsFilterCriteria(
        sports: [sportToFilter],
        assignedGroups: [groupToFilter],
        selectedAthletes: [athleteToFilter],
        startTimeFrom: DateTime(2022),
        startTimeTo: DateTime(2025),
      );

      final filteredSessions = await fakeSessionsDataService.getSessionsByFilterCriteria(filterCriteria);
      expect(filteredSessions, isNotEmpty);
      for (final session in filteredSessions) {
        expect(session.sport.id, equals(sportToFilter));
        expect(session.assignedGroup.id, equals(groupToFilter));
        expect(session.selectedAthletes.map((a)=>a.id), contains(athleteToFilter));
        expect(session.startTime.isAfter(DateTime(2022)), isTrue);
        expect(session.startTime.isBefore(DateTime(2025)), isTrue);
      }
    });
  });
}

