import 'dart:async';
import 'dart:math';

import 'package:gps_data_analysis/src/models/acceleration.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/processor_mixin.dart';
import 'package:gps_data_analysis/src/calculators/calculator.dart';

/// Identifies athlete accelerations and decelerations by checking when acceleration
/// exceeds a threshold for a minimum duration, and emits a `Stream<Acceleration>`
/// where each `Acceleration` object contains various relevant properties
class PeriodAccelerationCalculator extends Calculator<Acceleration> with ProcessorMixin<Acceleration> {
  static const String name = 'PeriodAccelerationCalculator';
  List<GpsData> buffer = <GpsData>[];
  final double accelerationThreshold;
  final double minDuration;

  PeriodAccelerationCalculator({
    required this.accelerationThreshold,
    required this.minDuration,
  });

  @override
  Stream<Acceleration> calculate(Stream<GpsData> gpsDataStream) {
    final StreamController<Acceleration> controller = StreamController<Acceleration>();

    gpsDataStream.listen(
      (GpsData gpsData) {
        // Keep adding to buffer if acceleration/deceleration exceeds threshold
        if ((gpsData.accelerationFromVelocityDerivative ?? 0).abs() >= accelerationThreshold) {
          buffer.add(gpsData);
        } else {
          // Acceleration less than accelerationThreshold, indicates that
          // jerk is over
          closeIfExceedsMinDuration(controller, buffer);
          buffer.clear();
        }
      },
      onDone: () {
        closeIfExceedsMinDuration(controller, buffer);
        controller.close();
      },
    );

    return controller.stream;
  }

  void closeIfExceedsMinDuration(StreamController<Acceleration> controller, List<GpsData> buffer) {
    if (_bufferDuration(buffer) >= minDuration) {
      final List<double> components = buffer.map((GpsData data) => data.accelerationFromVelocityDerivative ?? 0).toList();
      controller.add(Acceleration(
        components: components,
        maxVelocity: _maxVelocity(buffer),
        minVelocity: _minVelocity(buffer),
        duration: _bufferDuration(buffer),
        distanceCovered: _calculateDistance(buffer),
        maxAccelerationReached: _maxAcceleration(buffer),
        isDeceleration: _isDeceleration(buffer),
      ));
    }
  }

  bool _isDeceleration(List<GpsData> buffer) {
    return (buffer.first.accelerationFromVelocityDerivative ?? 0) < 0;
  }

  double _bufferDuration(List<GpsData> buffer) {
    if (buffer.isEmpty) return 0;
    return (buffer.last.timestamp - buffer.first.timestamp) / 1000;
  }

  double _maxVelocity(List<GpsData> buffer) {
    return buffer.map((GpsData data) => data.velocity).reduce(max);
  }

  double _minVelocity(List<GpsData> buffer) {
    return buffer.map((GpsData data) => data.velocity).reduce(min);
  }

  double _calculateDistance(List<GpsData> buffer) {
    return buffer.map((GpsData data) => data.distance ?? 0).reduce((double a, double b) => a + b);
  }

  // Finds max if acceleration, min if deceleration
  double _maxAcceleration(List<GpsData> buffer) {
    final bool isDeceleration = _isDeceleration(buffer);
    return buffer.map((GpsData data) => data.accelerationFromVelocityDerivative ?? 0).reduce(isDeceleration ? min : max);
  }
}
