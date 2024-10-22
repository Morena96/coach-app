import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/set_config_command.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class SetConfigCommandFactory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    int? masterId;
    int? frequency;
    int? mainFrequency;
    bool? isMain;
    int? clubId;

    if (data.length > 0) {
      masterId = data[0];
    }
    if (data.length > 1) {
      frequency = data[1];
    }
    if (data.length > 2) {
      mainFrequency = data[2];
    }
    if (data.length > 3) {
      isMain = data[3] == 1;
    }
    if (data.length > 4) {
      clubId = ByteData.sublistView(data).getInt16(4);
    }

    return SetConfigCommand(
      masterId: masterId,
      frequency: frequency,
      mainFrequency: mainFrequency,
      isMain: isMain,
      clubId: clubId,
    );
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    int? masterId = properties['masterId'];
    int? frequency = properties['frequency'];
    int? mainFrequency = properties['mainFrequency'];
    bool? isMain = properties['isMain'];
    int? clubId = properties['clubId'];

    return SetConfigCommand(
      masterId: masterId,
      frequency: frequency,
      mainFrequency: mainFrequency,
      isMain: isMain,
      clubId: clubId,
    );
  }
}
