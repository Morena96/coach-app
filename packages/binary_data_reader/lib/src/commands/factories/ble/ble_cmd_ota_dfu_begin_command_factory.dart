import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/ble_cmd_ota_dfu_begin_command.dart';

class BleCmdOtaDfuBeginCommandFactory
    implements CommandFactory<BleCmdOtaDfuBeginCommand> {
  @override
  BleCmdOtaDfuBeginCommand fromBinary(Uint8List data) {
    return BleCmdOtaDfuBeginCommand(
        rfFirmwareSizeWithSoftDevice:
            ByteData.sublistView(data, 0, 8).getUint64(0, Endian.big),
        rfWithSoftDeviceCrc:
            ByteData.sublistView(data, 8, 16).getUint64(0, Endian.big),
        bleFirmwareSizeWithSoftDevice:
            ByteData.sublistView(data, 16, 24).getUint64(0, Endian.big),
        bleWithSoftDeviceCrc:
            ByteData.sublistView(data, 24, 32).getUint64(0, Endian.big));
  }

  @override
  BleCmdOtaDfuBeginCommand fromProperties(Map<String, dynamic> properties) {
    return BleCmdOtaDfuBeginCommand(
        rfFirmwareSizeWithSoftDevice:
            properties['rfFirmwareSizeWithSoftDevice'],
        rfWithSoftDeviceCrc: properties['rfWithSoftDeviceCrc'],
        bleFirmwareSizeWithSoftDevice:
            properties['bleFirmwareSizeWithSoftDevice'],
        bleWithSoftDeviceCrc: properties['bleWithSoftDeviceCrc']);
  }
}
