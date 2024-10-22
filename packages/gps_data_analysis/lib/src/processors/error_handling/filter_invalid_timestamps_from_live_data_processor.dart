import 'dart:async';
import 'dart:developer';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/processor_mixin.dart';

/// Filters out GpsData points with timestamps below the startTime value
class FilterInvalidTimestampsFromLiveDataProcessor
    with ProcessorMixin<GpsData>
    implements StreamTransformer<GpsData, GpsData> {
  static const String name = 'FilterInvalidTimestampsFromLiveDataProcessor';
  final int startTime;
  final int endTime;

  FilterInvalidTimestampsFromLiveDataProcessor(this.startTime, this.endTime);

  @override
  Stream<GpsData> bind(Stream<GpsData> stream) {
    return binder(
      stream: stream,
      onData: (GpsData data) {
        // Only add data if the timestamp is greater than or equal to startTime
        log('Start time: $startTime, End time: $endTime');
        log('Filtering out data with timestamp ${data.timestamp}');
        if (data.timestamp >= startTime && data.timestamp < endTime) {
          controller!.add(data);
        }
      },
    );
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    return StreamTransformer.castFrom(this);
  }
}
