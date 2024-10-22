import 'package:test/test.dart';

import 'package:gps_data_analysis/src/calculators/instantaneous_velocity_calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

import 'factories/gps_data_factory.dart';

void main() {
  group('InstantaneousVelocityCalculator Tests', () {
    test('Calculates instantaneous velocity correctly', () async {
      // Test data
      final Stream<GpsData> data = Stream<GpsData>.value(gpsData(velocity: 10));

      // Execute
      final InstantaneousVelocityCalculator calculator = InstantaneousVelocityCalculator();

      final Stream<double> resultStream = calculator.calculate(data);

      final double result = await resultStream.last;

      // Validate
      expect(result, equals(10.0));
    });
  });
}
