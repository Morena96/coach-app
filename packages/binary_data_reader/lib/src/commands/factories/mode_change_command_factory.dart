import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/mode_change.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class ModeChangeCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    int lastMode = data[0];
    int currentMode = data[1];
    return ModeChangeCommand(lastMode: lastMode, currentMode: currentMode);
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return ModeChangeCommand(
      lastMode: properties['lastMode'],
      currentMode: properties['currentMode'],
    );
  }
}
