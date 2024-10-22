import 'package:gps_data_analysis/gps_data_analysis.dart';
import 'package:test/test.dart';

import '../factories/gps_data_factory.dart';

void main() {
  group('SprintCalculator', () {
    test('handles empty stream correctly', () async {
      final SprintCalculator calculator = SprintCalculator();
      const Stream<GpsData> stream = Stream<GpsData>.empty();
      final List<Sprint> result = await calculator.calculate(stream).toList();
      expect(result, isEmpty);
    });

    test('not finds any sprint', () async {
      final SprintCalculator calculator = SprintCalculator();
      final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(timestamp: 1000, velocity: 1.5),
        gpsData(timestamp: 2000, velocity: 1.5),
        gpsData(timestamp: 3000, velocity: 1.5),
      ]).transform(AddDistanceToStreamUsingTrapezoidProcessor());
      final List<Sprint> result = await calculator.calculate(stream).toList();
      expect(result, isEmpty);
    });

    test('finds 1 sprint with correct data', () async {
      final SprintCalculator calculator = SprintCalculator();
      final Stream<GpsData> stream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(timestamp: 0, velocity: 1.7),
        gpsData(timestamp: 1000, velocity: 1.5),
        gpsData(timestamp: 2000, velocity: 6),
        gpsData(timestamp: 3000, velocity: 6),
        gpsData(timestamp: 4000, velocity: 6),
        gpsData(timestamp: 5000, velocity: 6),
        gpsData(timestamp: 6000, velocity: 1),
        gpsData(timestamp: 7000, velocity: 2),
      ]).transform(AddDistanceToStreamUsingTrapezoidProcessor());

      final List<Sprint> result = await calculator.calculate(stream).toList();

      expect(result.length, 1);
      expect(result.first.maxSpeed, 6);
      expect(result.first.totalTime.inSeconds, 5);
      expect(result.first.startTime, 1000);
      expect(result.first.endTime, 6000);
      expect(result.first.time10yd?.inSeconds, 3);
      expect(result.first.time30yd, null);
      expect(result.first.time40yd, null);
    });

    test('should not calculate sprint for velocities below threshold', () async {
      final SprintCalculator calculator = SprintCalculator();
      final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(timestamp: 1000, velocity: 4.5),
        gpsData(timestamp: 2000, velocity: 4.8),
        gpsData(timestamp: 3000, velocity: 4.9),
      ]).transform(AddDistanceToStreamUsingTrapezoidProcessor());

      final List<Sprint> sprints = await calculator.calculate(gpsDataStream).toList();

      expect(sprints, isEmpty);
    });

    test('should calculate a sprint correctly', () async {
      final SprintCalculator calculator = SprintCalculator();
      final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(timestamp: 1000, velocity: 2.5, distance: 0),
        gpsData(timestamp: 2000, velocity: 5.2, distance: 5),
        gpsData(timestamp: 3000, velocity: 5.5, distance: 10),
        gpsData(timestamp: 4000, velocity: 5.8, distance: 15),
        gpsData(timestamp: 5000, velocity: 3.9, distance: 20),
        gpsData(timestamp: 6000, velocity: 4.5, distance: 25),
      ]);

      final List<Sprint> sprints = await calculator.calculate(gpsDataStream).toList();

      expect(sprints.length, 1);
      final Sprint sprint = sprints.first;

      expect(sprint.maxSpeed, 5.8);
      expect(sprint.totalTime, const Duration(seconds: 4));
      expect(sprint.totalDistance, 50);
    });

    test('should handle multiple sprints', () async {
      final SprintCalculator calculator = SprintCalculator(minVelocityThreshold: 3);
      final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(timestamp: 1000, velocity: 2.5, distance: 0),
        gpsData(timestamp: 2000, velocity: 3.2, distance: 5),
        gpsData(timestamp: 3000, velocity: 3.5, distance: 10),
        gpsData(timestamp: 4000, velocity: 3.8, distance: 15),
        gpsData(timestamp: 5000, velocity: 2.5, distance: 20),
        gpsData(timestamp: 6000, velocity: 2.8, distance: 5),
        gpsData(timestamp: 7000, velocity: 3.9, distance: 10),
        gpsData(timestamp: 8000, velocity: 4.2, distance: 15),
        gpsData(timestamp: 9000, velocity: 2.7, distance: 20),
      ]).transform(AddDistanceToStreamUsingTrapezoidProcessor());

      final List<Sprint> sprints = await calculator.calculate(gpsDataStream).toList();

      expect(sprints.length, 2);
    });

    test('should reset internal state between sprints', () async {
      final SprintCalculator calculator = SprintCalculator(minVelocityThreshold: 3);
      final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(timestamp: 1000, velocity: 2.5, distance: 0),
        gpsData(timestamp: 2000, velocity: 3.2, distance: 5),
        gpsData(timestamp: 3000, velocity: 3.5, distance: 10),
        gpsData(timestamp: 4000, velocity: 3.8, distance: 15),
        gpsData(timestamp: 5000, velocity: 2.5, distance: 20),
        gpsData(timestamp: 6000, velocity: 3.5, distance: 5),
        gpsData(timestamp: 7000, velocity: 3.9, distance: 10),
        gpsData(timestamp: 8000, velocity: 4.2, distance: 15),
        gpsData(timestamp: 9000, velocity: 2.7, distance: 20),
      ]);

      final List<Sprint> result = await calculator.calculate(gpsDataStream).toList();
      expect(result.first.maxSpeed, 4.2);
    });
  });
}
