import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

/// Determines the amount of time an athlete spends in predefined heart rate zones during a session
class TimeInHeartRateZonesCalculator extends Calculator<Map<int, double>> {
  /// Upper bounds of each heart rate zone
  final List<double> heartZonesUpperBounds;
  int? previousTime;

  TimeInHeartRateZonesCalculator({
    this.heartZonesUpperBounds = const <double>[50, 100, 150, 200],
  });

  @override
  Stream<Map<int, double>> calculate(Stream<GpsData> gpsDataStream) {
    return gpsDataStream.scan<Map<int, double>>((Map<int, double> accum, GpsData current, int index) {
      // Calculate the time heart rate in each heart rate zone
      final int currentTime = current.timestamp;
      final double elapsedTime = (currentTime - (previousTime ?? currentTime)) / 1000.0; // Time in seconds
      previousTime = currentTime;

      // Determine which heart rate zone the current sample falls into
      final int zoneIndex = _getZoneIndex(current.heartRate ?? 0);
      accum[zoneIndex] = (accum[zoneIndex] ?? 0) + elapsedTime;

      return accum;
    }, <int, double>{});
  }

  int _getZoneIndex(double heartRate) {
    for (int i = 0; i < heartZonesUpperBounds.length; i++) {
      if (heartRate <= heartZonesUpperBounds[i]) {
        return i;
      }
    }
    return heartZonesUpperBounds.length; // For heart rates that exceed the highest defined heart rate zone
  }
}
