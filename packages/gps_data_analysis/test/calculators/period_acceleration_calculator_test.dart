import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'package:gps_data_analysis/gps_data_analysis.dart';

void main() {
  test('Empty stream', () async {
    final PeriodAccelerationCalculator calculator = PeriodAccelerationCalculator(accelerationThreshold: 2, minDuration: 1.5);
    const Stream<GpsData> stream = Stream<GpsData>.empty();

    final List<Acceleration> result = await calculator.calculate(stream).toList();
    expect(result, isEmpty);
  });

  test('Acceleration and deceleration found correctly', () async {
    final List<double> accelerations = <double>[0.4, -1, 1.2, 2.2, 2.5, 3.3, 4.2, 1.1, 0.1, -3, -2.2, -2.1];
    final List<double> velocities = <double>[1, 2, 3, 4, 3, 2, 3, 1, 3, 8, 4, 12];
    final List<double> distances = <double>[1, 2, 3, 4, 3, 2, 3, 1, 3, 8, 4, 12];

    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(List<GpsData>.generate(
      accelerations.length,
      (int index) => GpsData(
        timestamp: DateTime.now().millisecondsSinceEpoch + index * 500,
        latitude: 0,
        longitude: 0,
        velocity: velocities[index],
        distance: distances[index],
        accelerationFromVelocityDerivative: accelerations[index],
      ),
    ));

    final PeriodAccelerationCalculator calculator = PeriodAccelerationCalculator(accelerationThreshold: 2, minDuration: 1);
    final List<Acceleration> result = await calculator.calculate(gpsDataStream).toList();

    expect(result.length, 2);

    // First Acceleration
    expect(result.first.duration, 1.5);
    expect(result.first.distanceCovered, 12.0);
    expect(result.first.maxVelocity, 4);
    expect(result.first.minVelocity, 2);
    expect(result.first.maxAccelerationReached, 4.2);
    expect(result.first.isDeceleration, false);
    expect(const ListEquality<double>().equals(result.first.components, <double>[2.2, 2.5, 3.3, 4.2]), true);

    expect(result.last.duration, 1);
    expect(result.last.distanceCovered, 24.0);
    expect(result.last.maxVelocity, 12);
    expect(result.last.minVelocity, 4);
    expect(result.last.maxAccelerationReached, -3);
    expect(result.last.isDeceleration, true);
    expect(const ListEquality<double>().equals(result.last.components, <double>[-3, -2.2, -2.1]), true);
  });

  test('Acceleration meets threshold but duration is below minimum', () async {
    final List<double> accelerations = <double>[0.1, 1.9, 0.8, 1.5];

    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(List<GpsData>.generate(
      accelerations.length,
      (int index) => GpsData(
        timestamp: DateTime.now().millisecondsSinceEpoch + index * 500,
        latitude: 0,
        longitude: 0,
        velocity: 0,
        accelerationFromVelocityDerivative: accelerations[index],
      ),
    ));

    final PeriodAccelerationCalculator calculator = PeriodAccelerationCalculator(accelerationThreshold: 0.5, minDuration: 1.5);
    final List<Acceleration> result = await calculator.calculate(gpsDataStream).toList();

    expect(result, isEmpty);
  });

  test('All data is one big acceleration', () async {
    final List<double> accelerations = <double>[5, 4, 5, 4, 3, 4];

    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(List<GpsData>.generate(
      accelerations.length,
      (int index) => GpsData(
        timestamp: DateTime.now().millisecondsSinceEpoch + index * 500,
        latitude: 0,
        longitude: 0,
        velocity: 0,
        accelerationFromVelocityDerivative: accelerations[index],
      ),
    ));

    final PeriodAccelerationCalculator calculator = PeriodAccelerationCalculator(accelerationThreshold: 3, minDuration: 1);
    final List<Acceleration> result = await calculator.calculate(gpsDataStream).toList();

    expect(result.length, 1);
    expect(result.first.components.length, 6);
  });
}
