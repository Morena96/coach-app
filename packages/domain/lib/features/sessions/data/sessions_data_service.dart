import 'package:domain/features/sessions/entities/gps_data_representation.dart';
import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_criteria.dart';

abstract class SessionsDataService {
  /// Get all sessions
  Future<List<Session>> getAllSessions();

  /// Get sessions by filter criteria
  Future<List<Session>> getSessionsByFilterCriteria(
      SessionsFilterCriteria filterCriteria);

  /// Get sessions by page
  Future<List<Session>> getSessionsByPage(
    int page,
    int pageSize, {
    FilterCriteria? filterCriteria,
    SortCriteria? sortCriteria,
  });

  /// Get session by id
  Future<Session?> getSessionById(String id);

  /// Add session
  Future<Session> addSession(Session session);

  /// Update session
  Future<void> updateSession(Session session);

  /// Delete session
  Future<void> deleteSession(String id);

  /// Get all sessions by ids
  Future<List<Session>> getSessionsByIds(List<String> ids);

  /// Get sessions for a specific group
  Future<List<Session>> getSessionsForGroup(String groupId);

  /// Get sessions for a specific athlete
  Future<List<Session>> getSessionsForAthlete(String athleteId);

  /// Add GPS data representation to a session
  Future<void> addGpsDataRepresentationToSession(
      String sessionId, GpsDataRepresentation gpsDataRepresentation);

  /// Remove GPS data representation from a session
  Future<void> removeGpsDataRepresentationFromSession(
      String sessionId, String gpsDataRepresentationId);

  /// Reset and refresh database
  Future<void> resetAndRefreshDatabase();

  /// Initialize the database;
  /// Should be called once in the app startup
  Future<void> initializeDatabase();
}
