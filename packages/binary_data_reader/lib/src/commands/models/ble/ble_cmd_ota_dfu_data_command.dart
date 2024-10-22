import 'dart:typed_data';
import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class BleCmdOtaDfuDataCommand extends Stv4BaseCommand {
  int isBleModule = 0;
  int chunkSize;
  int offset;
  final Uint8List chunk;

  BleCmdOtaDfuDataCommand({
    required this.isBleModule,
    required this.chunkSize,
    required this.offset,
    required this.chunk,
  });

  @override
  int get commandId => BLECommandTypes.BLE_CMD_OTA_DFU_DATA;

  @override
  Uint8List generatePayload() {
    int currentPacketSize = chunkSize + 5;
    ByteData dfuTransfer = ByteData(currentPacketSize);
    dfuTransfer.setUint8(0, isBleModule);
    dfuTransfer.setUint32(1, offset, Endian.big);
    for (int i = 0; i < chunk.length; i++) {
      dfuTransfer.setUint8(5 + i, chunk[i]);
    }
    return dfuTransfer.buffer.asUint8List();
  }
}
