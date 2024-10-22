import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

/// Calculates max velocity
class MaxVelocityCalculator extends Calculator<double> {
  static const String name = 'MaxVelocityCalculator';

  @override
  Stream<double> calculate(Stream<GpsData> gpsDataStream) {
    return gpsDataStream.map((GpsData data) => data.velocity).defaultIfEmpty(0).scan((double max, double value, _) => value > max ? value : max, 0);
  }
}
