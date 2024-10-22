import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

/// Emits a stream of velocity
class InstantaneousVelocityCalculator extends Calculator<double> {
  static const String name = 'InstantaneousVelocityCalculator';

  @override
  Stream<double> calculate(Stream<GpsData> gpsDataStream) {
    return gpsDataStream.map((GpsData data) => data.velocity).defaultIfEmpty(0);
  }
}
