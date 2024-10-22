import 'dart:async';

import 'package:gps_data_analysis/gps_data_analysis.dart';

mixin ProcessorMixin<T> {
  StreamController<T>? controller;
  StreamSubscription<GpsData>? subscription;

  Stream<T> binder({
    required Stream<GpsData> stream,
    required void Function(GpsData) onData,
    void Function()? onDone,
  }) {
    controller = StreamController<T>(
      onListen: () => subscription = stream.listen(
        onData,
        onError: controller!.addError,
        onDone: () {
          onDone?.call();
          controller!.close();
        },
      ),
      onPause: () => subscription!.pause(),
      onResume: () => subscription!.resume(),
      onCancel: () {
        subscription!.cancel();
        subscription = null;
      },
    );
    return controller!.stream;
  }
}
