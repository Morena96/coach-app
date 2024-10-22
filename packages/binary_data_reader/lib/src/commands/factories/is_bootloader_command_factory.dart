import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/is_bootloader_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class IsBootloaderCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    bool isBootloader = data[0] == 0x01;
    return IsBootloaderCommand(isBootloader: isBootloader);
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    bool isBootloader = properties['isBootloader'] ?? false;
    return IsBootloaderCommand(isBootloader: isBootloader);
  }
}
