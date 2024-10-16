import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetAllSportsByPageUseCase {
  final Sports repository;

  GetAllSportsByPageUseCase(this.repository);

  Future<Result<List<Sport>>> execute(
    int page,
    int pageSize, {
    SportFilterCriteria? filterCriteria,
  }) {
    return repository.getSportsByPage(
      page,
      pageSize,
      filterCriteria: filterCriteria,
    );
  }
}
