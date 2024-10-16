import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetAthleteByIdUseCase {
  final Athletes repository;

  GetAthleteByIdUseCase(this.repository);

  Future<Result<Athlete>> execute(String athleteId) {
    return repository.getAthleteById(athleteId);
  }
}
