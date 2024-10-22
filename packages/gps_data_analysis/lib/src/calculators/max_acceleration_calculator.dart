import 'dart:math';

import 'package:rxdart/rxdart.dart';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

/// Computes the maximum acceleration magnitude across all samples using the
/// Euclidean norm
class MaxAccelerationCalculator extends Calculator<double> {
  static const String name = 'MaxAccelerationCalculator';

  @override
  Stream<double> calculate(Stream<GpsData> gpsDataStream) {
    return gpsDataStream.map((GpsData data) {
      if (data.acceleration.isEmpty) return 0.0;
      // Find the maximum acceleration magnitude for current sample
      return data.acceleration.reduce(max);
    }).scan((double max, double value, _) => value > max ? value : max, 0);
  }
}
