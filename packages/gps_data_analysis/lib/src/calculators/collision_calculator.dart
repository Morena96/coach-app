import 'dart:async';
import 'dart:math';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/collision.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/acceleration/add_acceleration_processor.dart';

/// Calculates collisions using threshold-based detection, Peak Linear Acceleration (PLA),
/// feature engineering, and a confirmation mechanism. The output should be a Stream<Collision>
class CollisionCalculator extends Calculator<Collision> {
  static const String name = 'CollisionCalculator';
  StreamController<Collision>? _controller;
  StreamSubscription<GpsData>? _subscription;

  GpsData? _recentData;

  // Window size for tracking recent data
  final int windowSize = 10;

  // Factor for dynamic threshold adjustment
  final double thresholdFactor = 10;

  final List<double> _recentPLA = <double>[];

  final double initialThreshold;
  late double currentThreshold;

  CollisionCalculator({required this.initialThreshold});

  @override
  Stream<Collision> calculate(Stream<GpsData> gpsDataStream) {
    currentThreshold = initialThreshold;
    _controller = StreamController<Collision>(
      // Where to accept AddAccelerationProcessor()?
      onListen: () => _subscription = gpsDataStream.transform(AddAccelerationProcessor()).listen(
        (GpsData data) {
          final double pla = _peakAcceleration(data.acceleration);
          if (pla < currentThreshold) _recentPLA.add(pla);

          if (_recentData != null && pla > currentThreshold) {
            _controller?.add(Collision(
              timestamp: data.timestamp,
              latitude: data.latitude,
              longitude: data.longitude,
              acceleration: data.acceleration[0],
              velocity: data.velocity,
              gaddSeverityIndex: _gaddSeverityIndex(data, pla),
              headInjuryCriterion: _calculateHIC(data),
              peakLinearAcceleration: pla,
            ));
          }

          _updateThreshold(pla);
          _recentData = data;
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

  void _updateThreshold(double pla) {
    if (_recentPLA.length > windowSize) _recentPLA.removeAt(0);
    final double meanAcceleration = _recentPLA.reduce((double a, double b) => a + b) / _recentPLA.length;
    final double standardDeviation = _calculateStandardDeviation(_recentPLA);
    final double calculatedThreshold = meanAcceleration + thresholdFactor * standardDeviation;
    currentThreshold = _recentPLA.length < windowSize / 2 ? (calculatedThreshold + initialThreshold) / 2 : calculatedThreshold;
    print('$pla $meanAcceleration $standardDeviation $calculatedThreshold');
  }

  // Bessel's correction for population standard deviation
  double _calculateStandardDeviation(List<double> data) {
    if (data.isEmpty) return 0;
    double squaredDifferencesSum = 0;
    final double mean = data.reduce((double a, double b) => a + b) / data.length;
    for (final double value in data) {
      squaredDifferencesSum += pow(value - mean, 2);
    }
    return sqrt(squaredDifferencesSum / max(data.length - 1, 1));
  }

  double _gaddSeverityIndex(GpsData data, double pla) {
    if (pla <= 0) return 0;
    final num a3 = pow(pla, 3.0);
    final double gsi = 0.5 * a3 * getDuration(data);
    return gsi;
  }

  double _peakAcceleration(List<double> acceleration) {
    return acceleration.reduce(max);
  }

  double _calculateHIC(GpsData data) {
    return pow(data.acceleration.first, 2.5) * getDuration(data) as double;
  }

  int getDuration(GpsData data) => data.timestamp - _recentData!.timestamp;
}
