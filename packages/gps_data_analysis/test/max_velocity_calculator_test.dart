import 'package:test/test.dart';

import 'package:gps_data_analysis/src/calculators/max_velocity_calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

void main() {
  group('MaxVelocityCalculator Tests', () {
    test('Calculates max velocity from a list of GPSData', () async {
      final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 5),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 15),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 10)
      ]);

      final MaxVelocityCalculator maxVelocityCalculator = MaxVelocityCalculator();
      final Stream<double> resultingStream = maxVelocityCalculator.calculate(gpsDataStream);

      expect(await resultingStream.last, equals(15.0));
    });

    test('Returns 0 for an empty stream', () async {
      final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[]);
      final MaxVelocityCalculator maxVelocityCalculator = MaxVelocityCalculator();
      final Stream<double> resultingStream = maxVelocityCalculator.calculate(gpsDataStream);
      expect(await resultingStream.last, equals(0.0));
    });

    test('Correctly identifies the maximum velocity in a mixed dataset', () async {
      final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 5),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 15),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 10),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 5),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 20),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 10),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 5),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 15),
        GpsData(latitude: 0, longitude: 0, timestamp: DateTime.now().millisecondsSinceEpoch, velocity: 10)
      ]);

      final MaxVelocityCalculator maxVelocityCalculator = MaxVelocityCalculator();
      final Stream<double> resultingStream = maxVelocityCalculator.calculate(gpsDataStream);

      expect(await resultingStream.last, equals(20.0));
    });

    // Add more tests here for additional edge cases and scenarios as needed.
  });
}
