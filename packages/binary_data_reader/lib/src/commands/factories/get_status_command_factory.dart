import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/get_status.dart';

class GetStatusCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return GetStatusCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return GetStatusCommand();
  }
}
