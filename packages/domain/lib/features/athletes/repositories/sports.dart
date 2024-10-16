import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';

abstract class Sports {
  /// Get all sports
  Future<Result<List<Sport>>> getAllSports(
      {SportFilterCriteria? filterCriteria});

  /// Get sports by page
  Future<Result<List<Sport>>> getSportsByPage(
    int page,
    int pageSize, {
    SportFilterCriteria? filterCriteria,
  });

  /// Get all sports by ids
  Future<Result<List<Sport>>> getSportsByIds(List<String> ids);

  /// Create a new sport
  Future<Result<Sport>> createSport(Sport sport);

  /// Delete a sport by its ID
  Future<Result<void>> deleteSport(String id);

  /// Get a sport by its ID
  Future<Result<Sport>> getSportById(String id);

  /// Update an existing sport
  Future<Result<Sport>> updateSport(Sport sport);
}
