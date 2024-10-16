import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetAllSportsUseCase {
  final Sports repository;

  GetAllSportsUseCase(this.repository);

  Future<Result<List<Sport>>> execute() {
    return repository.getAllSports();
  }
}
