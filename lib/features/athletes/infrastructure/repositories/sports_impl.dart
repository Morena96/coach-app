import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/utilities/result.dart';

/// Implementation of the Sports abstract class
class SportsImpl extends Sports {
  final SportsService _dataService;
  final LoggerRepository _loggerRepository;

  /// Creates a new instance of SportsImpl
  ///
  /// [_dataService] The data service for sports operations
  /// [_loggerRepository] The logger repository for error logging
  SportsImpl(this._dataService, this._loggerRepository);

  @override
  Future<Result<List<Sport>>> getAllSports(
      {SportFilterCriteria? filterCriteria}) async {
    try {
      final sports =
          await _dataService.getAllSports(filterCriteria: filterCriteria);
      return Result.success(sports);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Sport>>> getSportsByPage(
    int page,
    int pageSize, {
    SportFilterCriteria? filterCriteria,
  }) async {
    try {
      final sports = await _dataService.getSportsByPage(page, pageSize,
          filterCriteria: filterCriteria);
      return Result.success(sports);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Sport>>> getSportsByIds(List<String> ids) async {
    try {
      final sports = await _dataService.getSportsByIds(ids);
      return Result.success(sports);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Sport>> createSport(Sport sport) async {
    try {
      final createdSport = await _dataService.createSport(sport);
      return Result.success(createdSport);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteSport(String id) async {
    try {
      await _dataService.deleteSport(id);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Sport>> getSportById(String id) async {
    try {
      final sport = await _dataService.getSportById(id);
      return Result.success(sport);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Sport>> updateSport(Sport sport) async {
    try {
      final updatedSport = await _dataService.updateSport(sport);
      return Result.success(updatedSport);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }
}
