import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/shared/utilities/result.dart';

class DeleteAthleteUseCase {
  final Athletes repository;

  DeleteAthleteUseCase(this.repository);

  Future<Result<void>> execute(String athleteId) {
    return repository.deleteAthlete(athleteId);
  }
}
