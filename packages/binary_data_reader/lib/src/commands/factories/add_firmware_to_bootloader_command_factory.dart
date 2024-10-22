import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/add_firmware_to_bootloader.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class AddFirmwareToBootloaderFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return AddFirmwareToBootloaderCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return AddFirmwareToBootloaderCommand();
  }
}
