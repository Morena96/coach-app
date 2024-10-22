/// A class representing a collision event with various parameters and injury criteria.
class Collision {
  final int timestamp;
  final double latitude;
  final double longitude;
  final double acceleration;
  final double velocity;

  /// The value of the Gadd Severity Index based on head tolerance limit and linear acceleration.
  final double gaddSeverityIndex;

  /// The head injury criterion (HIC) is a measure of the likelihood of head injury arising from an impact
  final double headInjuryCriterion;

  /// magnitude of x, y, z
  final double peakLinearAcceleration;

  Collision({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.acceleration,
    required this.velocity,
    required this.gaddSeverityIndex,
    required this.headInjuryCriterion,
    required this.peakLinearAcceleration,
  });

  @override
  String toString() {
    return 'Collision(timestamp: $timestamp, latitude: $latitude, longitude: $longitude, acceleration: $acceleration, velocity: $velocity, gaddSeverityIndex: $gaddSeverityIndex, headInjuryCriterion: $headInjuryCriterion, peakLinearAcceleration: $peakLinearAcceleration)';
  }
}
