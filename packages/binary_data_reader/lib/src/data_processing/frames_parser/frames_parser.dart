import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_types.dart';

import '../models/frame.dart';
import '../parsing_strategies/parsing_strategy.dart';

class FramesParser {
  final FrameParsingStrategy _strategy;
  Uint8List _buffer = Uint8List(0);
  Frame? _currentFrame;
  int _currentPacketId = 0;

  FramesParser(this._strategy);

  Stream<Frame> parse(Stream<Uint8List> byteStream) {
    return byteStream.transform(
      StreamTransformer.fromHandlers(
        handleData: (Uint8List data, EventSink<Frame> sink) {
          _addData(data);
          _processBuffer(sink);
        },
        handleError:
            (Object error, StackTrace stackTrace, EventSink<Frame> sink) {
          sink.addError('Error in stream transformer: $error');
        },
      ),
    );
  }

  void _processBuffer(EventSink<Frame> sink) {
    int currentIndex = 0;
    while (currentIndex + _strategy.sizeWithoutPayload() <= _buffer.length) {
      if (!_strategy.isValidHeader(_buffer, currentIndex)) {
        currentIndex += 1;
        continue;
      }
      int payloadSize = _strategy.payloadSize(_buffer, currentIndex);
      int totalExpectedPacketSize =
          _strategy.sizeWithoutPayload() + payloadSize;
      if (currentIndex + totalExpectedPacketSize > _buffer.length) {
        break; // Insufficient data for a full packet
      }

      Uint8List packetData = Uint8List.fromList(_buffer.sublist(
          currentIndex, currentIndex + totalExpectedPacketSize));

      // ensure crc is valid
      if (!_strategy.isValidCRC(packetData)) {
        currentIndex += 1;
        continue;
      }

      int commandId = _strategy.commandId(packetData, 0,
          Endian.big); // Use offset 0 since packetData is a fresh slice
      // extract the payload
      sink.add(Frame.fromBinary(packetData, _strategy));

      if (commandId >= 0x51 && commandId <= 0x5D) {
        // packet ID is the low nibble of the commandId
        int packetId = commandId & 0x0F;
        _handleLiveModeCommands(packetId, packetData, sink);
        currentIndex += totalExpectedPacketSize;
      } else if (commandId == BLECommandTypes.DOWNLOAD_FRAME_A ||
          commandId == BLECommandTypes.DOWNLOAD_FRAME_B) {
        int packetId = commandId == BLECommandTypes.DOWNLOAD_FRAME_A ? 1 : 2;

        _handleDownloadModeCommands(packetId, packetData, sink);

        if (commandId == BLECommandTypes.DOWNLOAD_FRAME_A) {
          currentIndex += totalExpectedPacketSize;
        } else {
          currentIndex += 1;
        }
      } else {
        currentIndex += totalExpectedPacketSize;
      }
    }
    if (currentIndex > 0) {
      _buffer = Uint8List.sublistView(_buffer, currentIndex);
      currentIndex = 0; // Reset the index as the buffer has been truncated
    }
  }

  void _handleDownloadModeCommands(
      int packetId, Uint8List packetData, EventSink<Frame> sink) {
    if (packetId == 1) {
      _currentFrame = Frame.fromBinary(packetData, _strategy);
    } else if (_currentFrame != null) {
      Uint8List appendedPayload = packetData.sublist(
          _strategy.payloadStartIndex(),
          packetData.length - _strategy.crcFieldSize());
      _currentFrame!.appendPayload(appendedPayload);
      sink.add(_currentFrame!);
      _currentFrame = null;
    } else {
      // if we receive a frame B without a frame A, we ignore it
    }
  }

  void _handleLiveModeCommands(
      int packetId, Uint8List packetData, EventSink<Frame> sink) {
    if (packetId == 1 ||
        (packetId > 1 && packetId <= 12 && _currentPacketId + 1 == packetId)) {
      if (packetId == 1) {
        _currentFrame = Frame.fromBinary(packetData, _strategy);
      } else if (_currentFrame != null) {
        Uint8List appendedPayload = packetData.sublist(
            _strategy.payloadStartIndex(extraBytes: 20),
            packetData.length - _strategy.crcFieldSize());
        _currentFrame!.appendPayload(appendedPayload);
      }
      _currentPacketId = packetId;
      if (packetId == 12) {
        sink.add(_currentFrame!);
        _currentFrame = null;
        _currentPacketId = 0;
      }
    } else {
      _currentFrame = null;
      _currentPacketId = 0;
    }
  }

  void _ensureCapacity(int requiredCapacity) {
    if (_buffer.length < requiredCapacity) {
      int newCapacity =
          _buffer.length == 0 ? requiredCapacity : _buffer.length * 2;
      while (newCapacity < requiredCapacity) newCapacity *= 2;
      var newBuffer = Uint8List(newCapacity);
      newBuffer.setRange(0, _buffer.length, _buffer);
      _buffer = newBuffer;
    }
  }

  void _addData(Uint8List newData) {
    _ensureCapacity(_buffer.length + newData.length);
    _buffer.setRange(_buffer.length - newData.length, _buffer.length, newData);
  }
}
