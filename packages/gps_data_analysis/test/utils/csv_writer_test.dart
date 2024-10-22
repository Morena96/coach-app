import 'dart:io';

import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/utils/csv_reader.dart';
import 'package:gps_data_analysis/src/utils/csv_writer.dart';

import '../csv_reader_test.dart';

void main() {
  test('reads, writes and reads correctly', () async {
    final CsvReader readerOriginal = CsvReader(filePath: 'csv/2seconds.csv');
    final CsvWriter writer = CsvWriter(filePath: '2seconds_test.csv');
    await writer.writeCsv(readerOriginal.readAsGPSData());

    final CsvReader readerTest = CsvReader(filePath: '2seconds_test.csv');
    final List<GpsData> data = await readerTest.readAsGPSData().toList();

    testSampleFile(data);

    final File file = File('2seconds_test.csv');
    addTearDown(() async {
      if (await file.exists()) await file.delete();
    });
  });
}
