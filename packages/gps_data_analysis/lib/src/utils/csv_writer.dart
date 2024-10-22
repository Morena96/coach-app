import 'dart:io';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/models/gps_data_one_hz.dart';

/// Writes Stream of GPSData into CSV
class CsvWriter {
  late File _file;

  CsvWriter({required String filePath}) {
    _file = File(filePath);
  }

  Future<void> writeCsv<T>(Stream<T> gpsDataStream) async {
    final IOSink sink = _file.openWrite();

    // Write the header
    sink.writeln(_header);

    if (T == GpsDataOneHz) {
      await for (final T gpsData in gpsDataStream) {
        final List<String> csvRow =
            _oneHzGpsDataToCsvRow(gpsData as GpsDataOneHz);
        sink.writeln(csvRow.join(';'));
      }
    } else if (T == GpsData) {
      final List<GpsData> batch = <GpsData>[];
      await for (final T gpsData in gpsDataStream) {
        batch.add(gpsData as GpsData);
        if (batch.length == 10) {
          final List<String> csvRow = _gpsDataToCsvRow(batch);
          sink.writeln(csvRow.join(';'));
          batch.clear();
        }
      }
    }

    await sink.flush();
    await sink.close();
  }

  String get _header =>
      '"time_trame";"num_sv";"hdop";"error_gps";"bpm";"error_cardio";"is_in_charge"'
      ';${List<String>.generate(10, (int i) => '"latitude_${i + 1}"').join(';')}'
      ';${List<String>.generate(10, (int i) => '"longitude_${i + 1}"').join(';')}'
      ';${List<String>.generate(10, (int i) => '"speed_${i + 1}"').join(';')}'
      ';${List<String>.generate(80, (int i) => '"acc_x_${i + 1}";"acc_y_${i + 1}";"acc_z_${i + 1}"').join(';')}';

  List<String> _gpsDataToCsvRow(List<GpsData> dataBatch) {
    final List<String> speeds =
        dataBatch.map((GpsData data) => data.velocity.toStringAsFixed(3)).toList();
    final List<String> latitudes =
        dataBatch.map((GpsData data) => data.latitude.toString()).toList();
    final List<String> longitudes =
        dataBatch.map((GpsData data) => data.longitude.toString()).toList();

    final List<double> accX =
        dataBatch.expand((GpsData data) => data.accelerationX).toList();
    final List<double> accY =
        dataBatch.expand((GpsData data) => data.accelerationY).toList();
    final List<double> accZ =
        dataBatch.expand((GpsData data) => data.accelerationZ).toList();

    return <String>[
      dataBatch[0].timestamp.toString(),
      dataBatch[0].numberOfSatellites.toString(),
      dataBatch[0].hdop.toString(),
      dataBatch[0].errorGps.toString(),
      dataBatch[0].heartRate.toString(),
      dataBatch[0].errorCardio.toString(),
      dataBatch[0].isInCharge.toString(),
      ...latitudes,
      ...longitudes,
      ...speeds,
      for (int i = 0; i < accX.length; i++) ...<String>[
        accX[i].toString(),
        accY[i].toString(),
        accZ[i].toString()
      ],
    ];
  }

  List<String> _oneHzGpsDataToCsvRow(GpsDataOneHz data) {
    final List<String> speeds =
        data.speeds.map((double value) => value.toString()).toList();
    final List<String> latitudes =
        data.latitudes.map((double value) => value.toString()).toList();
    final List<String> longitudes =
        data.longitudes.map((double value) => value.toString()).toList();
    final List<String> accX =
        data.accelerationX.map((double value) => value.toString()).toList();
    final List<String> accY =
        data.accelerationY.map((double value) => value.toString()).toList();
    final List<String> accZ =
        data.accelerationZ.map((double value) => value.toString()).toList();

    return <String>[
      data.timestamp.toString(),
      data.numberOfSatellites.toString(),
      data.hdop.toString(),
      data.errorGps.toString(),
      data.heartRate.toString(),
      data.errorCardio.toString(),
      data.isCharging.toString(),
      ...latitudes,
      ...longitudes,
      ...speeds,
      for (int i = 0; i < accX.length; i++) ...<String>[
        accX[i],
        accY[i],
        accZ[i]
      ],
    ];
  }
}
