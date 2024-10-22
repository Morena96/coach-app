import 'dart:async';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/processor_mixin.dart';

/// Converts speeds less than speedThreshold to 0
class LowSpeedValueProcessor with ProcessorMixin<GpsData> implements StreamTransformer<GpsData, GpsData> {
  static const String name = 'LowSpeedValueProcessor';
  final double speedThreshold;

  LowSpeedValueProcessor(this.speedThreshold);

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) {
    return binder(
      stream: stream,
      onData: (GpsData data) {
        // Change with 0 if less than threshold
        controller!.add(
          data.velocity < speedThreshold ? data.copyWith(velocity: 0) : data,
        );
      },
    );
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}
