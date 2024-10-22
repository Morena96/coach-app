import 'package:rxdart/rxdart.dart';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

/// Calculates the session duration by finding the difference between the earliest and latest timestamps in the Stream<GpsData>
class SessionDurationCalculator extends Calculator<int> {
  static const String name = 'SessionDurationCalculator';

  @override
  Stream<int> calculate(Stream<GpsData> gpsDataStream) {
    return gpsDataStream
        .map((GpsData data) => data.timestamp ~/ 1000)
        .scan<(int, int)?>(
          ((int, int)? accumulator, int value, _) => accumulator == null
              ? (value, value)
              : (
                  accumulator.$1 < value ? accumulator.$1 : value,
                  accumulator.$2 > value ? accumulator.$2 : value,
                ),
          null,
        )
        .map(((int, int)? range) => range == null ? 0 : range.$2 - range.$1);
  }
}
