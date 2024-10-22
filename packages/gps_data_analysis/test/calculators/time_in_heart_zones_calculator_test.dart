import 'package:test/test.dart';

import 'package:gps_data_analysis/src/calculators/time_in_heart_zones_calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

import '../factories/gps_data_factory.dart';

void main() {
  test('Empty', () async {
    final TimeInHeartRateZonesCalculator calculator = TimeInHeartRateZonesCalculator();
    const Stream<GpsData> stream = Stream<GpsData>.empty();
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();
    expect(result, isEmpty);
  });

  test('51-100 for 0.8 seconds', () async {
    final TimeInHeartRateZonesCalculator calculator = TimeInHeartRateZonesCalculator();
    final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 0, heartRate: 80),
      gpsData(timestamp: 200, heartRate: 54),
      gpsData(timestamp: 400, heartRate: 61),
      gpsData(timestamp: 600, heartRate: 81),
      gpsData(timestamp: 800, heartRate: 92),
    ]);
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();
    expect(result.last[1], 0.8);
  });

  test('Total 0.8 seconds in 5-10 and 20+ (Exceeding highest defined speed zone)', () async {
    final TimeInHeartRateZonesCalculator calculator = TimeInHeartRateZonesCalculator();
    final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 0, heartRate: 80),
      gpsData(timestamp: 200, heartRate: 120),
      gpsData(timestamp: 400, heartRate: 130),
      gpsData(timestamp: 600, heartRate: 80),
      gpsData(timestamp: 800, heartRate: 91),
      gpsData(timestamp: 1000, heartRate: 220),
      gpsData(timestamp: 1200, heartRate: 300),
    ]);
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();

    expect(result.last[1], closeTo(0.4, 0.01)); // Total time in heart zone 50-100
    expect(result.last[2], closeTo(0.4, 0.01)); // Total time in heart zone 100-150
    expect(result.last[4], closeTo(0.4, 0.01)); // Total time in heart zone 200+
  });

  test('Constant heart rates', () async {
    final TimeInHeartRateZonesCalculator calculator = TimeInHeartRateZonesCalculator();
    final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 0, heartRate: 10),
      gpsData(timestamp: 1000, heartRate: 10),
      gpsData(timestamp: 2000, heartRate: 10),
      gpsData(timestamp: 3000, heartRate: 10),
      gpsData(timestamp: 4000, heartRate: 10),
      gpsData(timestamp: 5000, heartRate: 10),
      gpsData(timestamp: 6000, heartRate: 10),
    ]);
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();

    expect(result.last[0], 6);
  });

  test('Test custom provided heart zones', () async {
    final TimeInHeartRateZonesCalculator calculator = TimeInHeartRateZonesCalculator(heartZonesUpperBounds: <double>[100, 200, 300]);
    final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 0, heartRate: 50),
      gpsData(timestamp: 1000, heartRate: 40),
      gpsData(timestamp: 2000, heartRate: 130),
      gpsData(timestamp: 3000, heartRate: 140),
      gpsData(timestamp: 4000, heartRate: 1200),
      gpsData(timestamp: 5000, heartRate: 240),
      gpsData(timestamp: 6000, heartRate: 220),
    ]);
    final List<Map<int, double>> result = await calculator.calculate(stream).toList();
    expect(result.last, equals(<int, double>{0: 1.0, 1: 2.0, 3: 1.0, 2: 2.0}));
  });
}
