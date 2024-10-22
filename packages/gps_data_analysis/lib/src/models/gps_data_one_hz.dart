class GpsDataOneHz {
  final int timestamp;
  final int numberOfSatellites;
  final double hdop;
  final int errorGps;
  final int heartRate;
  final int? errorCardio;
  final bool isCharging;
  final List<double> speeds;
  final List<double> accelerationX;
  final List<double> accelerationY;
  final List<double> accelerationZ;
  final List<double> latitudes;
  final List<double> longitudes;

  GpsDataOneHz({
    required this.timestamp,
    required this.numberOfSatellites,
    required this.hdop,
    required this.errorGps,
    required this.heartRate,
    required this.errorCardio,
    required this.isCharging,
    required List<double> speeds,
    required this.accelerationX,
    required this.accelerationY,
    required this.accelerationZ,
    required this.latitudes,
    required this.longitudes,
  }) : speeds = speeds
            .map((double speed) => (speed * 1000).round() / 1000)
            .toList();
}
