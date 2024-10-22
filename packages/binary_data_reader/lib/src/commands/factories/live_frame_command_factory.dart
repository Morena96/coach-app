import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/live_frame_command.dart';
import 'package:binary_data_reader/src/models/parsed_speed_data.dart';
import 'package:binary_data_reader/src/utils/parse_gps_speed_byte_data.dart';

class LiveFrameCommandFactory extends CommandFactory {
  @override
  LiveFrameCommand fromBinary(Uint8List data) {
    final buffer = ByteData.sublistView(data);

    int instantTimestamp = buffer.getInt32(0);
    int instantNanos = buffer.getInt32(4);
    int instantLatitude = buffer.getInt32(8);
    int instantLongitude = buffer.getInt32(12);
    int instantVelocity = buffer.getInt32(16);

    // slice the bytes to go from index 20+
    ParsedSpeedData parsedSpeedData = parseGpsSpeedByteData(data.sublist(20));

    return LiveFrameCommand(
      instantTimestamp: instantTimestamp,
      instantNanos: instantNanos,
      instantVelocity: instantVelocity / 1000,
      instantLatitude: instantLatitude / 10000000,
      instantLongitude: instantLongitude / 10000000,
      sensorId: parsedSpeedData.sensorId,
      frameType: parsedSpeedData.frameType,
      isCharging: parsedSpeedData.isCharging,
      contactSensorIsActive: parsedSpeedData.contactSensorIsActive,
      reserved: parsedSpeedData.reserved,
      timestamp: parsedSpeedData.timestamp,
      initialSpeed: parsedSpeedData.initialSpeed,
      hdop: parsedSpeedData.hdop,
      numberOfSatellites: parsedSpeedData.numberOfSatellites,
      errorGps: parsedSpeedData.errorGps,
      bpm: parsedSpeedData.bpm,
      battery: parsedSpeedData.battery,
      speedDiffs: parsedSpeedData.speedDiffs,
      speeds: parsedSpeedData.speeds,
      intervalRR: parsedSpeedData.intervalRR,
      batteryCardio: parsedSpeedData.batteryCardio,
      errorImu: parsedSpeedData.errorImu,
      errorCardio: parsedSpeedData.errorCardio,
      fullWidth: 0,
      latitudes: parsedSpeedData.latitudes,
      longitudes: parsedSpeedData.longitudes,
      // longitude is from 44-47 bytes
      latLongDifference: [],
      dLastDeltaRtcGps: 0,
      // d_last_delta_rtc_gps is from 48-51 bytes
      dOffsetRtcGps: 0,
      // d_offset_rtc_gps is from 52-55 bytes
      temperature: 0,
      // temperature is from 56 bytes
      accX: parsedSpeedData.accelX,
      accY: parsedSpeedData.accelY,
      accZ: parsedSpeedData.accelZ,
      magX: parsedSpeedData.magX,
      magY: parsedSpeedData.magY,
      magZ: parsedSpeedData.magZ,
      gyroX: parsedSpeedData.gyroX,
      gyroY: parsedSpeedData.gyroY,
      gyroZ: parsedSpeedData.gyroZ,
    );
  }

  @override
  LiveFrameCommand fromProperties(Map<String, dynamic> properties) {
    return LiveFrameCommand(
      instantTimestamp: properties['instantTimestamp'],
      instantNanos: properties['instantNanos'],
      instantVelocity: properties['instantVelocity'],
      instantLatitude: properties['instantLatitude'],
      instantLongitude: properties['instantLongitude'],
      sensorId: properties['sensorId'],
      frameType: properties['frameType'],
      isCharging: properties['isCharging'],
      contactSensorIsActive: properties['contactSensorIsActive'],
      reserved: properties['reserved'],
      timestamp: properties['timestamp'],
      initialSpeed: properties['initialSpeed'],
      hdop: properties['hdop'],
      numberOfSatellites: properties['numberOfSatellites'],
      errorGps: properties['errorGps'],
      bpm: properties['bpm'],
      battery: properties['battery'],
      speedDiffs: properties['speedDiffs'],
      speeds: properties['speeds'],
      intervalRR: properties['intervalRR'],
      batteryCardio: properties['batteryCardio'],
      errorImu: properties['errorImu'],
      errorCardio: properties['errorCardio'],
      fullWidth: properties['fullWidth'],
      latitudes: properties['latitudes'],
      longitudes: properties['longitudes'],
      latLongDifference: [],
      dLastDeltaRtcGps: properties['dLastDeltaRtcGps'],
      dOffsetRtcGps: properties['dOffsetRtcGps'],
      temperature: properties['temperature'],
      accX: properties['accX'],
      accY: properties['accY'],
      accZ: properties['accZ'],
      magX: properties['magX'],
      magY: properties['magY'],
      magZ: properties['magZ'],
      gyroX: properties['gyroX'],
      gyroY: properties['gyroY'],
      gyroZ: properties['gyroZ'],
    );
  }
}
