import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class EraseMemoryCommand extends Stv4BaseCommand {
  static const int _commandId = CommandTypes.ERASE_MEMORY;

  @override
  int get commandId => _commandId;

  // this command doesn't generate a payload when sending to the device
  @override
  Uint8List generatePayload() => Uint8List(0);
}