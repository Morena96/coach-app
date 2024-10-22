import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/ble_cmd_ota_dfu_data_command.dart';

class BleCmdOtaDfuDataCommandFactory
    implements CommandFactory<BleCmdOtaDfuDataCommand> {
  @override
  BleCmdOtaDfuDataCommand fromBinary(Uint8List data) {
    return BleCmdOtaDfuDataCommand(
      isBleModule: data[0],
      chunkSize: data[1],
      offset: data[3],
      chunk: data.sublist(3),
    );
  }

  @override
  BleCmdOtaDfuDataCommand fromProperties(Map<String, dynamic> properties) {
    return BleCmdOtaDfuDataCommand(
      isBleModule: properties['isBleModule'],
      chunkSize: properties['chunkSize'],
      offset: properties['offset'],
      chunk: properties['chunk'],
    );
  }
}
