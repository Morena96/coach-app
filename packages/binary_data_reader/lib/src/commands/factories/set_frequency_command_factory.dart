import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/set_frequency_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class SetFrequencyCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return SetFrequencyCommand(
      frequency: data[0],
    );
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return SetFrequencyCommand(
      frequency: properties['frequency'],
    );
  }
}
