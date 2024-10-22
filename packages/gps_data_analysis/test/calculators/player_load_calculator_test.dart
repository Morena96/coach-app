import 'dart:math';

import 'package:test/test.dart';

import 'package:gps_data_analysis/src/calculators/player_load_calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

import '../factories/gps_data_factory.dart';

void main() {
  test('Empty stream returns nothing', () async {
    const Stream<GpsData> gpsDataStream = Stream<GpsData>.empty();

    final PlayerLoadCalculator calculator = PlayerLoadCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    expect(result, isEmpty);
  });

  test('Player has not acceleration', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: <double>[0, 0, 0],
        accelerationY: <double>[0, 0, 0],
        accelerationZ: <double>[0, 0, 0],
      ),
    ]);
    final PlayerLoadCalculator calculator = PlayerLoadCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    expect(result.length, 1);
    expect(result.first, 0);
  });

  test('Calculates cumulative load correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: <double>[1, 1],
        accelerationY: <double>[1, 1],
        accelerationZ: <double>[1, 1],
      ),
    ]);

    final PlayerLoadCalculator calculator = PlayerLoadCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    expect(result.length, 1);
    expect(result.first, closeTo(sqrt(3), 0.01));
  });

  test('Calculates cumulative load correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: <double>[2, 0],
        accelerationY: <double>[1, 5],
        accelerationZ: <double>[-1, 4],
      ),
    ]);

    final PlayerLoadCalculator calculator = PlayerLoadCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    expect(result.first, closeTo(sqrt(2 * 2 + 1 * 1 + 1 * 1) + sqrt(2 * 2 + 4 * 4 + 5 * 5), 0.01));
  });

  test('Calculates cumulative load correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: <double>[-2, 0],
        accelerationY: <double>[1, 2],
        accelerationZ: <double>[-3, 1],
      ),
      gpsData(
        accelerationX: <double>[2],
        accelerationY: <double>[1],
        accelerationZ: <double>[1],
      ),
      gpsData(
        accelerationX: <double>[0, 4],
        accelerationY: <double>[1, 5],
        accelerationZ: <double>[-3, 1],
      ),
    ]);

    final PlayerLoadCalculator calculator = PlayerLoadCalculator();
    final List<double> result = await calculator.calculate(gpsDataStream).toList();

    final double a = sqrt(4 + 1 + 9) + sqrt(4 + 1 + 16);
    final double b = sqrt(4 + 1 + 0);
    final double c = sqrt(4 + 0 + 16) + sqrt(16 + 16 + 16);

    expect(result.length, 3);
    expect(result[0], closeTo(a, 0.01));
    expect(result[1], closeTo(a + b, 0.01));
    expect(result[2], closeTo(a + b + c, 0.01));
  });
}
