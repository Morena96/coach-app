import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/erase_memory_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
class EraseMemoryCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return EraseMemoryCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return EraseMemoryCommand();
  }
}
