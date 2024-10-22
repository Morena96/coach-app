import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';
import 'package:binary_data_reader/src/models/rf_mode.dart';
import 'package:binary_data_reader/src/utils/generate_single_byte_list_from_integer.dart';

class SetModeCommand extends Stv4BaseCommand {
  RfMode mode;
  static const int _commandId = CommandTypes.SET_MODE;

  @override
  int get commandId => _commandId;

  @override
  Uint8List generatePayload() => generateSingleByteFromAnInteger(mode.toInt());

  SetModeCommand({required this.mode});
}
