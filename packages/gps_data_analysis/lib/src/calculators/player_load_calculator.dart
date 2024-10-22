import 'dart:math';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/processor_mixin.dart';

/// Calculate the Player Load using accelerometer data in our GPS tracking application.
/// This involves computing the Euclidean norm of the difference between consecutive accelerometer
/// readings and accumulating this value to track player exertion over time.
class PlayerLoadCalculator with ProcessorMixin<double> implements Calculator<double> {
  static const String name = 'PlayerLoadCalculator';
  double prevX = 0;
  double prevY = 0;
  double prevZ = 0;
  double cumulativeLoad = 0;

  @override
  Stream<double> calculate(Stream<GpsData> gpsDataStream) {
    return binder(
      stream: gpsDataStream,
      onData: (GpsData gpsData) {
        double instantaneousLoad = 0;
        for (int i = 0; i < gpsData.accelerationX.length; i++) {
          final double deltaX = gpsData.accelerationX[i] - prevX;
          final double deltaY = gpsData.accelerationY[i] - prevY;
          final double deltaZ = gpsData.accelerationZ[i] - prevZ;

          instantaneousLoad = sqrt(deltaX * deltaX + deltaY * deltaY + deltaZ * deltaZ);
          cumulativeLoad += instantaneousLoad;

          prevX = gpsData.accelerationX[i];
          prevY = gpsData.accelerationY[i];
          prevZ = gpsData.accelerationZ[i];
        }
        controller!.add(cumulativeLoad);
      },
    );
  }
}
