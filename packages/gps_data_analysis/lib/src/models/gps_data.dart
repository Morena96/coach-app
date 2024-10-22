// ignore_for_file: public_member_api_docs, sort_constructors_first
class GpsData {
  /// Timestamp in milliseconds since epoch
  final int timestamp;

  /// Latitude of a location
  final double latitude;

  /// Longitude of a location
  final double longitude;

  /// Speed in m/s
  final double velocity;

  /// List of x-axis accelerations in g
  final List<double> accelerationX;

  /// List of x-axis accelerations in g
  final List<double> accelerationY;

  /// List of x-axis accelerations in g
  final List<double> accelerationZ;

  /// List of accelerations in g, calculated only if `AddAccelerationProcessor` applied
  final List<double> acceleration;

  /// Single value of acceleration in g. Calculated with formula (Δv / Δt)
  /// after applying `AddAccelerationFromDerivativeProcessor`,
  final double? accelerationFromVelocityDerivative;

  final double? distance;

  final double? accumulatedDistance;

  /// Horizontal Dilution of Precision
  final double? hdop;

  final int? numberOfSatellites;

  /// 'HIGH', 'MEDIUM', or 'LOW' depending on `hdop` and `numberOfSatellites`
  final String? signalQuality;

  final double? heartRate;
  final int? errorCardio;
  final int? errorGps;
  final bool isInCharge;

  GpsData({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.velocity,
    this.accelerationX = const <double>[],
    this.accelerationY = const <double>[],
    this.accelerationZ = const <double>[],
    this.acceleration = const <double>[],
    this.accelerationFromVelocityDerivative,
    this.distance,
    this.accumulatedDistance,
    this.hdop,
    this.numberOfSatellites,
    this.errorGps,
    this.signalQuality,
    this.heartRate,
    this.errorCardio,
    this.isInCharge = false,
  }) : assert(
          accelerationX.length == accelerationY.length && accelerationY.length == accelerationZ.length && (acceleration.isEmpty || acceleration.length == accelerationX.length),
          'Acceleration data length should be the same on all axis ',
        );

  GpsData copyWith({
    int? timestamp,
    double? latitude,
    double? longitude,
    double? velocity,
    List<double>? accelerationX,
    List<double>? accelerationY,
    List<double>? accelerationZ,
    List<double>? acceleration,
    double? accelerationFromVelocityDerivative,
    double? distance,
    double? accumulatedDistance,
    double? hdop,
    int? numberOfSatellites,
    String? signalQuality,
    double? heartRate,
    int? errorCardio,
    int? errorGps,
    bool? isInCharge,
  }) {
    return GpsData(
      timestamp: timestamp ?? this.timestamp,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      velocity: velocity ?? this.velocity,
      accelerationX: accelerationX ?? this.accelerationX,
      accelerationY: accelerationY ?? this.accelerationY,
      accelerationZ: accelerationZ ?? this.accelerationZ,
      accelerationFromVelocityDerivative: accelerationFromVelocityDerivative ?? this.accelerationFromVelocityDerivative,
      acceleration: acceleration ?? this.acceleration,
      distance: distance ?? this.distance,
      accumulatedDistance: accumulatedDistance ?? this.accumulatedDistance,
      hdop: hdop ?? this.hdop,
      numberOfSatellites: numberOfSatellites ?? this.numberOfSatellites,
      signalQuality: signalQuality ?? this.signalQuality,
      heartRate: heartRate ?? this.heartRate,
      errorCardio: errorCardio ?? this.errorCardio,
      errorGps: errorGps ?? this.errorGps,
      isInCharge: isInCharge ?? this.isInCharge,
    );
  }

  @override
  String toString() {
    return 'GPSData(timestamp: $timestamp, latitude: $latitude, longitude: $longitude, '
        'velocity: $velocity, accelerationX: $accelerationX, accelerationY: $accelerationY, '
        'accelerationZ: $accelerationZ, acceleration: $acceleration, accelerationFromVelocityDerivative: $accelerationFromVelocityDerivative,'
        ' distance: $distance, accumulatedDistance: $accumulatedDistance, hdop: $hdop, numberOfSatellites: $numberOfSatellites, '
        'signalQuality: $signalQuality)';
  }

  factory GpsData.empty() => GpsData(timestamp: 0, latitude: 0, longitude: 0, velocity: 0);
}
