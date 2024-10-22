import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';
import 'package:binary_data_reader/src/utils/generate_single_byte_list_from_integer.dart';
import 'package:binary_data_reader/src/utils/power_to_dbm_converter.dart';

class SetPowerCommand extends Stv4BaseCommand {
  int power;
  static const int _commandId = CommandTypes.SET_POWER;

  @override
  int get commandId => _commandId;

  @override
  Uint8List generatePayload() =>
      generateSingleByteFromAnInteger(PowerToDbmConverter.fromDbm(power));

  SetPowerCommand({required this.power});
}
