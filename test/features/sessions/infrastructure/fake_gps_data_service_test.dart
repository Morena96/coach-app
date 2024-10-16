import 'package:flutter_test/flutter_test.dart';
import 'package:gps_data_analysis/gps_data_analysis.dart';
import 'package:coach_app/features/sessions/infrastructure/data/fake_gps_data_service.dart';

void main() {
  group('FakeGpsDataService', () {
    late FakeGpsDataService fakeGpsDataService;

    setUp(() {
      fakeGpsDataService = FakeGpsDataService();
    });

    test('initial state', () {
      expect(fakeGpsDataService.gpsDataStream, isA<Stream<GpsData>>());
    });

    test('stopGeneratingData stops the stream', () async {
      fakeGpsDataService.startGeneratingData();

      // Wait for the first data to be emitted to confirm the stream started
      await expectLater(
        fakeGpsDataService.gpsDataStream,
        emits(isA<GpsData>()),
      );

      // Stop generating data
      fakeGpsDataService.stopGeneratingData();

      // After stopping, the stream should be closed
      expect(fakeGpsDataService.isGeneratingData(), isFalse);
    });

    test('startGeneratingData generates data', () async {
      fakeGpsDataService.startGeneratingData();

      await expectLater(
        fakeGpsDataService.gpsDataStream,
        emitsThrough(isA<GpsData>()),
      );

      fakeGpsDataService.stopGeneratingData();
    });

    test('generated GpsData has valid properties', () async {
      fakeGpsDataService.startGeneratingData();

      final gpsData = await fakeGpsDataService.gpsDataStream.first;

      expect(gpsData.velocity, isA<double>());
      expect(gpsData.accelerationX.length, equals(8));
      expect(gpsData.accelerationY.length, equals(8));
      expect(gpsData.accelerationZ.length, equals(8));
      expect(gpsData.timestamp, isA<int>());
      expect(gpsData.latitude, inInclusiveRange(-90, 90));
      expect(gpsData.longitude, inInclusiveRange(-180, 180));

      fakeGpsDataService.stopGeneratingData();
    });

    test('velocity changes over time', () async {
      fakeGpsDataService.startGeneratingData();

      final firstData = await fakeGpsDataService.gpsDataStream.first;
      await Future.delayed(const Duration(seconds: 2));
      final laterData = await fakeGpsDataService.gpsDataStream.first;

      expect(firstData.velocity, isNot(equals(laterData.velocity)));

      fakeGpsDataService.stopGeneratingData();
    });

    test('position changes over time', () async {
      fakeGpsDataService.startGeneratingData();

      final firstData = await fakeGpsDataService.gpsDataStream.first;
      await Future.delayed(const Duration(seconds: 2));
      final laterData = await fakeGpsDataService.gpsDataStream.first;

      expect(firstData.latitude, isNot(equals(laterData.latitude)));
      expect(firstData.longitude, isNot(equals(laterData.longitude)));

      fakeGpsDataService.stopGeneratingData();
    });

    group('generateDataForTimeRange', () {
      test('generates correct number of data points', () {
        final start = DateTime.now();
        final end = start.add(const Duration(seconds: 5));
        final dataList = fakeGpsDataService.generateDataForTimeRange(start, end);

        // Expected number of data points: 5 seconds * 10 Hz = 50
        expect(dataList.length, equals(50));
      });

      test('generated data has correct timestamps', () {
        final start = DateTime.now();
        final end = start.add(const Duration(seconds: 2));
        final dataList = fakeGpsDataService.generateDataForTimeRange(start, end);

        expect(dataList.first.timestamp, equals(start.millisecondsSinceEpoch));
        expect(dataList.last.timestamp, equals(end.millisecondsSinceEpoch - 100)); // Last point is 100ms before end
      });

      test('generated data has changing velocity and position', () {
        final start = DateTime.now();
        final end = start.add(const Duration(seconds: 5));
        final dataList = fakeGpsDataService.generateDataForTimeRange(start, end);

        expect(dataList.map((d) => d.velocity).toSet().length, greaterThan(1));
        expect(dataList.map((d) => d.latitude).toSet().length, greaterThan(1));
        expect(dataList.map((d) => d.longitude).toSet().length, greaterThan(1));
      });
    });
  });
}
