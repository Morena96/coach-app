import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/check_validity_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class CheckValidityCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    bool firmwareIsValid = data[0] == 0x01;
    return CheckValidityCommand(firmwareIsValid: firmwareIsValid);
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    bool firmwareIsValid = properties['firmwareIsValid'] ?? false;
    return CheckValidityCommand(firmwareIsValid: firmwareIsValid);
  }
}
