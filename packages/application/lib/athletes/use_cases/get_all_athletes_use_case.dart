import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';

class GetAllAthletesUseCase {
  final Athletes repository;

  GetAllAthletesUseCase(this.repository);

  Future<Result<List<Athlete>>> execute({FilterCriteria? filterCriteria}) {
    if (filterCriteria != null) {
      return repository.getAthletesByFilterCriteria(filterCriteria);
    }

    return repository.getAllAthletes();
  }
}
