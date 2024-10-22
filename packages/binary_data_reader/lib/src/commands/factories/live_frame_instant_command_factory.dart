import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/live_frame_command.dart';
import 'package:binary_data_reader/src/commands/models/live_frame_instant_command.dart';
import 'package:binary_data_reader/src/utils/extensions/process_speed_data.dart';

class LiveFrameInstantCommandFactory extends CommandFactory {
  @override
  LiveFrameInstantCommand fromBinary(Uint8List data) {
    final buffer = ByteData.sublistView(data);

    int instantTimestamp = buffer.getInt32(0);
    int instantNanos = buffer.getInt32(4);
    int instantLatitude = buffer.getInt32(8);
    int instantLongitude = buffer.getInt32(12);
    int instantVelocity = buffer.getInt32(16);

    return LiveFrameInstantCommand(
      instantTimestamp: instantTimestamp,
      instantNanos: instantNanos,
      instantVelocity: instantVelocity / 1000,
      instantLatitude: instantLatitude / 10000000,
      instantLongitude: instantLongitude / 10000000,
    );
  }

  @override
  LiveFrameInstantCommand fromProperties(Map<String, dynamic> properties) {
    return LiveFrameInstantCommand(
      instantTimestamp: properties['instantTimestamp'],
      instantNanos: properties['instantNanos'],
      instantVelocity: properties['instantVelocity'],
      instantLatitude: properties['instantLatitude'],
      instantLongitude: properties['instantLongitude'],
    );
  }
}
