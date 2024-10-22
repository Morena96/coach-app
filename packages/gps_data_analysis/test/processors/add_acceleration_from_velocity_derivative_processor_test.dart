import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/acceleration/add_acceleration_from_velocity_derivative_processor.dart';

void main() {
  test('Empty stream', () async {
    const Stream<GpsData> stream = Stream<GpsData>.empty();
    final AddAccelerationFromDerivativeProcessor transformer = AddAccelerationFromDerivativeProcessor();
    final List<GpsData> result = await stream.transform(transformer).toList();
    expect(result, isEmpty);
  });

  test('Initial acceleration', () async {
    final List<double> velocities = <double>[12.3, 15.3];
    final List<double> expectedAccelerations = <double>[0, 0.6118];
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(List<GpsData>.generate(
      velocities.length,
      (int index) => GpsData(
        timestamp: DateTime.now().millisecondsSinceEpoch + index * 500,
        latitude: 0,
        longitude: 0,
        velocity: velocities[index],
      ),
    ));

    final AddAccelerationFromDerivativeProcessor transformer = AddAccelerationFromDerivativeProcessor();
    final List<double?> result = await gpsDataStream.transform(transformer).map((GpsData event) => event.accelerationFromVelocityDerivative).toList();

    for (int i = 1; i < velocities.length; i++) {
      expect(result[i], closeTo(expectedAccelerations[i], 0.01));
    }
  });

  test('Zero time difference', () async {
    final List<double> velocities = <double>[12.3, 12.3];
    final List<int> expectedAccelerations = <int>[0, 0];
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(List<GpsData>.generate(
      velocities.length,
      (int index) => GpsData(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        latitude: 0,
        longitude: 0,
        velocity: velocities[index],
      ),
    ));

    final AddAccelerationFromDerivativeProcessor transformer = AddAccelerationFromDerivativeProcessor();
    final List<double?> result = await gpsDataStream.transform(transformer).map((GpsData event) => event.accelerationFromVelocityDerivative).toList();

    expect(result, orderedEquals(expectedAccelerations));
  });

  test('Accelerations calculated correctly case 1', () async {
    final List<double> velocities = <double>[12.3, 15.3, 16.4, 4.4, 7.4, 7.7, 3.4, 18, 20.1];
    final List<double> expectedAccelerations = <double>[0, 0.6118, 0.22434, -2.44, 0.6118, 0.06118, -0.877, 2.9776, 0.4283];
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(List<GpsData>.generate(
      velocities.length,
      (int index) => GpsData(
        timestamp: DateTime.now().millisecondsSinceEpoch + index * 500,
        latitude: 0,
        longitude: 0,
        velocity: velocities[index],
      ),
    ));

    final AddAccelerationFromDerivativeProcessor transformer = AddAccelerationFromDerivativeProcessor();
    final List<double?> result = await gpsDataStream.transform(transformer).map((GpsData event) => event.accelerationFromVelocityDerivative).toList();

    for (int i = 1; i < velocities.length; i++) {
      expect(result[i], closeTo(expectedAccelerations[i], 0.01));
    }
  });

  test('Accelerations calculated correctly case 2', () async {
    final List<double> velocities = <double>[0, 0, 0, 2, 4, 6, 9, 12, 15];
    final List<double?> expectedAccelerations = <double?>[0, 0, 0, 0.40, 0.40, 0.40, 0.61, 0.61, 0.61];
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(List<GpsData>.generate(
      velocities.length,
      (int index) => GpsData(
        timestamp: DateTime.now().millisecondsSinceEpoch + index * 500,
        latitude: 0,
        longitude: 0,
        velocity: velocities[index],
      ),
    ));

    final AddAccelerationFromDerivativeProcessor transformer = AddAccelerationFromDerivativeProcessor();
    final List<double?> result = await gpsDataStream.transform(transformer).map((GpsData event) => event.accelerationFromVelocityDerivative).toList();

    for (int i = 1; i < velocities.length; i++) {
      expect(result[i], expectedAccelerations[i] == null ? null : closeTo(expectedAccelerations[i]!, 0.01));
    }
  });
}
