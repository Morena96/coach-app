import 'package:application/antenna_system/hex_converter.dart';
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart';

class GetAntennaDataStreamUseCase {
  final AntennaDataRepository repository;
  final HexConverter hexConverter;

  GetAntennaDataStreamUseCase(this.repository, this.hexConverter);

  Stream<String> call(String portName) {
    return hexConverter.streamToHex(repository.getDataStream(portName));
  }
}
