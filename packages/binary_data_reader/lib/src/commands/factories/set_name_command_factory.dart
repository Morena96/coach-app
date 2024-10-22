import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/mode_change.dart';
import 'package:binary_data_reader/src/commands/models/ble/set_name.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class SetNameCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return SetNameCommand(
      name: data[0],
    );
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return SetNameCommand(
      name: properties['name'],
    );
  }
}
