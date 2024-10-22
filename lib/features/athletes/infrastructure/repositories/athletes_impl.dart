import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/members_service.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';

/// Implementation of the Athletes repository that handles athlete-related operations
/// with error handling and logging capabilities.
class AthletesImpl extends Athletes {
  final AthletesService _dataService;
  final LoggerRepository _loggerRepository;
  final MembersService _membersService;

  /// Creates a new instance of [AthletesImpl].
  ///
  /// Requires [AthletesService] for data operations, [LoggerRepository] for logging,
  /// and [MembersService] for member-related operations.
  AthletesImpl(this._dataService, this._loggerRepository, this._membersService);

  /// Retrieves athletes based on provided filter criteria.
  ///
  /// Returns a [Result] containing either a list of athletes or an error message.
  @override
  Future<Result<List<Athlete>>> getAthletesByFilterCriteria(
      FilterCriteria filterCriteria) async {
    try {
      final athletes =
          await _dataService.getAthletesByFilterCriteria(filterCriteria);
      return Result.success(athletes);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Creates a new athlete record.
  ///
  /// Returns a [Result] containing either the created athlete or an error message.
  @override
  Future<Result<Athlete>> addAthlete(Athlete athlete) async {
    try {
      final response = await _dataService.createAthlete(athlete);
      _loggerRepository
          .info('Athlete created: ${athlete.name} with ID: ${response.id}');
      return Result.success(response);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Deletes an athlete by their ID.
  ///
  /// Returns a [Result] indicating success or failure.
  @override
  Future<Result<void>> deleteAthlete(String id) async {
    try {
      await _dataService.deleteAthlete(id);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Retrieves all athletes.
  ///
  /// Returns a [Result] containing either a list of all athletes or an error message.
  @override
  Future<Result<List<Athlete>>> getAllAthletes() async {
    try {
      final athletes = await _dataService.getAllAthletes();
      return Result.success(athletes);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Retrieves a specific athlete by their ID.
  ///
  /// Returns a [Result] containing either the athlete or an error message.
  @override
  Future<Result<Athlete>> getAthleteById(String id) async {
    try {
      final athlete = await _dataService.getAthleteById(id);
      return Result.success(athlete);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Retrieves a paginated list of athletes with optional filtering and sorting.
  ///
  /// Enriches athletes with their group information from [MembersService].
  /// Returns a [Result] containing either the paginated list or an error message.
  @override
  Future<Result<List<Athlete>>> getAthletesByPage(
    int page,
    int pageSize, {
    AthleteFilterCriteria? filterCriteria,
    AthleteSortCriteria? sortCriteria,
  }) async {
    try {
      final athletes = await _dataService.getAthletesByPage(page, pageSize,
          filterCriteria: filterCriteria, sortCriteria: sortCriteria);

      final athleteIds = athletes.map((athlete) => athlete.id).toList();
      final groupsForAthletes =
          await _membersService.getGroupsForAthletes(athleteIds);

      final athletesWithGroups = athletes.map((athlete) {
        final groups = groupsForAthletes[athlete.id]
                ?.map((member) => member.groupId)
                .toList() ??
            [];
        return athlete.copyWith(groups: groups);
      }).toList();

      return Result.success(athletesWithGroups);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Updates an existing athlete's information.
  ///
  /// Returns a [Result] indicating success or failure.
  @override
  Future<Result<void>> updateAthlete(Athlete athlete) async {
    try {
      await _dataService.updateAthlete(athlete);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Retrieves multiple athletes by their IDs.
  ///
  /// Returns a [Result] containing either the list of athletes or an error message.
  @override
  Future<Result<List<Athlete>>> getAthletesByIds(List<String> ids) async {
    try {
      final athletes = await _dataService.getAthletesByIds(ids);
      return Result.success(athletes);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  /// Restores a previously deleted athlete by their ID.
  ///
  /// Returns a [Result] indicating success or failure.
  @override
  Future<Result<void>> restoreAthlete(String id) async {
    try {
      await _dataService.restoreAthlete(id);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }
}
