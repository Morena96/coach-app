import 'dart:typed_data';
import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class BleCmdOtaDfuDoneCommand extends Stv4BaseCommand {
  BleCmdOtaDfuDoneCommand();

  @override
  int get commandId => BLECommandTypes.BLE_CMD_OTA_DFU_DONE;

  Uint8List generatePayload() {
    ByteData dfuDone = ByteData(1);
    dfuDone.setUint8(0, 0x00);

    return dfuDone.buffer.asUint8List();
  }
}
