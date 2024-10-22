import 'dart:async';

import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/velocity/low_speed_value_processor.dart';

import '../factories/gps_data_factory.dart';

void main() {
  group('LowSpeedValueProcessor', () {
    test('converts speeds less than speedThreshold to 0', () async {
      final LowSpeedValueProcessor processor = LowSpeedValueProcessor(4);

      final Stream<GpsData> inputStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(velocity: 3),
        gpsData(velocity: 7),
        gpsData(velocity: 5),
      ]);
      final Stream<GpsData> processedStream = inputStream.transform(processor);

      final List<GpsData> results = await processedStream.toList();

      expect(results[0].velocity, 0); // velocity should be converted to 0
      expect(results[1].velocity, 7.0); // velocity should remain unchanged
      expect(results[2].velocity, 5.0); // velocity should remain unchanged
    });

    test('does not modify speeds equal to or greater than speedThreshold', () async {
      final LowSpeedValueProcessor processor = LowSpeedValueProcessor(5);

      final Stream<GpsData> inputStream = Stream<GpsData>.fromIterable(<GpsData>[gpsData(velocity: 5)]);
      final Stream<GpsData> processedStream = inputStream.transform(processor);

      final List<GpsData> results = await processedStream.toList();

      expect(results[0].velocity, 5.0); // velocity should remain unchanged
    });

    test('handles empty stream', () async {
      final LowSpeedValueProcessor processor = LowSpeedValueProcessor(5);

      const Stream<GpsData> inputStream = Stream<GpsData>.empty();
      final Stream<GpsData> processedStream = inputStream.transform(processor);

      final List<GpsData> results = await processedStream.toList();

      expect(results, isEmpty);
    });
  });
}
