import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/distance/add_distance_to_stream_processor_using_trapezoid.dart';

void main() {
  test('Normal data flow calculates distance correctly', () async {
    // Setup: Stream of GPSData and processor
    final DateTime now = DateTime.now();
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      GpsData(timestamp: now.millisecondsSinceEpoch, latitude: 0, longitude: 0, velocity: 10),
      GpsData(timestamp: now.millisecondsSinceEpoch + 100, latitude: 0, longitude: 0, velocity: 15),
    ]);
    final AddDistanceToStreamUsingTrapezoidProcessor processor = AddDistanceToStreamUsingTrapezoidProcessor();

    // Action: Process the stream
    final Future<List<GpsData>> processedStream = gpsDataStream.transform(processor).toList();

    // Assertion: Expected accumulated distance (example values)
    final List<double> expectedDistance = <double>[1.25];
    final List<GpsData> results = await processedStream;

    expect(results.map((GpsData data) => data.distance), equals(expectedDistance));
    // expect only one element in the list
    expect(results.length, equals(1));
  });

  test('Data with large timestamp difference assumes maximum time difference', () async {
    // Setup: Stream of GPSData and processor
    final DateTime now = DateTime.now();
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      GpsData(timestamp: now.millisecondsSinceEpoch, latitude: 0, longitude: 0, velocity: 10),
      GpsData(timestamp: now.millisecondsSinceEpoch + 2000, latitude: 0, longitude: 0, velocity: 15),
    ]);
    final AddDistanceToStreamUsingTrapezoidProcessor processor = AddDistanceToStreamUsingTrapezoidProcessor();

    // Action: Process the stream
    final Future<List<GpsData>> processedStream = gpsDataStream.transform(processor).toList();

    // Assertion: Expected accumulated distance (example values)
    final List<double> expectedDistance = <double>[12.5];
    final List<GpsData> results = await processedStream;

    expect(results.map((GpsData data) => data.distance), equals(expectedDistance));
    // expect only one element in the list
    expect(results.length, equals(1));
  });

  test('Data with negative velocity is handled correctly', () async {
    // Setup: Stream of GPSData and processor
    final DateTime now = DateTime.now();
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      GpsData(timestamp: now.millisecondsSinceEpoch, latitude: 0, longitude: 0, velocity: -10),
      GpsData(timestamp: now.millisecondsSinceEpoch + 100, latitude: 0, longitude: 0, velocity: -15),
    ]);
    final AddDistanceToStreamUsingTrapezoidProcessor processor = AddDistanceToStreamUsingTrapezoidProcessor();

    // Action: Process the stream
    final Future<List<GpsData>> processedStream = gpsDataStream.transform(processor).toList();

    // Assertion: Expected accumulated distance (example values)
    final List<double> expectedDistance = <double>[1.25];
    final List<GpsData> results = await processedStream;

    expect(results.map((GpsData data) => data.distance), equals(expectedDistance));
    // expect only one element in the list
    expect(results.length, equals(1));
  });

  test('Can calculate accumulated distance', () async {
    // Setup: Stream of GPSData and processor
    final DateTime now = DateTime.now();
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      GpsData(timestamp: now.millisecondsSinceEpoch, latitude: 0, longitude: 0, velocity: 10),
      GpsData(timestamp: now.millisecondsSinceEpoch + 100, latitude: 0, longitude: 0, velocity: 15),
    ]);
    final AddDistanceToStreamUsingTrapezoidProcessor processor = AddDistanceToStreamUsingTrapezoidProcessor();

    // Action: Process the stream
    final Future<List<GpsData>> processedStream = gpsDataStream.transform(processor).toList();

    // Assertion: Expected accumulated distance (example values)
    final List<double> expectedAccumulatedDistance = <double>[1.25];
    final List<GpsData> results = await processedStream;

    expect(results.map((GpsData data) => data.accumulatedDistance), equals(expectedAccumulatedDistance));
    // expect only one element in the list
    expect(results.length, equals(1));
  });
}
