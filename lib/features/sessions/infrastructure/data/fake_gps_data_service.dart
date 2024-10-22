import 'dart:async';
import 'dart:math';

import 'package:gps_data_analysis/gps_data_analysis.dart';
import 'package:rxdart/rxdart.dart';

class FakeGpsDataService {
  final _random = Random();
  final _gpsDataController = BehaviorSubject<GpsData>();
  final _isGeneratingData = BehaviorSubject<bool>.seeded(false);

  Stream<GpsData> get gpsDataStream => _gpsDataController.stream;
  Stream<bool> get isGeneratingDataStream => _isGeneratingData.stream;

  double _currentVelocity = 0.0;
  double _targetVelocity = 0.0;
  int _sprintDuration = 0;

  // Starting point: Central Park, New York City
  double _currentLatitude = 40.785091;
  double _currentLongitude = -73.968285;

  Timer? _dataGenerationTimer;

  void startGeneratingData() {
    // Cancel any existing timer before starting a new one
    stopGeneratingData();

    _isGeneratingData.add(true);

    _dataGenerationTimer =
        Timer.periodic(const Duration(milliseconds: 100), (_) {
      _updateSprintTargetIfNeeded();
      _updateVelocityWithJitter();
      _updatePosition();

      // Generate GPS data with current velocity and position
      _gpsDataController.add(_generateFakeGpsData());
    });
  }

  void stopGeneratingData() {
    _dataGenerationTimer?.cancel();
    _dataGenerationTimer = null;
    _isGeneratingData.add(false);
  }

  Future<void> dispose() async {
    stopGeneratingData();
    await _gpsDataController.close();
  }

  bool isGeneratingData() {
    return _dataGenerationTimer != null && _dataGenerationTimer!.isActive;
  }

  List<GpsData> generateDataForTimeRange(DateTime start, DateTime end) {
    List<GpsData> dataList = [];
    DateTime current = start;
    Duration interval = const Duration(milliseconds: 100); // 10Hz

    while (current.isBefore(end)) {
      _updateSprintTargetIfNeeded();
      _updateVelocityWithJitter();
      _updatePosition();

      dataList
          .add(_generateFakeGpsData(timestamp: current.millisecondsSinceEpoch));
      current = current.add(interval);
    }

    return dataList;
  }

  void _updateSprintTargetIfNeeded() {
    if (_sprintDuration <= 0) {
      // Randomly select the next target velocity type
      final sprintType = _random.nextInt(3);
      switch (sprintType) {
        case 0:
          _targetVelocity =
              _random.nextDouble() * 3 + 2; // Small sprint (2-5 m/s)
          _sprintDuration = _random.nextInt(20) + 20; // Lasts for 2-4 seconds
          break;
        case 1:
          _targetVelocity =
              _random.nextDouble() * 4 + 6; // Medium sprint (6-10 m/s)
          _sprintDuration = _random.nextInt(30) + 30; // Lasts for 3-6 seconds
          break;
        case 2:
          _targetVelocity =
              _random.nextDouble() * 6 + 12; // Fast sprint (12-18 m/s)
          _sprintDuration = _random.nextInt(40) + 20; // Lasts for 2-4 seconds
          break;
      }
    } else {
      _sprintDuration--;
    }
  }

  void _updateVelocityWithJitter() {
    // Adjust velocity towards the target to create a realistic acceleration/deceleration
    if (_currentVelocity < _targetVelocity) {
      _currentVelocity += 0.5; // Accelerate smoothly
      if (_currentVelocity > _targetVelocity) {
        _currentVelocity = _targetVelocity;
      }
    } else if (_currentVelocity > _targetVelocity) {
      _currentVelocity -= 0.5; // Decelerate smoothly
      if (_currentVelocity < _targetVelocity) {
        _currentVelocity = _targetVelocity;
      }
    }

    // Add a small random jitter to make the velocity more realistic
    double jitter =
        (_random.nextDouble() - 0.5) * 0.5; // Jitter range: -0.25 to +0.25 m/s
    _currentVelocity += jitter;

    // Ensure velocity is never negative
    if (_currentVelocity < 0) {
      _currentVelocity = 0;
    }
  }

  void _updatePosition() {
    // Convert velocity from m/s to degrees/s (approximate at equator)
    double velocityDeg = _currentVelocity / 111000;

    // Generate a random direction
    double direction = _random.nextDouble() * 2 * pi;

    // Update latitude and longitude
    _currentLatitude +=
        velocityDeg * cos(direction) * 0.1; // 0.1 to adjust for 100ms interval
    _currentLongitude += velocityDeg * sin(direction) * 0.1;

    // Ensure latitude stays within valid range
    _currentLatitude = _currentLatitude.clamp(-90, 90);
    // Longitude wraps around, so no clamping needed
  }

  GpsData _generateFakeGpsData({int? timestamp}) {
    return GpsData(
      velocity: _currentVelocity,
      accelerationX: List.generate(
          8,
          (_) =>
              (_random.nextDouble() * 5) +
              (_random.nextDouble() - 0.5) *
                  0.2), // Random acceleration with jitter
      accelerationY: List.generate(
          8,
          (_) =>
              (_random.nextDouble() * 5) + (_random.nextDouble() - 0.5) * 0.2),
      accelerationZ: List.generate(
          8,
          (_) =>
              (_random.nextDouble() * 5) + (_random.nextDouble() - 0.5) * 0.2),
      timestamp: timestamp ?? DateTime.now().millisecondsSinceEpoch,
      latitude: _currentLatitude,
      longitude: _currentLongitude,
    );
  }
}
