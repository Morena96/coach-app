import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/utils/csv_reader.dart';

void testSampleFile(List<GpsData> data) {
  expect(data.length, 20);
  expect((data.last.timestamp - data.first.timestamp) / 1000, 1.9);
  expect(data[5].velocity, closeTo(0.64, 0.02));
  expect(data[18].velocity, closeTo(0.72, 0.01));
  expect(data[5].longitude, -81.7543129);
  expect(data[18].longitude, -81.7543172);
  expect(data[5].latitude, 26.2196146);
  expect(data[18].latitude, 26.2196327);
  expect(data[1].accelerationX[1], -6.933504);
  expect(data[1].accelerationY[1], -5.62176);
  expect(data[1].accelerationZ[1], -0.562176);
  expect(data.first.heartRate, 255);
  expect(data.first.errorCardio, 255);
  expect(data.first.hdop, 0.9);
  expect(data.first.numberOfSatellites, 23);
  expect(data.last.numberOfSatellites, 22);
  expect(data.last.numberOfSatellites, 22);
  expect(data.last.isInCharge, false);
  expect(data.first.errorGps, 153);
  expect(data.last.errorGps, 0);
  expect(data.every((GpsData d) => d.accelerationX.length == 8), true);
  expect(data.every((GpsData d) => d.accelerationY.length == 8), true);
  expect(data.every((GpsData d) => d.accelerationZ.length == 8), true);
}

void main() {
  test('reads predefined csv correctly', () async {
    final CsvReader reader = CsvReader(filePath: 'csv/2seconds.csv');
    final List<GpsData> data = await reader.readAsGPSData().toList();
    testSampleFile(data);
  });

  test('reads only coordinates', () async {
    final CsvReader reader = CsvReader(
        filePath: 'csv/2seconds.csv',
        fields: <GPSDataFields>[GPSDataFields.coordinates]);
    final List<GpsData> data = await reader.readAsGPSData().toList();

    expect(data.length, 20);
    expect((data.last.timestamp - data.first.timestamp) / 1000, 1.9);
    expect(data.every((GpsData d) => d.velocity == 0), true);
    expect(data[5].longitude, -81.7543129);
    expect(data[18].longitude, -81.7543172);
    expect(data[5].latitude, 26.2196146);
    expect(data[18].latitude, 26.2196327);
    expect(
        data.every((GpsData d) =>
            d.accelerationX.isEmpty &&
            d.accelerationY.isEmpty &&
            d.accelerationZ.isEmpty),
        true);
  });

  test('reads only accelerations and signal data', () async {
    final CsvReader reader = CsvReader(
        filePath: 'csv/2seconds.csv',
        fields: <GPSDataFields>[
          GPSDataFields.signal,
          GPSDataFields.accelerations
        ]);
    final List<GpsData> data = await reader.readAsGPSData().toList();

    expect(data.length, 20);
    expect((data.last.timestamp - data.first.timestamp) / 1000, 1.9);
    expect(data.every((GpsData e) => e.velocity == 0), true);
    expect(data.every((GpsData e) => e.latitude == 0), true);
    expect(data.every((GpsData e) => e.longitude == 0), true);
    expect(data[4].hdop, 0.9);
    expect(data[4].numberOfSatellites, 23);
    expect(data[1].accelerationX[1], -6.933504);
    expect(data[1].accelerationY[1], -5.62176);
    expect(data[1].accelerationZ[1], -0.562176);
    expect(data.every((GpsData d) => d.accelerationX.length == 8), true);
    expect(data.every((GpsData d) => d.accelerationY.length == 8), true);
    expect(data.every((GpsData d) => d.accelerationZ.length == 8), true);
  });

  test('reads data and exports', () async {
    const String exportPath = 'export.csv';
    final CsvReader reader = CsvReader(filePath: 'csv/2seconds.csv');
    await reader.writeAs10HzCsv(exportPath);

    // Act
    await reader.writeAs10HzCsv(exportPath);

    // Assert
    final File exportFile = File(exportPath);
    expect(await exportFile.exists(), isTrue);

    final Stream<List<int>> input = exportFile.openRead();
    final List<List<dynamic>> rows = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter(eol: '\n'))
        .toList();

    // Verify the header
    final List<String> expectedHeader = <String>[
      'timestamp',
      'velocity',
      'latitude',
      'longitude',
      'accelerationX',
      'accelerationY',
      'accelerationZ',
      'hdop',
      'numberOfSatellites'
    ];
    expect(rows.first, equals(expectedHeader));

    final List<Object> expectedData = <Object>[
      1707945302900,
      0.6972222222222223,
      26.219633299999998,
      -81.7543158,
      '-4.122624|-5.059584|-5.62176|-5.809152|-5.809152|-5.434368|-5.62176|-5.996544',
      '-3.560448|-4.310016|-4.872192|-5.62176|-5.62176|-5.059584|-4.872192|-4.872192',
      '0.0|0.0|-0.93696|-1.124352|-1.87392|-0.562176|-0.562176|-0.374784',
      0.9,
      22
    ];

    for (int i = 0; i < expectedData.length; i++) {
      expect(rows.last[i], equals(expectedData[i]));
    }

    addTearDown(() async {
      if (await exportFile.exists()) await exportFile.delete();
    });
  });
}
