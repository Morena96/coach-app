import 'dart:async';

import 'package:gps_data_analysis/src/models/gps_data.dart';


class ErrorFilterProcessor extends StreamTransformerBase<GpsData, GpsData> {
  static const String name = 'ErrorFilterProcessor';
  final StreamTransformer<GpsData, GpsData> transformer;

  ErrorFilterProcessor() : transformer = _createTransformer();

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) => stream.transform(transformer);

  static StreamTransformer<GpsData, GpsData> _createTransformer() {
    return StreamTransformer<GpsData, GpsData>((Stream<GpsData> input, bool cancelOnError) {
      late StreamController<GpsData> controller;
      late StreamSubscription<GpsData> subscription;

      controller = StreamController<GpsData>(
        onListen: () {
          subscription = input.listen(
            (GpsData data) {
              if (_isValidData(data)) {
                controller.add(data);
              } // Else, the data is simply not forwarded (filtered out)
            },
            onError: controller.addError,
            onDone: controller.close,
            cancelOnError: cancelOnError,
          );
        },
        onPause: () => subscription.pause(),
        onResume: () => subscription.resume(),
        onCancel: () => subscription.cancel(),
      );

      return controller.stream.listen(null);
    });
  }

  static bool _isValidData(GpsData data) {
    return data.velocity > 0 && data.velocity < 200;
  }
}
