import 'dart:typed_data';

import 'package:binary_data_reader/src/models/parsed_speed_data.dart';
import 'package:binary_data_reader/src/utils/extensions/process_speed_data.dart';
import 'package:binary_data_reader/src/utils/process_latitude_data.dart';
import 'package:binary_data_reader/src/utils/process_longitude_data.dart';

ParsedSpeedData parseGpsSpeedByteData(Uint8List data) {
  final buffer = ByteData.sublistView(data);
  int sensorId = buffer.getUint16(0);
  int packetId = buffer.getUint16(2);

  int frameTypeAndFlags = data[4];
  int frameType = (frameTypeAndFlags & 0x0F) >> 4;
  bool isCharging = (frameTypeAndFlags & 0x10) == 0x10;
  bool contactSensorIsActive = (frameTypeAndFlags & 0x20) == 0x20;
  bool reserved = (frameTypeAndFlags & 0x80) == 0x80;
  int timestamp = buffer.getUint32(5);
  int initialSpeed = buffer.getUint16(9);
  double hdop = buffer.getUint8(11) / 10;
  int numberOfSatellites = buffer.getUint8(12);
  int errorGps = buffer.getUint8(13);
  int bpm = buffer.getUint8(14);
  int battery = buffer.getUint8(15);

  Uint8List speedData = data.sublist(16, 25);
  List<double> speedDiffs = speedData.calculateSpeedDiffs();
  double initialSpeedDouble = initialSpeed / 100;
  List<double> speeds = [initialSpeedDouble];
  for (var diff in speedDiffs) {
    speeds.add(speeds.last + diff);
  }

  List<double> intervalRR = List<double>.generate(4, (i) {
    int byteValue = buffer.getUint16(25 + i * 2);
    return byteValue * 0.01;
  });

  int batteryCardio = buffer.getUint8(33);
  int errorImu = buffer.getUint8(34);
  int errorCardio = buffer.getUint8(35);
  int latCompletes = buffer.getInt32(36);
  int longCompletes = buffer.getInt32(40);

  Uint8List latLonData = data.sublist(44, 67);

  List<double> latitudeValues =
      processLatitudeData(latLonData.sublist(0, 12), latCompletes / 10000000);
  List<double> longitudeValues = processLongitudeData(
      latLonData.sublist(11, 23), longCompletes / 10000000);

  int deltaLastRtcGps = buffer.getUint16(67);
  int offsetRtcGps = buffer.getUint8(69);
  int temperature = buffer.getUint16(70);

  List<double> accelX = List.filled(80, 0.0);
  List<double> accelY = List.filled(80, 0.0);
  List<double> accelZ = List.filled(80, 0.0);

  List<double> gyroX = List.filled(20, 0.0);
  List<double> gyroY = List.filled(20, 0.0);
  List<double> gyroZ = List.filled(20, 0.0);

  List<double> magX = List.filled(20, 0.0);
  List<double> magY = List.filled(20, 0.0);
  List<double> magZ = List.filled(20, 0.0);

  // Mapping of packet indices to target indices
  final List<int> indexMapping = [4, 0, 9, 6, 1, 8, 3, 5, 2, 7];

  for (int packetIndex = 0; packetIndex < 10; packetIndex++) {
    int offset = 72 + packetIndex * 36; // Each packet is 36 bytes

    // Process acceleration data
    processSensorData(accelX, accelY, accelZ, indexMapping[packetIndex], buffer,
        offset, 0.000732, 8);

    // Process gyroscope data (next 2 sets of 3 bytes)
    processSensorData(gyroX, gyroY, gyroZ, indexMapping[packetIndex], buffer,
        offset + 24, 0.070, 2);

    // Process magnetometer data (last 2 sets of 3 bytes)
    processSensorData(magX, magY, magZ, indexMapping[packetIndex], buffer,
        offset + 30, 0.00058, 2);
  }

  return ParsedSpeedData(
    sensorId: sensorId,
    packetId: packetId,
    frameType: frameType,
    isCharging: isCharging,
    contactSensorIsActive: contactSensorIsActive,
    reserved: reserved,
    timestamp: timestamp,
    initialSpeed: initialSpeed,
    hdop: hdop,
    numberOfSatellites: numberOfSatellites,
    errorGps: errorGps,
    bpm: bpm,
    battery: battery,
    speedDiffs: speedDiffs,
    speeds: speeds.map((e) => e / 3.6).toList(),
    intervalRR: intervalRR,
    batteryCardio: batteryCardio,
    errorImu: errorImu,
    errorCardio: errorCardio,
    latitudes: latitudeValues,
    longitudes: longitudeValues,
    accelX: accelX,
    accelY: accelY,
    accelZ: accelZ,
    magX: magX,
    magY: magY,
    magZ: magZ,
    gyroX: gyroX,
    gyroY: gyroY,
    gyroZ: gyroZ,
  );
}

void processSensorData(
    List<double> targetX,
    List<double> targetY,
    List<double> targetZ,
    int index,
    ByteData buffer,
    int offset,
    double scale,
    int count) {
  for (int i = 0; i < count; i++) {
    targetX[(i * 10) + index] = buffer.getInt8(offset + i * 3) * 256 * scale;
    targetY[(i * 10) + index] =
        buffer.getInt8(offset + i * 3 + 1) * 256 * scale;
    targetZ[(i * 10) + index] =
        buffer.getInt8(offset + i * 3 + 2) * 256 * scale;
  }
}
