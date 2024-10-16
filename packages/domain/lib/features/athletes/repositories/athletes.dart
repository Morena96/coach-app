import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';

abstract class Athletes {
  /// Get athletes
  Future<Result<List<Athlete>>> getAllAthletes();

  /// Get athletes by filter criteria
  Future<Result<List<Athlete>>> getAthletesByFilterCriteria(
      FilterCriteria filterCriteria);

  /// Get athletes by page
  Future<Result<List<Athlete>>> getAthletesByPage(
    int page,
    int pageSize, {
    AthleteFilterCriteria? filterCriteria,
    AthleteSortCriteria? sortCriteria,
  });

  /// Get athlete by id
  Future<Result<Athlete>> getAthleteById(String id);

  /// Add athlete
  Future<Result<Athlete>> addAthlete(Athlete athlete);

  /// Update athlete
  Future<Result<void>> updateAthlete(Athlete athlete);

  /// Delete athlete
  Future<Result<void>> deleteAthlete(String id);

  /// Get all athletes by ids
  Future<Result<List<Athlete>>> getAthletesByIds(List<String> ids);

  /// Restore athlete
  Future<Result<void>> restoreAthlete(String id);
}
