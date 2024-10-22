import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/mode_command_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class ModeCommandCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return ModeCommandCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return ModeCommandCommand();
  }
}
