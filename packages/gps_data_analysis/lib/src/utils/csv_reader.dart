import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

/// Field groups for GPSData. Options for `fields` field on `CSVReader1`
enum GPSDataFields { coordinates, velocity, accelerations, signal, cardio }

/// Column names from CSV file
class CsvColumn {
  static const String timeFrame = 'time_trame';
  static const String speed = 'speed_1';
  static const String latitude = 'latitude_1';
  static const String longitude = 'longitude_1';
  static const String acceleration = 'acc_x_1';
  static const String numberOfSatellites = 'num_sv';
  static const String hdop = 'hdop';
  static const String errorGps = 'error_gps';
  static const String bpm = 'bpm';
  static const String errorCardio = 'error_cardio';
  static const String isInCharge = 'is_in_charge';
}

/// Reads CSV data from GPS device line by line and emits `GPSData` objects
/// CSV file contains columns `time_trame` (timestamp), `speed_1` through `speed_10` (10Hz),
/// and `acc_x1` through `acc_x80`.  via a stream at a 10Hz frequency. The GpsData class should contain:
/// 1 row represents 10 velocity values and 80 acceleration values. Emits a new value every 1 velocity
/// and 8 acceleration values to emit at 10hz.
class CsvReader {
  final List<GPSDataFields> fields;
  late int _accelerationStartIndex;
  late File _file;
  final bool _addCoordinates;
  final bool _addVelocity;
  final bool _addAccelerations;
  final bool _addSignals;
  final bool _addCardio;

  CsvReader({
    required String filePath,
    this.fields = const <GPSDataFields>[],
  })  : _addCoordinates = fields.contains(GPSDataFields.coordinates) || fields.isEmpty,
        _addVelocity = fields.contains(GPSDataFields.velocity) || fields.isEmpty,
        _addAccelerations = fields.contains(GPSDataFields.accelerations) || fields.isEmpty,
        _addSignals = fields.contains(GPSDataFields.signal) || fields.isEmpty,
        _addCardio = fields.contains(GPSDataFields.cardio) || fields.isEmpty {
    _file = File(filePath);
  }

  /// Reads from file and returns as a stream of GPSData
  Stream<GpsData> readAsGPSData() async* {
    final Stream<List<int>> input = _file.openRead();
    final List<List<dynamic>> rows = await input.transform(utf8.decoder).transform(const CsvToListConverter(eol: '\n', fieldDelimiter: ';')).toList();

    // Assuming the first row is the header
    final List<dynamic> header = rows.removeAt(0);

    final int timestampsIndex = header.indexOf(CsvColumn.timeFrame);
    final int velocityStartIndex = header.indexOf(CsvColumn.speed);
    final int latitudeStartIndex = header.indexOf(CsvColumn.latitude);
    final int longitudeStartIndex = header.indexOf(CsvColumn.longitude);
    final int hdopIndex = header.indexOf(CsvColumn.hdop);
    final int numberOfSatellitesIndex = header.indexOf(CsvColumn.numberOfSatellites);
    final int errorCardioIndex = header.indexOf(CsvColumn.errorCardio);
    final int errorGpsIndex = header.indexOf(CsvColumn.errorGps);
    final int bpmIndex = header.indexOf(CsvColumn.bpm);
    final int isInChargeIndex = header.indexOf(CsvColumn.isInCharge);

    _accelerationStartIndex = header.indexOf(CsvColumn.acceleration);

    // Process each row and emit at 10Hz. Each row contains 10 sets of velocity, latitude, and longitude
    for (final List<dynamic> row in rows) {
      final int timestamp = _int(row[timestampsIndex]);

      final List<dynamic> velocityValues = _addVelocity ? row.sublist(velocityStartIndex, velocityStartIndex + 10).toList() : const <dynamic>[];
      final List<dynamic> latitudeValues = _addCoordinates ? row.sublist(latitudeStartIndex, latitudeStartIndex + 10).toList() : const <dynamic>[];
      final List<dynamic> longitudeValues = _addCoordinates ? row.sublist(longitudeStartIndex, longitudeStartIndex + 10).toList() : const <dynamic>[];

      // Loop through lists and emit GPSData
      for (int part = 0; part < 10; part++) {
        yield GpsData(
          timestamp: timestamp + part * 100,
          velocity: _addVelocity ? _double(velocityValues[part], 0)! : 0,
          latitude: _addCoordinates ? _double(latitudeValues[part], 0)! : 0,
          longitude: _addCoordinates ? _double(longitudeValues[part], 0)! : 0,
          accelerationX: _addAccelerations ? _acceleration(row, 'x', part) : <double>[],
          accelerationY: _addAccelerations ? _acceleration(row, 'y', part) : <double>[],
          accelerationZ: _addAccelerations ? _acceleration(row, 'z', part) : <double>[],
          hdop: _addSignals ? _double(row[hdopIndex]) : null,
          numberOfSatellites: _addSignals ? _int(row[numberOfSatellitesIndex]) : null,
          errorGps: _addSignals ? _int(row[errorGpsIndex]) : null,
          heartRate: _addCardio ? _double(row[bpmIndex]) : null,
          errorCardio: _addCardio ? _int(row[errorCardioIndex]) : null,
          isInCharge: _bool(row[isInChargeIndex]),
        );
      }
    }
  }

  /// Creates a comma-separated csv file and fills with data from original file
  Future<void> writeAs10HzCsv(String exportFilePath) async {
    final File exportFile = File(exportFilePath);
    final IOSink sink = exportFile.openWrite();

    // Write header
    sink.write('timestamp,velocity,latitude,longitude,accelerationX,accelerationY,accelerationZ,hdop,numberOfSatellites\n');

    await readAsGPSData().forEach((GpsData gpsData) {
      sink.write('${gpsData.timestamp},${gpsData.velocity},${gpsData.latitude},${gpsData.longitude},'
          '${gpsData.accelerationX.join('|')},${gpsData.accelerationY.join('|')},${gpsData.accelerationZ.join('|')},'
          '${gpsData.hdop},${gpsData.numberOfSatellites}\n');
    });

    await sink.flush();
    await sink.close();
  }

  final Map<String, int> _axisInitialOffset = <String, int>{'x': 0, 'y': 1, 'z': 2};

  /// Get list of acceleration.
  List<double> _acceleration(List<dynamic> row, String axis, int part) {
    final List<double> acc = <double>[];
    // Calculate column to start getting data. Then loop through by step 3 and add to list
    int i = _accelerationStartIndex + (_axisInitialOffset[axis] ?? 0) + part * 8 * 3;
    while (acc.length < 8) {
      acc.add(_double(row[i]) ?? 0);
      i += 3;
    }
    return acc;
  }

  /// Handles data which can be String or double
  double? _double(dynamic value, [double? defaultValue]) {
    if (value is String) return double.tryParse(value) ?? 0;
    if (value is num) return value.toDouble();
    return defaultValue;
  }

  /// Handles data which can be String or int
  int _int(dynamic value) {
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }

  /// Handles data which can be String or bool
  bool _bool(dynamic value) {
    if (value is String) return value.toLowerCase() == 'true';
    if (value is bool) return value;
    return false;
  }
}
