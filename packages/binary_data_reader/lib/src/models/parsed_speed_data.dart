class ParsedSpeedData {
  final int sensorId;
  final int packetId;
  final int frameType;
  final bool isCharging;
  final bool contactSensorIsActive;
  final bool reserved;
  final int timestamp;
  final int initialSpeed;
  final double hdop;
  final int numberOfSatellites;
  final int errorGps;
  final int bpm;
  final int battery;
  final List<double> speedDiffs;
  final List<double> speeds;
  final List<double> intervalRR;
  final int batteryCardio;
  final int errorImu;
  final int errorCardio;
  final List<double> latitudes;
  final List<double> longitudes;
  final List<double> accelX;
  final List<double> accelY;
  final List<double> accelZ;
  final List<double> magX;
  final List<double> magY;
  final List<double> magZ;
  final List<double> gyroX;
  final List<double> gyroY;
  final List<double> gyroZ;

  ParsedSpeedData({
    required this.sensorId,
    required this.packetId,
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
    required this.latitudes,
    required this.longitudes,
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.magX,
    required this.magY,
    required this.magZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
  });
}
