import 'dart:async';

import 'package:gps_data_analysis/src/models/gps_data.dart';

class KalmanSmoothingProcessor extends StreamTransformerBase<GpsData, GpsData> {
  static const String name = 'KalmanSmoothingProcessor';
  final double errorMeasure;
  double errorEstimate;
  final double filterSensitivityFactor;

  KalmanSmoothingProcessor({
    this.errorMeasure = 0.3,
    this.errorEstimate = 1,
    this.filterSensitivityFactor = 0.9, // (0.001 ... 10)
  });

  @override
  Stream<GpsData> bind(Stream<GpsData> dataStream) {
    // StreamController and StreamSubscription declaration
    late StreamController<GpsData> controller;
    late StreamSubscription<GpsData> subscription;

    double lastEstimate = 0;
    bool isFirstData = true;

    // Kalman filter variables
    void onData(GpsData data) {
      if (isFirstData) {
        lastEstimate = data.velocity;
        isFirstData = false;
      }

      double kalmanGain;
      double currentEstimate;
      kalmanGain = errorEstimate / (errorEstimate + errorMeasure);
      currentEstimate = lastEstimate + kalmanGain * (data.velocity - lastEstimate);
      errorEstimate = (1.0 - kalmanGain) * errorEstimate + (lastEstimate - currentEstimate).abs() * filterSensitivityFactor;
      lastEstimate = currentEstimate;

      controller.add(data.copyWith(velocity: currentEstimate));
    }

    controller = StreamController<GpsData>(
      onListen: () {
        subscription = dataStream.listen(
          onData,
          onError: controller.addError,
          onDone: controller.close,
          cancelOnError: true,
        );
      },
      onPause: () => subscription.pause(),
      onResume: () => subscription.resume(),
      onCancel: () => subscription.cancel(),
    );

    return controller.stream;
  }
}
