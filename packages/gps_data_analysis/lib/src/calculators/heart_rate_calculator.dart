import 'dart:async';
import 'dart:math';

import 'package:rxdart/rxdart.dart';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/models/heart_rate.dart';

/// Computes the average, minimum, maximum, and average heart rate as a percentage
/// of maximum heart rate and emit `HearRate`
class HeartRateCalculator extends Calculator<HeartRate> {
  double _totalHeartRate = 0;
  double _minHeartRate = 300; // Assuming 300 is a higher boundary for heart rate.
  double _maxHeartRate = 0;

  @override
  Stream<HeartRate> calculate(Stream<GpsData> gpsDataStream) {
    return gpsDataStream.scan<HeartRate>(
      (HeartRate accum, GpsData current, int index) {
        final double heartRate = current.heartRate ?? 0;
        _totalHeartRate += heartRate;

        if (heartRate > 0) {
          _minHeartRate = min(heartRate, _minHeartRate);
          _maxHeartRate = max(heartRate, _maxHeartRate);
        }

        final double average = _totalHeartRate / (index + 1);
        final double averagePercentage = _maxHeartRate > 0 ? (average / _maxHeartRate) * 100 : 0;

        return HeartRate(
          average: average,
          min: _minHeartRate,
          max: _maxHeartRate,
          averagePercentage: averagePercentage,
        );
      },
      HeartRate.empty(),
    );
  }
}
