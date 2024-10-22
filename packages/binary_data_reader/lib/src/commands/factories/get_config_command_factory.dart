import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/get_config_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class GetConfigCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    int masterId = data[0];
    int frequency = data[1];
    int mainFrequency = data[2];
    bool isMain = data[3] == 1;
    int clubId = ByteData.sublistView(data).getInt16(4);
    return GetConfigCommand(
      masterId: masterId,
      frequency: frequency,
      mainFrequency: mainFrequency,
      isMain: isMain,
      clubId: clubId,
    );
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    int masterId = properties['masterId'];
    int frequency = properties['frequency'];
    int mainFrequency = properties['mainFrequency'];
    bool isMain = properties['isMain'];
    int clubId = properties['clubId'];
    return GetConfigCommand(
      masterId: masterId,
      frequency: frequency,
      mainFrequency: mainFrequency,
      isMain: isMain,
      clubId: clubId,
    );
  }
}
