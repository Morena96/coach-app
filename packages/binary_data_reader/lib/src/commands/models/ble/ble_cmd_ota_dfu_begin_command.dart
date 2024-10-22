import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class BleCmdOtaDfuBeginCommand extends Stv4BaseCommand {
  int rfFirmwareSizeWithSoftDevice;
  int rfWithSoftDeviceCrc;
  int bleFirmwareSizeWithSoftDevice;
  int bleWithSoftDeviceCrc;

  BleCmdOtaDfuBeginCommand({
    required this.rfFirmwareSizeWithSoftDevice,
    required this.rfWithSoftDeviceCrc,
    required this.bleFirmwareSizeWithSoftDevice,
    required this.bleWithSoftDeviceCrc,
  });

  @override
  int get commandId => BLECommandTypes.BLE_CMD_OTA_DFU_BEGIN;

  @override
  Uint8List generatePayload() {
    ByteData payload = ByteData(16);

    payload.setUint32(0, rfFirmwareSizeWithSoftDevice, Endian.big);
    payload.setUint32(4, rfWithSoftDeviceCrc, Endian.big);
    payload.setUint32(8, bleFirmwareSizeWithSoftDevice, Endian.big);
    payload.setUint32(12, bleWithSoftDeviceCrc, Endian.big);

    return payload.buffer.asUint8List();
  }

  @override
  String toString() {
    return 'BleCmdOtaDfuBeginCommand{rfFirmwareSizeWithSoftDevice: $rfFirmwareSizeWithSoftDevice, rfCrc: $rfWithSoftDeviceCrc, bleFirmwareSizeWithSoftDevice: $bleFirmwareSizeWithSoftDevice, bleCrc: $bleWithSoftDeviceCrc}';
  }
}
