import 'dart:typed_data';

import 'package:application/antenna_system/hex_converter.dart';
import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';

class SendAntennaCommandUseCase {
  final AntennaCommandRepository repository;
  final HexConverter hexConverter;

  SendAntennaCommandUseCase(this.repository, this.hexConverter);

  Future<void> call(String portName, String command) async {
    try {
      var data = hexConverter.hexToBytes(command);
      FrameParsingStrategy strategy = GatewayParsingStrategy();

      int crc = strategy.calculateCRC(data);

      var crcList = Uint8List(4)
        ..buffer.asByteData().setInt32(0, crc, Endian.big);

      data = Uint8List.fromList(data + crcList);

      await repository.sendCommand(portName, data);
    } catch (e) {
      // handle error
      rethrow;
    }
  }
}
