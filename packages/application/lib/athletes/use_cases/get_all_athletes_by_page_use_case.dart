import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetAllAthletesByPageUseCase {
  final Athletes repository;

  GetAllAthletesByPageUseCase(this.repository);

  Future<Result<List<Athlete>>> execute(
    int page,
    int pageSize, {
    AthleteFilterCriteria? filterCriteria,
    AthleteSortCriteria? sortCriteria,
  }) {
    return repository.getAthletesByPage(
      page,
      pageSize,
      filterCriteria: filterCriteria,
      sortCriteria: sortCriteria,
    );
  }
}
