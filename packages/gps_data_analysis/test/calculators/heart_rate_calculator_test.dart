import 'dart:async';

import 'package:gps_data_analysis/src/calculators/heart_rate_calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/models/heart_rate.dart';
import 'package:test/test.dart';

import '../factories/gps_data_factory.dart';

void main() {
  group('HeartRateCalculator', () {
    late HeartRateCalculator heartRateCalculator;

    setUp(() {
      heartRateCalculator = HeartRateCalculator();
    });

    test('Calculate Heart Rate Metrics with empty stream', () {
      const Stream<GpsData> gpsDataStream = Stream<GpsData>.empty();
      expect(heartRateCalculator.calculate(gpsDataStream), emitsDone);
    });

    test('Calculate Heart Rate Metrics with valid data', () async {
      const List<HeartRate> expected = <HeartRate>[
        HeartRate(average: 60, min: 60, max: 60, averagePercentage: 100),
        HeartRate(average: 65, min: 60, max: 70, averagePercentage: (65 / 70) * 100),
        HeartRate(average: 70, min: 60, max: 80, averagePercentage: (70 / 80) * 100),
        HeartRate(average: 75, min: 60, max: 90, averagePercentage: (75 / 90) * 100),
        HeartRate(average: 80, min: 60, max: 100, averagePercentage: (80 / 100) * 100),
      ];

      final List<GpsData> gpsDataList = <GpsData>[
        gpsData(heartRate: 60),
        gpsData(heartRate: 70),
        gpsData(heartRate: 80),
        gpsData(heartRate: 90),
        gpsData(heartRate: 100),
      ];

      final List<HeartRate> result = await heartRateCalculator.calculate(Stream<GpsData>.fromIterable(gpsDataList)).toList();
      for (int i = 0; i < result.length; i++) {
        expect(expected[i], result[i]);
      }
    });

    test('Calculate Heart Rate Metrics with single data point', () async {
      final List<GpsData> gpsDataList = <GpsData>[gpsData(heartRate: 75)];

      const List<HeartRate> expected = <HeartRate>[
        HeartRate(average: 75, min: 75, max: 75, averagePercentage: 100),
      ];

      expect(await heartRateCalculator.calculate(Stream<GpsData>.fromIterable(gpsDataList)).toList(), expected);
    });

    test('Calculate Heart Rate Metrics with large data set', () async {
      final List<GpsData> gpsDataList = List<GpsData>.generate(10, (int index) => gpsData(heartRate: index + 1));

      const List<HeartRate> expected = <HeartRate>[
        HeartRate(average: 1, min: 1, max: 1, averagePercentage: 100),
        HeartRate(average: 1.5, min: 1, max: 2, averagePercentage: (1.5 / 2) * 100),
        HeartRate(average: 2, min: 1, max: 3, averagePercentage: (2 / 3) * 100),
        HeartRate(average: 2.5, min: 1, max: 4, averagePercentage: (2.5 / 4) * 100),
        HeartRate(average: 3, min: 1, max: 5, averagePercentage: (3 / 5) * 100),
        HeartRate(average: 3.5, min: 1, max: 6, averagePercentage: (3.5 / 6) * 100),
        HeartRate(average: 4, min: 1, max: 7, averagePercentage: (4 / 7) * 100),
        HeartRate(average: 4.5, min: 1, max: 8, averagePercentage: (4.5 / 8) * 100),
        HeartRate(average: 5, min: 1, max: 9, averagePercentage: (5 / 9) * 100),
        HeartRate(average: 5.5, min: 1, max: 10, averagePercentage: (5.5 / 10) * 100),
      ];
      final List<HeartRate> result = await heartRateCalculator.calculate(Stream<GpsData>.fromIterable(gpsDataList)).toList();
      for (int i = 0; i < expected.length; i++) {
        expect(expected[i], result[i]);
      }
    });
  });
}
