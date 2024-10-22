import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/signal/add_signal_quality_indicator.dart';

import 'factories/gps_data_factory.dart';

void main() {
  group('AddSignalQualityToStream Tests', () {
    test('Transformer adds HIGH quality signal correctly', () {
      final AddSignalQualityToStream transformer = AddSignalQualityToStream();
      final Stream<GpsData> input = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(latitude: 1, hdop: 1, numberOfSatellites: 12),
      ]);
      expectLater(
          transformer.bind(input),
          emitsInOrder(<dynamic>[
            predicate((GpsData data) => data.signalQuality == 'HIGH'),
            emitsDone,
          ]));
    });

    test('Transformer adds MEDIUM quality signal correctly', () {
      final AddSignalQualityToStream transformer = AddSignalQualityToStream();
      final Stream<GpsData> input = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(hdop: 3.5, numberOfSatellites: 5),
      ]);
      expectLater(
          transformer.bind(input),
          emitsInOrder(<dynamic>[
            predicate((GpsData data) => data.signalQuality == 'MEDIUM'),
            emitsDone,
          ]));
    });

    test('Transformer handles errors when HDOP or satellites are null', () {
      final AddSignalQualityToStream transformer = AddSignalQualityToStream();
      final Stream<GpsData> input = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(numberOfSatellites: 5), // Error case
      ]);
      expectLater(
          transformer.bind(input),
          emitsInOrder(<dynamic>[
            emitsError(isA<String>()),
            emitsDone,
          ]));
    });

    test('Transformer propagates errors from upstream', () {
      final AddSignalQualityToStream transformer = AddSignalQualityToStream();
      final Stream<GpsData> input = Stream<GpsData>.error('Upstream error');
      expectLater(
          transformer.bind(input),
          emitsInOrder(<dynamic>[
            emitsError(isA<String>()),
            emitsDone,
          ]));
    });

    test('Test all quality determination logic', () {
      expect(AddSignalQualityToStream.determineQuality(1, 15), 'HIGH');
      expect(AddSignalQualityToStream.determineQuality(2, 10), 'HIGH');
      expect(AddSignalQualityToStream.determineQuality(3.9, 5), 'MEDIUM');
      expect(AddSignalQualityToStream.determineQuality(4.5, 4), 'MEDIUM');
      expect(AddSignalQualityToStream.determineQuality(6, 3), 'LOW');
    });
  });
}
