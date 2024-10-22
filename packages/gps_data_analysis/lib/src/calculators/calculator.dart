import 'package:gps_data_analysis/src/models/gps_data.dart';

abstract class Calculator<T> {
  Stream<T> calculate(Stream<GpsData> gpsDataStream);
}
