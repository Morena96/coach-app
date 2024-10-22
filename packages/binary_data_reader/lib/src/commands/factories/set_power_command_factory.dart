import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/set_power_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:binary_data_reader/src/utils/power_to_dbm_converter.dart';

class SetPowerCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return SetPowerCommand(
      power: PowerToDbmConverter.toDbm(data[0]),
    );
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return SetPowerCommand(
      power: properties['power'],
    );
  }
}
