import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/mode_live_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
class ModeLiveCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return ModeLiveCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return ModeLiveCommand();
  }
}
