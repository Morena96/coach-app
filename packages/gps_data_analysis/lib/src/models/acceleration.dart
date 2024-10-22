/// This class holds detailed information about an acceleration event, including the components
/// of the acceleration, velocities, duration, distance covered, and whether it is a deceleration event.
class Acceleration {
  final List<double> components;
  final double maxVelocity;
  final double minVelocity;
  final double duration;
  final double distanceCovered;
  final double maxAccelerationReached;
  final bool isDeceleration;

  Acceleration({
    required this.components,
    required this.maxVelocity,
    required this.minVelocity,
    required this.duration,
    required this.distanceCovered,
    required this.maxAccelerationReached,
    required this.isDeceleration,
  });

  @override
  String toString() {
    return 'Acceleration(components: $components, maxVelocity: $maxVelocity, minVelocity: $minVelocity, duration: $duration, distanceCovered: $distanceCovered, maxAccelerationReached: $maxAccelerationReached, isDeceleration: $isDeceleration)';
  }
}
