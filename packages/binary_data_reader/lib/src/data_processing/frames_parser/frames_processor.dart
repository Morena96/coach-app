import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_producer.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:binary_data_reader/src/data_processing/models/frame.dart';

import '../../commands/command_types.dart';

/// FramesProcessor
///
/// FramesProcessor is responsible for processing parsed frames for further use within the system.
/// It may involve operations such as frame validation, transformation, aggregation, or filtering.
/// The processed frames can then be directed towards various endpoints, including storage, analysis,
/// or real-time monitoring.
///
/// Responsibilities:
/// - Applying business logic or transformations to parsed frames.
/// - Preparing frames for storage or further analysis.
/// - Managing the flow of frames to subsequent system components such as StorageAdapters.
class FramesProcessor {
  FrameParsingStrategy parsingStrategy;

  FramesProcessor(this.parsingStrategy);

  Stream<Command> process(Stream<Frame> frameStream) {
    return frameStream.where((Frame frame) {
      if (frame.commandId == BLECommandTypes.RECEIVE_LIVE_MODE &&
          frame.payload.length != 452) {
        // live frames are 452 bytes in the payload
        return false;
      } else if (frame.commandId == BLECommandTypes.RECEIVE_DOWNLOAD &&
          frame.payload.length != 432) {
        return false;
      } else if (frame.commandId == BLECommandTypes.DOWNLOAD_FRAME_B) {
        return false;
      } else {
        return true;
      }
    }).map((Frame frame) {
      return _getCommand(frame.commandId, frame.payload);
    });
  }

  Stream<Frame> toFrames(Stream<Command> payloadStream) {
    return payloadStream.map((Command command) {
      return Frame.fromCommand(command, parsingStrategy);
    });
  }

  Command _getCommand(int commandId, Uint8List payload) {
    CommandProducer producer = CommandProducer();
    if (parsingStrategy is BleParsingStrategy) {
      return producer.createBLECommandFromBinary(commandId, payload);
    }
    return producer.createCommandFromBinary(commandId, payload);
  }
}
