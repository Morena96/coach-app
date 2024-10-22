import 'dart:async';

import 'package:gps_data_analysis/src/const.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/processor_mixin.dart';

/// Calculates acceleration using the derivative of velocity and adds this calculated acceleration as a new property to GPSData
class AddAccelerationFromDerivativeProcessor with ProcessorMixin<GpsData> implements StreamTransformer<GpsData, GpsData> {
  static const String name = 'AddAccelerationFromDerivativeProcessor';
  GpsData? _previousGpsData;

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) {
    return binder(
      stream: stream,
      onData: (GpsData data) {
        // Calculate acceleration list, modify GPSData and add to the stream
        controller!.add(
          data.copyWith(
            accelerationFromVelocityDerivative: _calculateAcceleration(data),
          ),
        );
        _previousGpsData = data;
      },
    );
  }

  double _calculateAcceleration(GpsData data) {
    double acceleration = 0;
    if (_previousGpsData != null) {
      // Calculate the time difference in seconds
      final double timeDiff = (data.timestamp - _previousGpsData!.timestamp) / 1000;
      if (timeDiff > 0) {
        // Compute acceleration (Δv / Δt) in g
        acceleration = (data.velocity - _previousGpsData!.velocity) / timeDiff / g;
      }
    }
    return acceleration;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}
