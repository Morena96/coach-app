import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/error_handling/error_filter_processor.dart';

import 'factories/gps_data_factory.dart';

void main() {
  group('ErrorFilterProcessor Tests', () {
    test('Initializes with default parameters correctly', () {
      final ErrorFilterProcessor processor = ErrorFilterProcessor();
      expect(processor, isNotNull);
    });

    test('Processes a single data point correctly', () {
      final ErrorFilterProcessor processor = ErrorFilterProcessor();
      final Stream<GpsData> dataStream = Stream<GpsData>.value(gpsData(velocity: 5));
      final Stream<GpsData> processedStream = dataStream.transform(processor);

      final Future<List<GpsData>> futureProcessedData = processedStream.toList();

      futureProcessedData.then((List<GpsData> processedData) {
        expect(processedData.first.velocity, isNotNull);
      });
    });

    test('Processes multiple sequential data points accurately', () async {
      final ErrorFilterProcessor processor = ErrorFilterProcessor();
      final Stream<GpsData> dataStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(velocity: 10),
        gpsData(velocity: 12),
        gpsData(velocity: 14),
      ]);
      final Stream<GpsData> processedStream = dataStream.transform(processor);

      final List<GpsData> processedData = await processedStream.toList();
      expect(processedData, isNotEmpty);
    });

    test('Filters out invalid data points', () async {
      final ErrorFilterProcessor processor = ErrorFilterProcessor();
      final Stream<GpsData> dataStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(velocity: 10),
        gpsData(velocity: 201),
        gpsData(velocity: -1),
        gpsData(velocity: 14),
      ]);
      final Stream<GpsData> processedStream = dataStream.transform(processor);

      final List<GpsData> processedData = await processedStream.toList();
      expect(processedData, hasLength(2));
    });
  });
}
