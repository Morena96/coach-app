import 'package:collection/collection.dart';
import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/acceleration/median_filter_processor.dart';

import 'factories/gps_data_factory.dart';

void main() {
  test('Median filters calculated correctly', () async {
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: <double>[2, 3, 80, 6, 2, 3],
        accelerationY: <double>[5, 3.1, 4, 61, 0, 3],
        accelerationZ: <double>[70, 13, 8, 16, 14, 13],
      ),
    ]);

    final MedianFilterProcessor medianFilter = MedianFilterProcessor(windowSize: 3);
    final List<GpsData> result = await gpsDataStream.transform(medianFilter).toList();

    final List<double> expectedX = <double>[2, 3, 6, 6, 3, 2];
    final List<double> expectedY = <double>[3.1, 4, 4, 4, 3, 0];
    final List<double> expectedZ = <double>[13, 13, 13, 14, 14, 13];

    expect(const ListEquality<double>().equals(result.first.accelerationX, expectedX), true);
    expect(const ListEquality<double>().equals(result.first.accelerationY, expectedY), true);
    expect(const ListEquality<double>().equals(result.first.accelerationZ, expectedZ), true);
  });

  // test('Performance test', () async {
  //   final gpsDataStream = Stream.fromIterable(
  //     List.generate(
  //       10000,
  //       (index) => gpsData(
  //         accelerationX:
  //             List.generate(80, (index) => Random().nextDouble() * 100),
  //         accelerationY:
  //             List.generate(80, (index) => Random().nextDouble() * 100),
  //         accelerationZ:
  //             List.generate(80, (index) => Random().nextDouble() * 100),
  //       ),
  //     ),
  //   );

  //   Stopwatch stopwatch = Stopwatch()..start();
  //   final medianFilter = MedianFilterProcessor(windowSize: 3);
  //   await gpsDataStream.transform(medianFilter).toList();
  //   print(stopwatch.elapsed);
  // });

  test('Median filters calculated correctly', () async {
    final List<double> list = <double>[29, 33, 46, 74, 29, 19, 82, 25, 17, 90, 69];
    final List<double> expected = <double>[29, 33, 33, 33, 46, 29, 25, 25, 69, 25, 17];
    final Stream<GpsData> gpsDataStream = Stream<GpsData>.fromIterable(<GpsData>[
      gpsData(
        accelerationX: list,
        accelerationY: list,
        accelerationZ: list,
      ),
    ]);

    final MedianFilterProcessor medianFilter = MedianFilterProcessor();
    final List<GpsData> result = await gpsDataStream.transform(medianFilter).toList();

    expect(const ListEquality<double>().equals(result.first.accelerationX, expected), true);
  });
}
