import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/set_mode_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:binary_data_reader/src/models/rf_mode.dart';

class SetModeCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return SetModeCommand(mode: RfMode.fromInt(data[0]));
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return SetModeCommand(mode: properties['mode']);
  }
}
