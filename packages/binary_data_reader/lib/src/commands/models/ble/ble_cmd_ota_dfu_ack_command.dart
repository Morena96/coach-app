import 'dart:typed_data';
import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class BleCmdOtaDfuAckCommand extends Stv4BaseCommand {
  BleCmdOtaDfuAckCommand();

  @override
  int get commandId => BLECommandTypes.BLE_CMD_OTA_DFU_ACK;

  @override
  Uint8List generatePayload() {
    return Uint8List(0);
  }
}
