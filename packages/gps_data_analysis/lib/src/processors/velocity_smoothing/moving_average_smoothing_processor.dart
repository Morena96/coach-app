import 'dart:async';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:rxdart/rxdart.dart';

class MovingAverageSmoothingProcessor
    extends StreamTransformerBase<GpsData, GpsData> {
  static const String name = 'MovingAverageSmoothingProcessor';
  final int windowSize;

  MovingAverageSmoothingProcessor(this.windowSize);

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) {
    return stream.bufferCount(windowSize, 1).map((List<GpsData> list) {
      final double avgVelocity = list
              .map((GpsData data) => data.velocity)
              .reduce((double a, double b) => a + b) /
          list.length;

      return list.last.copyWith(
        velocity: avgVelocity,
      );
    });
  }
}
