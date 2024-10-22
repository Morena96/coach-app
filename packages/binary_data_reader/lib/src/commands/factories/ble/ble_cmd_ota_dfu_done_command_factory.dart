import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/ble_cmd_ota_dfu_done_command.dart';

class BleCmdOtaDfuDoneCommandFactory
    implements CommandFactory<BleCmdOtaDfuDoneCommand> {
  @override
  BleCmdOtaDfuDoneCommand fromBinary(Uint8List data) {
    return BleCmdOtaDfuDoneCommand();
  }

  @override
  BleCmdOtaDfuDoneCommand fromProperties(Map<String, dynamic> properties) {
    return BleCmdOtaDfuDoneCommand();
  }
}
