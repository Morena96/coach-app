import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/set_state_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:binary_data_reader/src/models/rf_mode.dart';
import 'package:binary_data_reader/src/models/sensor_mode.dart';

class SetStateCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    List<SensorMode> rfSlotStates = [];

    for (int i = 0; i < 15; i++) {
      rfSlotStates.add(SensorMode.fromValue(data[i]));
    }

    return SetStateCommand(
      // rfSlotStates is the first 15 bytes of the data
      rfSlotStates: rfSlotStates,
    );
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return SetStateCommand(
      rfSlotStates: List<SensorMode>.from(
        (properties['rfSlotStates'] as List).map((e) => e),
      ),
    );
  }
}
