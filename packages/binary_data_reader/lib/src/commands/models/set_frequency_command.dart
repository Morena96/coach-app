import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';
import 'package:binary_data_reader/src/utils/generate_single_byte_list_from_integer.dart';

class SetFrequencyCommand extends Stv4BaseCommand {
  int frequency;
  static const int _commandId = CommandTypes.SET_FREQUENCY;

  @override
  int get commandId => _commandId;

  @override
  Uint8List generatePayload() => generateSingleByteFromAnInteger(frequency);

  SetFrequencyCommand({required this.frequency});
}
