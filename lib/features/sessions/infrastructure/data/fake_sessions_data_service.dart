import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart' as sport;
import 'package:domain/features/sessions/data/sessions_data_service.dart';
import 'package:domain/features/sessions/entities/gps_data_representation.dart';
import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:faker/faker.dart';

class FakeSessionsDataService implements SessionsDataService {
  final List<Session> _sessions = [];
  final AthletesService _athletesService;
  final GroupsService _groupsService;
  final SportsService _sportsService;

  /// Completer to track the initialization status
  final Completer<void> _initCompleter = Completer<void>();

  FakeSessionsDataService({
    required AthletesService athletesService,
    required GroupsService groupsService,
    required SportsService sportsService,
  })  : _athletesService = athletesService,
        _groupsService = groupsService,
        _sportsService = sportsService {
    _initializeDatabase();
  }

  /// Initializes the database and completes the _initCompleter
  Future<void> _initializeDatabase() async {
    await _generateInitialSessions();
    _initCompleter.complete();
  }

  @override
  Future<void> initializeDatabase() async {
    // If already initialized, wait for it to complete
    // Otherwise, this is a no-op as initialization started in the constructor
    await _initCompleter.future;
  }

  @override
  Future<void> resetAndRefreshDatabase() async {
    _sessions.clear();
    await _generateInitialSessions();
  }

  Future<void> _generateInitialSessions() async {
    final allSports = await _sportsService.getAllSports();
    final allGroups = await _groupsService.getAllGroups();
    final allAthletes = await _athletesService.getAllAthletes();

    for (int i = 0; i < 130; i++) {
      final randomSport = allSports[Random().nextInt(allSports.length)];
      final randomGroup = allGroups.isNotEmpty
          ? allGroups[Random().nextInt(allGroups.length)]
          : null;
      final randomAthletes = allAthletes.isNotEmpty
          ? List.generate(Random().nextInt(5) + 1,
              (_) => allAthletes[Random().nextInt(allAthletes.length)])
          : null;

      _sessions.add(SessionFactory.createRandomSession(
        randomSport,
        randomGroup,
        randomAthletes,
      ));
    }
  }

  @override
  Future<List<Session>> getAllSessions() async {
    return Future.delayed(const Duration(milliseconds: 100), () => _sessions);
  }

