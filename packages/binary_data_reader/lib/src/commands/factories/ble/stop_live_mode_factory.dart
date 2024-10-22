
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/stop_live_mode.dart';

class StopLiveModeCommandFactory implements CommandFactory<StopLiveModeCommand> {
    @override
    StopLiveModeCommand fromBinary(Uint8List data) {
      return StopLiveModeCommand();
    }

    @override
    StopLiveModeCommand fromProperties(Map<String, dynamic> properties) {
      return StopLiveModeCommand();
    }
}
