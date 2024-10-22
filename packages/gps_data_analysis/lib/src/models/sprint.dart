class Sprint {
  final int startTime;
  final int endTime;
  final double totalDistance;
  final double maxSpeed;
  final Duration totalTime;
  final Duration? time10yd;
  final Duration? time30yd;
  final Duration? time40yd;
  final List<double> velocities;

  Sprint({
    required this.startTime,
    required this.endTime,
    required this.totalDistance,
    required this.maxSpeed,
    required this.totalTime,
    required this.time10yd,
    required this.time30yd,
    required this.time40yd,
    required this.velocities,
  });

  @override
  String toString() {
    return 'Sprint(startTime: $startTime, endTime: $endTime, totalDistance: $totalDistance, maxSpeed: $maxSpeed, '
        'totalTime: $totalTime, time10yd: $time10yd, time30yd: $time30yd, time40yd: $time40yd, '
        'velocities: ${velocities.map((double e) => e.toStringAsFixed(2)).join(", ")})';
  }
}
