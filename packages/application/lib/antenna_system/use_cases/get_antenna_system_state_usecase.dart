import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:domain/features/antenna_system/repositories/antenna_system_repository.dart';

class GetAntennaSystemStateUseCase {
  final AntennaSystemRepository repository;

  GetAntennaSystemStateUseCase(this.repository);

  Stream<(AntennaSystemState, List<AntennaInfo>)> call() {
    return repository.getAntennaSystemStream();
  }
}
