import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/ble/download_frame.dart';
import 'package:binary_data_reader/src/models/parsed_speed_data.dart';
import 'package:binary_data_reader/src/utils/parse_gps_speed_byte_data.dart';

class DownloadFrameFactory implements CommandFactory {
  @override
  DownloadFrame fromBinary(Uint8List data) {
    ParsedSpeedData parsedGpsSpeedData = parseGpsSpeedByteData(data);

    return DownloadFrame(
      data: data,
      sensorId: parsedGpsSpeedData.sensorId,
      frameType: parsedGpsSpeedData.frameType,
      isCharging: parsedGpsSpeedData.isCharging,
      contactSensorIsActive: parsedGpsSpeedData.contactSensorIsActive,
      reserved: parsedGpsSpeedData.reserved,
      timestamp: parsedGpsSpeedData.timestamp,
      initialSpeed: parsedGpsSpeedData.initialSpeed,
      hdop: parsedGpsSpeedData.hdop,
      numberOfSatellites: parsedGpsSpeedData.numberOfSatellites,
      errorGps: parsedGpsSpeedData.errorGps,
      bpm: parsedGpsSpeedData.bpm,
      battery: parsedGpsSpeedData.battery,
      speedDiffs: parsedGpsSpeedData.speedDiffs,
      speeds: parsedGpsSpeedData.speeds,
      intervalRR: parsedGpsSpeedData.intervalRR,
      batteryCardio: parsedGpsSpeedData.batteryCardio,
      errorImu: parsedGpsSpeedData.errorImu,
      errorCardio: parsedGpsSpeedData.errorCardio,
      fullWidth: 1,
      latitudes: parsedGpsSpeedData.latitudes,
      longitudes: parsedGpsSpeedData.longitudes,
      latLongDifference: [],
      dLastDeltaRtcGps: 0,
      dOffsetRtcGps: 0,
      temperature: 0,
      accX: parsedGpsSpeedData.accelX,
      accY: parsedGpsSpeedData.accelY,
      accZ: parsedGpsSpeedData.accelZ,
      magX: parsedGpsSpeedData.magX,
      magY: parsedGpsSpeedData.magY,
      magZ: parsedGpsSpeedData.magZ,
      gyroX: parsedGpsSpeedData.gyroX,
      gyroY: parsedGpsSpeedData.gyroY,
      gyroZ: parsedGpsSpeedData.gyroZ,
    );
  }

  @override
  DownloadFrame fromProperties(Map<String, dynamic> properties) {
    return DownloadFrame(
      data: properties['data'],
    );
  }
}
