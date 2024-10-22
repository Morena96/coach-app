import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/reset_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
class ResetCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return ResetCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return ResetCommand();
  }
}
