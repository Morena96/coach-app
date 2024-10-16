import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';

abstract class AthletesService {
  /// Get athletes
  Future<List<Athlete>> getAllAthletes();

  /// Get athletes by page
  Future<List<Athlete>> getAthletesByPage(int page, int pageSize,
      {AthleteFilterCriteria? filterCriteria,
      AthleteSortCriteria? sortCriteria});

  /// Get athletes by filter criteria
  Future<List<Athlete>> getAthletesByFilterCriteria(
      FilterCriteria filterCriteria);

  /// Get athlete by id
  Future<Athlete> getAthleteById(String id);

  /// Create athlete
  Future<Athlete> createAthlete(Athlete athlete);

  /// Update athlete
  Future<Athlete> updateAthlete(Athlete athlete);

  /// Delete athlete
  Future<void> deleteAthlete(String id);

  /// Restore athlete
  Future<Athlete> restoreAthlete(String id);

  /// Get all athletes by ids
  Future<List<Athlete>> getAthletesByIds(List<String> ids);

  /// Reset and refresh database
  Future<void> resetAndRefreshDatabase();

  /// Initialize the database;
  /// Should be called once in the app startup
  Future<void> initializeDatabase();
}
