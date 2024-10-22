import 'package:gps_data_analysis/gps_data_analysis.dart';

import '../test/factories/gps_data_factory.dart';

void main() {
  // list of GpsData
  final List<GpsData> data = [gpsData(timestamp: 1619999999, velocity: 10)];

  // stream of GpsData
  final Stream<GpsData> stream = Stream<GpsData>.fromIterable(data);

  final Stream<GpsData> transformedStream = stream.transform(
      FilterInvalidTimestampsFromLiveDataProcessor(1610000000, 161010000));

  stream.listen(print);

  transformedStream.listen(print);
}