  @override
  Future<List<Session>> getSessionsByFilterCriteria(
      SessionsFilterCriteria filterCriteria) async {
    return _sessions.where((session) {
      if (filterCriteria.title != null &&
          !session.title
              .toLowerCase()
              .contains(filterCriteria.title!.toLowerCase())) {
        return false;
      }
      if ((filterCriteria.groupId ?? '').isNotEmpty &&
          filterCriteria.groupId != session.assignedGroup.id) {
        return false;
      }
      if ((filterCriteria.sports ?? []).isNotEmpty &&
          !(filterCriteria.sports ?? []).contains(session.sport.id)) {
        return false;
      }
      if (filterCriteria.startTimeFrom != null &&
          session.startTime.isBefore(filterCriteria.startTimeFrom!)) {
        return false;
      }
      if (filterCriteria.startTimeTo != null &&
          session.startTime.isAfter(filterCriteria.startTimeTo!)) {
        return false;
      }
      if (filterCriteria.minDuration != null &&
          session.duration < filterCriteria.minDuration!) {
        return false;
      }
      if (filterCriteria.maxDuration != null &&
          session.duration > filterCriteria.maxDuration!) {
        return false;
      }
      if (filterCriteria.assignedGroups.isNotEmpty &&
          !filterCriteria.assignedGroups.contains(session.assignedGroup.id)) {
        return false;
      }
      if (filterCriteria.selectedAthletes.isNotEmpty &&
          !session.selectedAthletes.any((athlete) =>
              filterCriteria.selectedAthletes.contains(athlete.id))) {
        return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<List<Session>> getSessionsByPage(
    int page,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) async {
    // Wait for initialization to complete before proceeding
    await _initCompleter.future;

    return Future.delayed(const Duration(milliseconds: 100), () async {
      List<Session> filteredSessions = _sessions;

      if (filterCriteria != null && filterCriteria is SessionsFilterCriteria) {
        filteredSessions = await getSessionsByFilterCriteria(filterCriteria);
      }

      if (sortCriteria != null && sortCriteria.field != null) {
        filteredSessions.sort((a, b) {
          int comparison;
          switch (sortCriteria.field) {
            case 'date':
              comparison = a.startTime.isAfter(b.startTime) ? 1 : -1;
              break;
            default:
              comparison = 0;
          }
          return sortCriteria.order == SortOrder.descending
              ? -comparison
              : comparison;
        });
      }

      final startIndex = page * pageSize;
      final endIndex = startIndex + pageSize;

      return filteredSessions.sublist(
          startIndex, min(endIndex, filteredSessions.length));
    });
  }

  @override
  Future<Session?> getSessionById(String id) async {
    return _sessions.firstWhereOrNull((session) => session.id == id);
  }

  @override
  Future<Session> addSession(Session session) async {
    _sessions.add(session);
    return session;
  }

  @override
  Future<void> updateSession(Session session) async {
    final index = _sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      _sessions[index] = session;
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    _sessions.removeWhere((session) => session.id == id);
  }

  @override
  Future<List<Session>> getSessionsByIds(List<String> ids) async {
    return _sessions.where((session) => ids.contains(session.id)).toList();
  }

  @override
  Future<List<Session>> getSessionsForGroup(String groupId) async {
    return _sessions
        .where((session) => session.assignedGroup.id == groupId)
        .toList();
  }

  @override
  Future<List<Session>> getSessionsForAthlete(String athleteId) async {
    return _sessions
        .where((session) =>
            session.selectedAthletes.any((athlete) => athlete.id == athleteId))
        .toList();
  }

  @override
  Future<void> addGpsDataRepresentationToSession(
      String sessionId, GpsDataRepresentation gpsDataRepresentation) async {
    final session = await getSessionById(sessionId);
    if (session != null) {
      final updatedSession = session.copyWith(
        gpsDataRepresentations: [
          ...session.gpsDataRepresentations,
          gpsDataRepresentation
        ],
      );
      await updateSession(updatedSession);
    }
  }

  @override
  Future<void> removeGpsDataRepresentationFromSession(
      String sessionId, String gpsDataRepresentationId) async {
    final session = await getSessionById(sessionId);
    if (session != null) {
      final updatedGpsDataRepresentations = session.gpsDataRepresentations
          .where((gps) => gps.filePath != gpsDataRepresentationId)
          .toList();
      final updatedSession = session.copyWith(
        gpsDataRepresentations: updatedGpsDataRepresentations,
      );
      await updateSession(updatedSession);
    }
  }
}

class SessionFactory {
  static final Faker _faker = Faker();

  static Session createRandomSession(
    sport.Sport sport,
    Group? group,
    List<Athlete>? athletes,
  ) {
    return Session(
      id: _faker.guid.guid(),
      title: _faker.lorem.sentence(),
      sport: sport,
      startTime: _faker.date.dateTime(minYear: 2023, maxYear: 2025),
      duration: Duration(minutes: _faker.randomGenerator.integer(120, min: 30)),
      assignedGroup: group ??
          Group(
              id: _faker.guid.guid(),
              name: _faker.company.name()),
      selectedAthletes: athletes ??
          List.generate(
            _faker.randomGenerator.integer(10, min: 1),
            (_) => Athlete(id: _faker.guid.guid(), name: _faker.person.name()),
          ),
      gpsDataRepresentations: List.generate(
        _faker.randomGenerator.integer(3),
        (_) => GpsDataRepresentation(
          filePath: _faker.internet.uri('https'),
          format: _faker.randomGenerator.element(['csv', 'binary', 'json']),
        ),
      ),
    );
  }
}
