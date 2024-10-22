import 'dart:async';

import 'package:gps_data_analysis/src/models/gps_data.dart';

class AddSignalQualityToStream extends StreamTransformerBase<GpsData, GpsData> {
  static const String name = 'AddSignalQualityToStream';
  final StreamTransformer<GpsData, GpsData> transformer;

  AddSignalQualityToStream() : transformer = _createTransformer();

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) {
    return transformer.bind(stream);
  }

  static StreamTransformer<GpsData, GpsData> _createTransformer() {
    return StreamTransformer<GpsData, GpsData>((Stream<GpsData> input, bool cancelOnError) {
      late StreamController<GpsData> controller;
      StreamSubscription<GpsData>? subscription;

      controller = StreamController<GpsData>(
        onListen: () {
          subscription = input.listen((GpsData data) {
            if (data.hdop == null || data.numberOfSatellites == null) {
              controller.addError('HDOP or number of satellites is null');
              return;
            } else {
              final String quality = determineQuality(data.hdop ?? 25, data.numberOfSatellites ?? 0);
              final GpsData outputData = data.copyWith(signalQuality: quality);
              controller.add(outputData);
            }
          }, onError: controller.addError, onDone: controller.close, cancelOnError: cancelOnError);
        },
        onPause: () => subscription?.pause(),
        onResume: () => subscription?.resume(),
        onCancel: () => subscription?.cancel(),
      );

      return controller.stream.listen(null);
    });
  }

  static String determineQuality(double hdop, int numSatellites) {
    if (hdop < 1.5 && numSatellites >= 12) {
      return 'HIGH';
    } else if (hdop < 2.5 && numSatellites >= 8) {
      return 'HIGH';
    } else if (hdop < 4 && numSatellites >= 5) {
      return 'MEDIUM';
    } else if (hdop < 5 && numSatellites >= 4) {
      return 'MEDIUM';
    } else {
      return 'LOW';
    }
  }
}
