import 'dart:async';
import 'dart:math';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/processor_mixin.dart';

/// Applies a median filter to a stream of accelerometer data
/// to smooth the incoming signals by reducing noise and fluctuations.
class AddAccelerationProcessor with ProcessorMixin<GpsData> implements StreamTransformer<GpsData, GpsData> {
  static const String name = 'AddAccelerationProcessor';
  AddAccelerationProcessor();

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) {
    return binder(
      stream: stream,
      onData: (GpsData data) {
        // Calculate acceleration list, modify GPSData and add to the stream
        controller!.add(
          data.copyWith(
            acceleration: _calculateAcceleration(data),
          ),
        );
      },
    );
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }

  List<double> _calculateAcceleration(GpsData data) {
    final List<double> acceleration = <double>[];
    for (int i = 0; i < data.accelerationX.length; i++) {
      acceleration.add(sqrt(pow(data.accelerationX[i], 2) + pow(data.accelerationY[i], 2) + pow(data.accelerationZ[i], 2)));
    }
    return acceleration;
  }
}
