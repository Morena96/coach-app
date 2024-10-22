import 'dart:async';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:rxdart/rxdart.dart';

class AddDistanceToStreamUsingTrapezoidProcessor extends StreamTransformerBase<GpsData, GpsData> {
  static const String name = 'AddDistanceToStreamUsingTrapezoidProcessor';
  final StreamTransformer<GpsData, GpsData> transformer;

  AddDistanceToStreamUsingTrapezoidProcessor() : transformer = _createTransformer();

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) {
    return transformer.bind(stream);
  }

  static StreamTransformer<GpsData, GpsData> _createTransformer() {
    return StreamTransformer<GpsData, GpsData>((Stream<GpsData> input, bool cancelOnError) {
      late StreamController<GpsData> controller;
      StreamSubscription<List<GpsData>>? subscription;
      double accumulatedDistance = 0;
      const int maxAllowedTimestampDiff = 1000; // Maximum allowed timestamp difference in milliseconds

      controller = StreamController<GpsData>(
          onListen: () {
            subscription = input.pairwise().listen((List<GpsData> pair) {
              // Correctly handle the List<GPSData>
              final GpsData previousData = pair[0];
              final GpsData currentData = pair[1];
              final int timeDelta = currentData.timestamp - previousData.timestamp;
              double distanceDelta = 0;

              if (timeDelta <= maxAllowedTimestampDiff) {
                // Only calculate distance if timestamps are within the allowed range
                // ensure that we are only using positive values
                final double averageVelocity = (currentData.velocity + previousData.velocity) / 2.0;
                distanceDelta = averageVelocity.abs() * (timeDelta / 1000.0); // Convert ms to seconds
                accumulatedDistance += distanceDelta;
              } else {
                // assume timestamp difference is the max allowed value
                final double averageVelocity = (currentData.velocity + previousData.velocity) / 2.0;
                distanceDelta = averageVelocity.abs() * (maxAllowedTimestampDiff / 1000.0); // Convert ms to seconds
                accumulatedDistance += distanceDelta;
              }

              final GpsData outputData = currentData.copyWith(distance: distanceDelta, accumulatedDistance: accumulatedDistance);

              controller.add(outputData);
            }, onError: controller.addError, onDone: controller.close, cancelOnError: cancelOnError);
          },
          onPause: () => subscription?.pause(),
          onResume: () => subscription?.resume(),
          onCancel: () => subscription?.cancel());

      return controller.stream.listen(null);
    });
  }
}
