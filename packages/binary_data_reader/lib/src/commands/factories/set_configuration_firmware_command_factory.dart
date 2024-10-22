import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/set_configuration_firmware_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
class SetConfigurationFirmwareCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return SetConfigurationFirmwareCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return SetConfigurationFirmwareCommand();
  }
}
