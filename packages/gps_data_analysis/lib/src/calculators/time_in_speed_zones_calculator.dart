import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:gps_data_analysis/gps_data_analysis.dart';

/// Quantifies the amount of time a subject spends within predefined speed zones during a session
class TimeInSpeedZonesCalculator extends Calculator<Map<int, double>> {
  static const String name = 'TimeInSpeedZonesCalculator';

  /// Upper bounds of each speed zone
  final List<double> speedZonesUpperBounds;
  int? previousTime;

  TimeInSpeedZonesCalculator({
    this.speedZonesUpperBounds = const <double>[5, 10, 20],
  });

  @override
  Stream<Map<int, double>> calculate(Stream<GpsData> gpsDataStream) {
    return gpsDataStream.scan<Map<int, double>>((Map<int, double> accum, GpsData current, int index) {
      // Calculate the time spent in each speed zone
      final int currentTime = current.timestamp;
      final double elapsedTime = (currentTime - (previousTime ?? currentTime)) / 1000.0; // Time in seconds
      previousTime = currentTime;

      // Determine which speed zone the current sample falls into
      final int zoneIndex = _getZoneIndex(current.velocity);
      accum[zoneIndex] = (accum[zoneIndex] ?? 0) + elapsedTime;

      return accum;
    }, <int, double>{});
  }

  int _getZoneIndex(double velocity) {
    for (int i = 0; i < speedZonesUpperBounds.length; i++) {
      if (velocity <= speedZonesUpperBounds[i]) {
        return i;
      }
    }
    return speedZonesUpperBounds.length; // For velocities that exceed the highest defined speed zone
  }
}
