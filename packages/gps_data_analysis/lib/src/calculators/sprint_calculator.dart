import 'dart:async';
import 'dart:math';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/models/sprint.dart';
import 'package:gps_data_analysis/src/utils/converter.dart';
import 'package:rxdart/rxdart.dart';

// void main() {
//   final Stream<GpsData> gpsDataStream = CsvReader(filePath: 'data2/mclloyd5.csv').readAsGPSData().transform(AddDistanceToStreamUsingTrapezoidProcessor());
//   SprintCalculator(minVelocityThreshold: 5).calculate(gpsDataStream).listen(print);
// }

/// This class calculates sprints from a stream of GPS data points.
/// A sprint is defined as a period where the velocity is above a
/// minimum threshold for a sustained period (windowSize).
class SprintCalculator extends Calculator<Sprint> {
  static const String name = 'SprintCalculator';
  StreamController<Sprint>? _controller;
  StreamSubscription<GpsData>? _subscription;

  /// The minimum velocity (in meters per second) required to be considered a sprint.
  final double minVelocityThreshold;
  double maxVelocity = 0;
  final List<double> _velocities = <double>[];

  SprintCalculator({this.minVelocityThreshold = 5});

  @override
  Stream<Sprint> calculate(Stream<GpsData> gpsDataStream) {
    _controller = StreamController<Sprint>(
      onListen: () => _subscription = gpsDataStream.endWith(GpsData.empty()).listen(
        (GpsData data) {
          maxVelocity = max(maxVelocity, data.velocity);

          // Couldn't be considered as sprint
          if ((!_isSprint) && data.velocity < _prevVelocity) _reset();

          // Mark as start point of sprint
          final bool isSprintStart = !_isSprint && data.velocity >= minVelocityThreshold;
          // Mark as end point of sprint if: sprint is going, v is below threshold and (starts accelerate of too short for sprint, to exclude jitters)
          final bool isSprintEnd = _isSprint && data.velocity < minVelocityThreshold && (data.velocity > _prevVelocity || data.velocity == 0 || data.timestamp - (_startTime ?? data.timestamp) < 1000);

          // Determine if we are currently in a sprint.
          _isSprint = (isSprintStart || _isSprint) && !isSprintEnd;

          // Check and record time for specific distances.
          if (_time10yd == null && _distance > yardToMeter(10)) _time10yd = Duration(milliseconds: data.timestamp - _startTime!);
          if (_time30yd == null && _distance > yardToMeter(30)) _time30yd = Duration(milliseconds: data.timestamp - _startTime!);
          if (_time40yd == null && _distance > yardToMeter(40)) _time40yd = Duration(milliseconds: data.timestamp - _startTime!);

          if (isSprintEnd) {
            _totalTime = isSprintEnd ? Duration(milliseconds: _endTime! - _startTime!) : Duration.zero;

            // Only consider it a sprint if total time is greater than 1 second.
            if (_totalTime.inMilliseconds > 1000) {
              _controller?.add(Sprint(
                startTime: _startTime!,
                endTime: _endTime!,
                totalDistance: _distance,
                maxSpeed: maxVelocity,
                totalTime: _totalTime,
                time10yd: _time10yd,
                time30yd: _time30yd,
                time40yd: _time40yd,
                velocities: List<double>.from(_velocities),
              ));
            }

            _reset();
          }

          // Possible start for a sprint, if not, will be reset
          _velocities.add(data.velocity);
          _startTime = _startTime ?? data.timestamp;
          _prevVelocity = data.velocity;

          _endTime = data.timestamp;
          _distance += data.distance ?? 0.0;
        },
        onError: _controller!.addError,
        onDone: _controller!.close,
      ),
      onPause: () => _subscription!.pause(),
      onResume: () => _subscription!.resume(),
      onCancel: () {
        _subscription!.cancel();
        _subscription = null;
      },
    );
    return _controller!.stream;
  }

  void _reset() {
    _isSprint = false;
    _startTime = null;
    _time10yd = null;
    _time30yd = null;
    _time40yd = null;
    _distance = 0;
    maxVelocity = 0;
    _velocities.clear();
  }

  bool _isSprint = false;
  int? _startTime;
  int? _endTime;
  double _distance = 0;
  double _prevVelocity = 0;
  Duration _totalTime = Duration.zero;
  Duration? _time10yd;
  Duration? _time30yd;
  Duration? _time40yd;
}
