import 'dart:async';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/error_handling/filter_invalid_timestamps_from_live_data_processor.dart';
import 'package:test/test.dart';

import '../factories/gps_data_factory.dart';

void main() {
  group('FilterInvalidTimestampsFromLiveDataProcessor', () {
    late FilterInvalidTimestampsFromLiveDataProcessor processor;

    setUp(() {
      // Initialize the processor with a startTime
      processor =
          FilterInvalidTimestampsFromLiveDataProcessor(1620000000, 1620099999);
    });

    test('should filter out GpsData with timestamps below startTime', () async {
      final StreamController<GpsData> streamController =
          StreamController<GpsData>();
      final Stream<GpsData> gpsDataStream =
          streamController.stream.transform(processor);
      final List<GpsData> gpsDataPoints = <GpsData>[
        gpsData(timestamp: 1619999999, velocity: 10),
        gpsData(timestamp: 1620000001, velocity: 15),
        gpsData(timestamp: 1619999998, velocity: 20),
        gpsData(timestamp: 1620000002, velocity: 25),
        gpsData(timestamp: 1620099998, velocity: 23),
      ];

      final List<GpsData> expectedDataPoints = <GpsData>[
        gpsData(timestamp: 1620000001, velocity: 15),
        gpsData(timestamp: 1620000002, velocity: 25),
        gpsData(timestamp: 1620099998, velocity: 23),
      ];

      final List<GpsData> actualDataPoints = <GpsData>[];

      gpsDataStream.listen(actualDataPoints.add);

      // Add data to the stream
      for (final GpsData dataPoint in gpsDataPoints) {
        streamController.add(dataPoint);
      }

      // Close the stream
      await streamController.close();

      // Allow some time for the stream to process
      await Future<void>.delayed(Duration.zero);

      // Verify the filtered data points timestamps are the same
      expect(
        actualDataPoints.map((GpsData data) => data.timestamp),
        expectedDataPoints.map((GpsData data) => data.timestamp),
      );
    });

    test('should pass through GpsData with timestamps equal to startTime',
        () async {
      final StreamController<GpsData> streamController =
          StreamController<GpsData>();
      final Stream<GpsData> gpsDataStream =
          streamController.stream.transform(processor);
      final List<GpsData> gpsDataPoints = <GpsData>[
        gpsData(timestamp: 1620000000, velocity: 10),
        gpsData(timestamp: 1620000001, velocity: 15),
      ];

      final List<GpsData> expectedDataPoints = <GpsData>[
        gpsData(timestamp: 1620000000, velocity: 10),
        gpsData(timestamp: 1620000001, velocity: 15),
      ];

      final List<GpsData> actualDataPoints = <GpsData>[];

      gpsDataStream.listen(actualDataPoints.add);

      // Add data to the stream
      for (final GpsData dataPoint in gpsDataPoints) {
        streamController.add(dataPoint);
      }

      // Close the stream
      await streamController.close();

      // Allow some time for the stream to process
      await Future<void>.delayed(Duration.zero);

      // Verify the filtered data points timestamps are the same
      expect(
        actualDataPoints.map((GpsData data) => data.timestamp),
        expectedDataPoints.map((GpsData data) => data.timestamp),
      );
    });

    test('should handle empty stream correctly', () async {
      final StreamController<GpsData> streamController =
          StreamController<GpsData>();
      final Stream<GpsData> gpsDataStream =
          streamController.stream.transform(processor);

      final List<GpsData> actualDataPoints = <GpsData>[];

      gpsDataStream.listen(actualDataPoints.add);

      // Close the stream
      await streamController.close();

      // Allow some time for the stream to process
      await Future<void>.delayed(Duration.zero);

      // Verify the filtered data points timestamps are the same
      expect(actualDataPoints, isEmpty);
    });
  });
}
