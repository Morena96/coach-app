import 'dart:math';

import 'package:test/test.dart';

import 'package:gps_data_analysis/src/calculators/max_acceleration_calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/acceleration/add_acceleration_processor.dart';

import 'factories/gps_data_factory.dart';

void main() {
  test('Maximum acceleration magnitude for 1 GPSData is calculated correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: List<double>.generate(80, (int index) => index.toDouble()),
        accelerationY: List<double>.generate(80, (int index) => index.toDouble()),
        accelerationZ: List<double>.generate(80, (int index) => index.toDouble()),
      ),
    ]).transform(AddAccelerationProcessor());

    final MaxAccelerationCalculator calculator = MaxAccelerationCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    // Magnitude of an increasing sequence
    expect(result.first, closeTo(79 * sqrt(3), 0.01));
  });

  test('Maximum acceleration magnitude for 3 GPSData is calculated correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: List<double>.generate(80, (int index) => 15),
        accelerationY: List<double>.generate(80, (int index) => 15),
        accelerationZ: List<double>.generate(80, (int index) => 15),
      ),
      gpsData(
        accelerationX: List<double>.generate(80, (int index) => (2 * index).toDouble()),
        accelerationY: List<double>.generate(80, (int index) => (2 * index).toDouble()),
        accelerationZ: List<double>.generate(80, (int index) => (2 * index).toDouble()),
      ),
      gpsData(
        accelerationX: List<double>.generate(80, (int index) => (-index).toDouble()),
        accelerationY: List<double>.generate(80, (int index) => (-index).toDouble()),
        accelerationZ: List<double>.generate(80, (int index) => (-index).toDouble()),
      ),
    ]).transform(AddAccelerationProcessor());

    final MaxAccelerationCalculator calculator = MaxAccelerationCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    expect(result.first, closeTo(15 * sqrt(3), 0.01));
    expect(result[1], closeTo(2 * 79 * sqrt(3), 0.01));
    expect(result.last, closeTo(2 * 79 * sqrt(3), 0.01));
  });

  test('Maximum acceleration magnitude for custom GPSData is calculated correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: <double>[3, 4, -2],
        accelerationY: <double>[-12, 2, 0],
        accelerationZ: <double>[2, 4.3, 41],
      ),
    ]).transform(AddAccelerationProcessor());

    final MaxAccelerationCalculator calculator = MaxAccelerationCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    expect(
      result.first,
      closeTo(sqrt(2 * 2 + 41 * 41), 0.01),
    );
  });

  test('Maximum acceleration magnitude for custom GPSData is calculated correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[gpsData()]);

    final MaxAccelerationCalculator calculator = MaxAccelerationCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    expect(result, hasLength(1));
    expect(result.first, 0.0);
  });

  test('throws error when acceleration length is not equal', () {
    expect(
      () => GpsData(
        timestamp: 0,
        latitude: 0,
        longitude: 0,
        velocity: 0,
        accelerationX: <double>[1, 2],
        accelerationY: <double>[1, 2, 3],
        accelerationZ: <double>[1, 2, 3],
      ),
      throwsA(isA<AssertionError>()),
    );
  });
}
