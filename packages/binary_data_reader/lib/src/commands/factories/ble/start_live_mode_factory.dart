
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/start_live_mode.dart';

class StartLiveModeCommandFactory implements CommandFactory<StartLiveModeCommand> {
    @override
    StartLiveModeCommand fromBinary(Uint8List data) {
      return StartLiveModeCommand();
    }

    @override
    StartLiveModeCommand fromProperties(Map<String, dynamic> properties) {
      return StartLiveModeCommand();
    }
}
