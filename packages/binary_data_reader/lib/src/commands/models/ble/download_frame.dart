import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class DownloadFrame extends Stv4BaseCommand {
  Uint8List data;
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


  DownloadFrame({
    required this.data,
    this.sensorId = 0,
    this.frameType = 0,
    this.isCharging = false,
    this.contactSensorIsActive = false,
    this.reserved = false,
    this.timestamp = 0,
    this.initialSpeed = 0,
    this.hdop = 0,
    this.numberOfSatellites = 0,
    this.errorGps = 0,
    this.bpm = 0,
    this.battery = 0,
    this.speedDiffs = const [],
    this.speeds = const [],
    this.intervalRR = const [],
    this.batteryCardio = 0,
    this.errorImu = 0,
    this.errorCardio = 0,
    this.fullWidth = 0,
    this.latitudes = const [],
    this.longitudes = const [],
    this.latLongDifference = const [],
    this.dLastDeltaRtcGps = 0,
    this.dOffsetRtcGps = 0,
    this.temperature = 0,
    this.accX = const [],
    this.accY = const [],
    this.accZ = const [],
    this.magX = const [],
    this.magY = const [],
    this.magZ = const [],
    this.gyroX = const [],
    this.gyroY = const [],
    this.gyroZ = const [],
  });

  @override
  int get commandId => BLECommandTypes.RECEIVE_DOWNLOAD;

  @override
  Uint8List generatePayload() {
    return Uint8List(0);
  }
}
