import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/stv4_base_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class LiveFrameCommand extends Stv4BaseCommand {
  int instantTimestamp;
  int instantNanos;
  double instantVelocity;
  double instantLatitude;
  double instantLongitude;
  int sensorId;
  int frameType;
  bool isCharging;
  bool contactSensorIsActive;
  bool reserved;
  int timestamp;
  int initialSpeed;
  double hdop;
  int numberOfSatellites;
  int errorGps;
  int bpm;
  int battery;
  List<double> speedDiffs;
  List<double> speeds;
  List<double> intervalRR;
  int batteryCardio;
  int errorImu;
  int errorCardio;
  double fullWidth;
  List<double> latitudes;
  List<double> longitudes;
  List<double> latLongDifference;
  int dLastDeltaRtcGps;
  int dOffsetRtcGps;
  int temperature;
  List<double> accX;
  List<double> accY;
  List<double> accZ;
  List<double> magX;
  List<double> magY;
  List<double> magZ;
  List<double> gyroX;
  List<double> gyroY;
  List<double> gyroZ;

  static const int latLongErrorCode = 0xFFFFFFFF;
  static const int timestampErrorCode = 0xFFFFFFFF;
  static const int speedErrorCode = 0xFFFF;
  static const int hdopErrorCode = 0xFF;
  static const int numberOfSatellitesErrorCode = 0xFF;
  static const int errorGpsErrorCode = 0xFF;
  static const int bpmErrorCode = 0xFF;
  static const int speedDiffErrorCode = 0xFF;
  static const int intervalRRErrorCode = 0xFFFF;
  static const int batteryCardioErrorCode = 0xFF;
  static const int errorImuErrorCode = 0xFF;
  static const int errorCardioErrorCode = 0xFF;
  static const int fullWidthErrorCode = 0xFFFFFFFF;
  static const int latitudeCompletesErrorCode = 0xFFFFFFFF;
  static const int temperatureErrorCode = 0xFF;

  static const int _commandId = CommandTypes.LIVE;

  @override
  int get commandId => _commandId;

  // live frame command doesn't send any payload to the chip
  @override
  Uint8List generatePayload() => Uint8List(0);

  LiveFrameCommand({
    required this.instantTimestamp,
    required this.instantNanos,
    required this.instantVelocity,
    required this.instantLatitude,
    required this.instantLongitude,
    required this.sensorId,
    required this.frameType,
    required this.isCharging,
    required this.contactSensorIsActive,
    required this.reserved,
    required this.timestamp,
    required this.initialSpeed,
    required this.hdop,
    required this.numberOfSatellites,
    required this.errorGps,
    required this.bpm,
    required this.battery,
    required this.speedDiffs,
    required this.speeds,
    required this.intervalRR,
    required this.batteryCardio,
    required this.errorImu,
    required this.errorCardio,
    required this.fullWidth,
    required this.latitudes,
    required this.longitudes,
    required this.latLongDifference,
    required this.dLastDeltaRtcGps,
    required this.dOffsetRtcGps,
    required this.temperature,
    required this.accX,
    required this.accY,
    required this.accZ,
    required this.magX,
    required this.magY,
    required this.magZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
  });

  @override
  String toString() {
    return 'LiveFrameCommand{instantTimestamp: $instantTimestamp, instantNanos: $instantNanos, instantVelocity: $instantVelocity, instantLatitude: $instantLatitude, instantLongitude: $instantLongitude, sensorId: $sensorId, frameType: $frameType, isCharging: $isCharging, contactSensorIsActive: $contactSensorIsActive, reserved: $reserved, timestamp: $timestamp, initialSpeed: $initialSpeed, hdop: $hdop, numberOfSatellites: $numberOfSatellites, errorGps: $errorGps, bpm: $bpm, battery: $battery, speedDiffs: $speedDiffs, speeds: $speeds, intervalRR: $intervalRR, batteryCardio: $batteryCardio, errorImu: $errorImu, errorCardio: $errorCardio, fullWidth: $fullWidth, latitudes: $latitudes, longitudes: $longitudes, latLongDifference: $latLongDifference, dLastDeltaRtcGps: $dLastDeltaRtcGps, dOffsetRtcGps: $dOffsetRtcGps, temperature: $temperature, accX: $accX, accY: $accY, accZ: $accZ, magX: $magX, magY: $magY, magZ: $magZ, gyroX: $gyroX, gyroY: $gyroY, gyroZ: $gyroZ}';
  }
}
