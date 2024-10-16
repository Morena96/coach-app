import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/shared/utilities/result.dart';

class RestoreAthleteUseCase {
  final Athletes repository;

  RestoreAthleteUseCase(this.repository);

  Future<Result<void>> execute(String athleteId) {
    return repository.restoreAthlete(athleteId);
  }
}
