import 'package:domain/features/sessions/entities/gps_data_representation.dart';
import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:domain/features/sessions/value_objects/sessions_sort_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';

abstract class SessionsRepository {
  /// Get all sessions
  Future<Result<List<Session>>> getAllSessions();

  /// Get sessions by filter criteria
  Future<Result<List<Session>>> getSessionsByFilterCriteria(
      SessionsFilterCriteria filterCriteria);

  /// Get sessions by page
  Future<Result<List<Session>>> getSessionsByPage(
    int page,
    int pageSize, {
    SessionsFilterCriteria? filterCriteria,
    SessionsSortCriteria? sortCriteria,
  });

  /// Get session by id
  Future<Result<Session>> getSessionById(String id);

  /// Add session
  Future<Result<Session>> addSession(Session session);

  /// Update session
  Future<Result<void>> updateSession(Session session);

  /// Delete session
  Future<Result<void>> deleteSession(String id);

  /// Get all sessions by ids
  Future<Result<List<Session>>> getSessionsByIds(List<String> ids);

  /// Get sessions for a specific group
  Future<Result<List<Session>>> getSessionsForGroup(String groupId);

  /// Get sessions for a specific athlete
  Future<Result<List<Session>>> getSessionsForAthlete(String athleteId);

  /// Add GPS data representation to a session
  Future<Result<void>> addGpsDataRepresentationToSession(
      String sessionId, GpsDataRepresentation gpsDataRepresentation);

  /// Remove GPS data representation from a session
  Future<Result<void>> removeGpsDataRepresentationFromSession(
      String sessionId, String gpsDataRepresentationId);
}
