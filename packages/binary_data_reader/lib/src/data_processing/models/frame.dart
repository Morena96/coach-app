import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class Frame {
  static const header = 0x43F5;
  int commandId;
  Uint8List payload;

  int get size => payload.length;

  Frame({
    required this.commandId,
    required this.payload,
  });

  // Factory constructor to build a Frame instance from raw binary data
  factory Frame.fromBinary(Uint8List data, FrameParsingStrategy parsingStrategy,
      {Endian endian = Endian.big}) {
    if (data.length < parsingStrategy.sizeWithoutPayload()) {
      throw FormatException('Frame data is too short.');
    }

    if (!parsingStrategy.isValidHeader(data, 0)) {
      throw FormatException('Invalid frame header.');
    }

    final rawCommandId = parsingStrategy.commandId(data, 0, endian);
    final commandId = normalizeCommandId(rawCommandId);
    final payloadStartIndex = parsingStrategy.payloadStartIndex();
    final payload = Uint8List.sublistView(
        data, payloadStartIndex, data.length - parsingStrategy.crcFieldSize());
    return Frame(commandId: commandId, payload: payload);
  }

  factory Frame.fromCommand(
      Command command, FrameParsingStrategy parsingStrategy) {
    final payload = command.serialize();
    final ByteData dataToComputeCrc = ByteData(4 + payload.length);
    dataToComputeCrc.setUint16(0, header);
    dataToComputeCrc.setUint8(2, command.commandId);
    dataToComputeCrc.setUint8(3, payload.length);

    for (int i = 0; i < payload.length; i++) {
      dataToComputeCrc.setUint8(4 + i, payload[i]);
    }
    return Frame(
      commandId: command.commandId,
      payload: payload,
    );
  }

  // Serialize the Frame instance to raw binary data
  Uint8List toBinary(FrameParsingStrategy parsingStrategy,
      {Endian endian = Endian.big}) {
    final byteData = ByteData(parsingStrategy.totalSize(payload.length));

    void setHeader(int offset, int value) {
      final size = parsingStrategy.headerFieldSize();
      if (size == 2) {
        byteData.setUint16(offset, value, endian);
      } else if (size == 1) {
        byteData.setUint8(offset, value);
      } else {
        throw Exception('Unsupported header field size.');
      }
    }

    void setField(int offset, int value, int size) {
      if (size == 2) {
        byteData.setUint16(offset, value, endian);
      } else if (size == 1) {
        byteData.setUint8(offset, value);
      } else {
        throw Exception('Unsupported field size.');
      }
    }

    void setCRC(int offset, int crcValue, int size) {
      if (size == 4) {
        byteData.setUint32(offset, crcValue, endian);
      } else if (size == 2) {
        byteData.setUint16(offset, crcValue, endian);
      } else {
        throw Exception('Unsupported CRC field size.');
      }
    }

    setHeader(0, header);
    setField(parsingStrategy.commandIdStartIndex(), commandId,
        parsingStrategy.commandIdFieldSize());
    setField(parsingStrategy.sizeFieldIndex(), payload.length,
        parsingStrategy.sizeFieldSize());

    for (int i = 0; i < payload.length; i++) {
      byteData.setUint8(parsingStrategy.payloadStartIndex() + i, payload[i]);
    }

    var slicedBuffer = byteData.buffer.asUint8List(
        0, byteData.lengthInBytes - parsingStrategy.crcFieldSize());
    setCRC(
        parsingStrategy.payloadStartIndex() + payload.length,
        parsingStrategy.calculateCRC(slicedBuffer),
        parsingStrategy.crcFieldSize());

    return byteData.buffer.asUint8List();
  }

  static int normalizeCommandId(int commandId) {
    if (commandId == 0x51) {
      return BLECommandTypes.RECEIVE_LIVE_MODE; // Example normalized ID
    }
    if (commandId >= 0x52 && commandId <= 0x5D) {
      return BLECommandTypes.RECEIVE_LIVE_INSTANT_MODE; // Example normalized ID
    }
    if (commandId == 0x82) {
      return BLECommandTypes.RECEIVE_DOWNLOAD;
    }
    return commandId;
  }

  void appendPayload(Uint8List data) {
    final Uint8List newPayload = Uint8List(payload.length + data.length);
    newPayload.setAll(0, payload);
    newPayload.setAll(payload.length, data);
    payload = newPayload;
  }

  @override
  String toString() {
    return 'Frame: header: $header, commandId: $commandId, payload: $payload';
  }
}
