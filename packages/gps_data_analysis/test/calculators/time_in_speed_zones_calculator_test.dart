import 'package:test/test.dart';

import 'package:gps_data_analysis/src/calculators/time_in_speed_zones_calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

import '../factories/gps_data_factory.dart';

void main() {
  test('Empty', () async {
    final TimeInSpeedZonesCalculator calculator = TimeInSpeedZonesCalculator();
    const Stream<GpsData> stream = Stream<GpsData>.empty();
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();

    expect(result, isEmpty);
  });

  test('Total 0.8 seconds in 5-10', () async {
    final TimeInSpeedZonesCalculator calculator = TimeInSpeedZonesCalculator();
    final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 0, velocity: 1000),
      gpsData(timestamp: 200, velocity: 5.1),
      gpsData(timestamp: 400, velocity: 6),
      gpsData(timestamp: 600, velocity: 8),
      gpsData(timestamp: 800, velocity: 9),
    ]);
    calculator.calculate(stream).skip(1).take(1).listen((Map<int, double> event) {
      expect(event[1], 0.2);
    });
  });

  test('Total 0.8 seconds in 5-10 and 20+ (Exceeding highest defined speed zone)', () async {
    final TimeInSpeedZonesCalculator calculator = TimeInSpeedZonesCalculator();
    final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 0, velocity: 1000),
      gpsData(timestamp: 200, velocity: 5.1),
      gpsData(timestamp: 400, velocity: 6),
      gpsData(timestamp: 600, velocity: 8),
      gpsData(timestamp: 800, velocity: 9),
      gpsData(timestamp: 1000, velocity: 25),
      gpsData(timestamp: 1200, velocity: 30),
    ]);
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();

    expect(result.last[1], 0.8); // Total time in speed zone 5-10
    expect(result.last[3], 0.4); // Total time in speed zone 20+
  });

  test('Subject not moves', () async {
    final TimeInSpeedZonesCalculator calculator = TimeInSpeedZonesCalculator();
    final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 0),
      gpsData(timestamp: 1000),
      gpsData(timestamp: 2000),
      gpsData(timestamp: 3000),
      gpsData(timestamp: 4000),
      gpsData(timestamp: 5000),
      gpsData(timestamp: 6000),
    ]);
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();

    expect(result.last[0], 6);
  });

  test('Test custom provided speed zones', () async {
    final TimeInSpeedZonesCalculator calculator = TimeInSpeedZonesCalculator(speedZonesUpperBounds: <double>[100, 200, 300]);
    final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 0, velocity: 50),
      gpsData(timestamp: 1000, velocity: 40),
      gpsData(timestamp: 2000, velocity: 130),
      gpsData(timestamp: 3000, velocity: 140),
      gpsData(timestamp: 4000, velocity: 1200),
      gpsData(timestamp: 5000, velocity: 240),
      gpsData(timestamp: 6000, velocity: 220),
    ]);
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();
    expect(result.last, equals(<int, double>{0: 1.0, 1: 2.0, 3: 1.0, 2: 2.0}));
  });

  // });
}
