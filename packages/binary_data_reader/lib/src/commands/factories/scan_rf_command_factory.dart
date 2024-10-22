import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:binary_data_reader/src/commands/models/scan_rf_command.dart';

class ScanRfCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return ScanRfCommand(frequency: data[0], rssiData: data.sublist(1));
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return ScanRfCommand(
        frequency: properties['frequency'], rssiData: properties['rssiData']);
  }
}
