import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/current_status.dart';

class CurrentStatusCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    final buffer = data.buffer.asByteData();

    // deviceId is bytes 5-12
    final int deviceId = buffer.getUint64(5);

    return CurrentStatusCommand(
      deviceId: deviceId,
      charge: data[8],
      batteryPercent: data[9],
      fwVersionMajor: data[10],
      fwVersionMinor: data[11],
      fwVersionPatch: data[12],
      mode: data[13],
    );
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return CurrentStatusCommand(
      deviceId: properties['deviceId'],
      charge: properties['charge'],
      batteryPercent: properties['batteryPercent'],
      fwVersionMajor: properties['fwVersionMajor'],
      fwVersionMinor: properties['fwVersionMinor'],
      fwVersionPatch: properties['fwVersionPatch'],
      mode: properties['mode'],
    );
  }
}
