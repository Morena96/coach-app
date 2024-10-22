import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/upgrade_to_master.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class UpgradeToMasterFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return UpgradeToMasterCommand();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return UpgradeToMasterCommand();
  }
}
