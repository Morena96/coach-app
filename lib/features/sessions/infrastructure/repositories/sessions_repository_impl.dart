import 'package:domain/features/sessions/data/sessions_data_service.dart';
import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/sessions/entities/gps_data_representation.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';

class SessionsRepositoryImpl implements SessionsRepository {
  final SessionsDataService _dataService;
  final LoggerRepository _loggerRepository;

  SessionsRepositoryImpl(this._dataService, this._loggerRepository);

  @override
  Future<Result<List<Session>>> getAllSessions() async {
    try {
      final sessions = await _dataService.getAllSessions();
      return Result.success(sessions);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Session>>> getSessionsByFilterCriteria(
      SessionsFilterCriteria filterCriteria) async {
    try {
      final sessions =
          await _dataService.getSessionsByFilterCriteria(filterCriteria);
      return Result.success(sessions);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Session>>> getSessionsByPage(
    int page,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  }) async {
    try {
      final sessions = await _dataService.getSessionsByPage(
        page,
        pageSize,
        filterCriteria: filterCriteria,
        sortCriteria: sortCriteria,
      );
      return Result.success(sessions);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Session>> getSessionById(String id) async {
    try {
      final session = await _dataService.getSessionById(id);
      return Result.success(session);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Session>> addSession(Session session) async {
    try {
      final addedSession = await _dataService.addSession(session);
      return Result.success(addedSession);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> updateSession(Session session) async {
    try {
      await _dataService.updateSession(session);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteSession(String id) async {
    try {
      await _dataService.deleteSession(id);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Session>>> getSessionsByIds(List<String> ids) async {
    try {
      final sessions = await _dataService.getSessionsByIds(ids);
      return Result.success(sessions);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Session>>> getSessionsForGroup(String groupId) async {
    try {
      final sessions = await _dataService.getSessionsForGroup(groupId);
      return Result.success(sessions);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Session>>> getSessionsForAthlete(String athleteId) async {
    try {
      final sessions = await _dataService.getSessionsForAthlete(athleteId);
      return Result.success(sessions);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> addGpsDataRepresentationToSession(
      String sessionId, GpsDataRepresentation gpsDataRepresentation) async {
    try {
      await _dataService.addGpsDataRepresentationToSession(
          sessionId, gpsDataRepresentation);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> removeGpsDataRepresentationFromSession(
      String sessionId, String gpsDataRepresentationId) async {
    try {
      await _dataService.removeGpsDataRepresentationFromSession(
          sessionId, gpsDataRepresentationId);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }
}
