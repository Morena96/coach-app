import 'package:gps_data_analysis/src/models/gps_data.dart';

GpsData gpsData({
  int? timestamp,
  double velocity = 0.0,
  double? hdop,
  int numberOfSatellites = 0,
  double latitude = 0.0,
  double longitude = 0.0,
  double? heartRate,
  double? distance,
  List<double> accelerationX = const <double>[],
  List<double> accelerationY = const <double>[],
  List<double> accelerationZ = const <double>[],
}) {
  return GpsData(
    latitude: latitude,
    longitude: longitude,
    timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
    velocity: velocity,
    heartRate: heartRate,
    hdop: hdop,
    distance: distance,
    numberOfSatellites: numberOfSatellites,
    accelerationX: accelerationX,
    accelerationY: accelerationY,
    accelerationZ: accelerationZ,
  );
}
