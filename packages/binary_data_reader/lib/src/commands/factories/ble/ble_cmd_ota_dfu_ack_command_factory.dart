import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/ble_cmd_ota_dfu_ack_command.dart';

class BleCmdOtaDfuAckCommandFactory
    implements CommandFactory<BleCmdOtaDfuAckCommand> {
  @override
  BleCmdOtaDfuAckCommand fromBinary(Uint8List data) {
    return BleCmdOtaDfuAckCommand();
  }

  @override
  BleCmdOtaDfuAckCommand fromProperties(Map<String, dynamic> properties) {
    return BleCmdOtaDfuAckCommand();
  }
}
