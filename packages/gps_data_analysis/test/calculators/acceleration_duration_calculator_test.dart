import 'package:gps_data_analysis/src/calculators/session_duration_calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:test/test.dart';

import '../factories/gps_data_factory.dart';

void main() {
  test('Duration calculated correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(
      List<GpsData>.generate(
        30,
        (int index) => gpsData(timestamp: 100 * index),
      ),
    );

    final SessionDurationCalculator calculator = SessionDurationCalculator();
    final List<int> result = await calculator.calculate(gpsDataStream).toList();

    expect(result.last, 2);
  });

  test('Empty stream returns nothing', () async {
    const Stream<GpsData> gpsDataStream = Stream<GpsData>.empty();

    final SessionDurationCalculator calculator = SessionDurationCalculator();
    final List<int> result = await calculator.calculate(gpsDataStream).toList();

    expect(result, isEmpty);
  });

  test('Single data point returns 0 duration', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(timestamp: 100),
    ]);

    final SessionDurationCalculator calculator = SessionDurationCalculator();
    final List<int> result = await calculator.calculate(gpsDataStream).toList();

    expect(result, <int>[0]);
  });
}
