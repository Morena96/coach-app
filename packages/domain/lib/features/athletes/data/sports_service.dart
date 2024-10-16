import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart';

abstract class SportsService {
  /// Get all sports
  Future<List<Sport>> getAllSports({SportFilterCriteria? filterCriteria});

  Future<List<Sport>> getSportsByPage(
    int page,
    int pageSize, {
    SportFilterCriteria? filterCriteria,
  });

  /// Get all sports by ids
  Future<List<Sport>> getSportsByIds(List<String> ids);

  /// Create a new sport
  Future<Sport> createSport(Sport sport);

  /// Delete a sport by its ID
  Future<void> deleteSport(String id);

  /// Get a sport by its ID
  Future<Sport> getSportById(String id);

  /// Update an existing sport
  Future<Sport> updateSport(Sport sport);
}
