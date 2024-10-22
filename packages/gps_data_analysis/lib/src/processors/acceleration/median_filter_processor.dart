import 'dart:async';

import 'package:gps_data_analysis/src/models/gps_data.dart';


/// Applies a median filter to a stream of accelerometer data
/// to smooth the incoming signals by reducing noise and fluctuations.
class MedianFilterProcessor implements StreamTransformer<GpsData, GpsData> {
  static const String name = 'MedianFilterProcessor';
  final int windowSize;

  StreamController<GpsData>? _controller;
  StreamSubscription<GpsData>? _subscription;

  MedianFilterProcessor({this.windowSize = 5});

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) {
    _controller = StreamController<GpsData>(
      onListen: () => _subscription = stream.listen(
        _onData,
        onError: _controller!.addError,
        onDone: _controller!.close,
      ),
      onPause: () => _subscription!.pause(),
      onResume: () => _subscription!.resume(),
      onCancel: () async {
        await _subscription!.cancel();
        _subscription = null;
        if (!_controller!.isClosed) {
          await _controller!.close();
        }
      },
    );
    return _controller!.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }

  void _onData(GpsData data) {
    // Replace all accelerometer lists with median filtered values,
    // modify GPSData and add to the stream
    _controller!.add(
      data.copyWith(
        accelerationX: _applyMedianFilter(data.accelerationX),
        accelerationY: _applyMedianFilter(data.accelerationY),
        accelerationZ: _applyMedianFilter(data.accelerationZ),
      ),
    );
  }

  List<double> _applyMedianFilter(List<double> data) {
    if (data.isEmpty) return <double>[];
    if (windowSize <= 0) return data;

    final List<double> result = <double>[];
    final int radius = windowSize ~/ 2;

    // Loop through windows, sublist with size windowSize
    for (int i = 0; i < data.length; i++) {
      // Define window, radius items to the left and to the right,
      // Escape boundary errors with clamp
      final int start = (i - radius).clamp(0, data.length - 1);
      final int end = (i + radius).clamp(0, data.length - 1);
      final List<double> window = data.sublist(start, end + 1);

      // On the beginning and on the end of the list, window should
      // go beyond borders with values 0. Just adding them to the list
      final List<double> extraZeros = List<double>.generate(
        (windowSize - window.length).clamp(0, windowSize),
        (int index) => 0.0,
      );
      window.addAll(extraZeros);

      // Calculate median and add to the list
      result.add(_getMedian(window));
    }

    return result;
  }

  /// Sort and get middle item(s) as median
  double _getMedian(List<double> data) {
    if (data.isEmpty) return 0;
    data.sort();
    final int middle = data.length ~/ 2;
    // Return middle item if windowSize is even, average of 2 middle items
    // otherwise
    return data.length.isEven ? (data[middle - 1] + data[middle]) / 2 : data[middle];
  }
}
