// Strategy interface for parsing
import 'dart:typed_data';

abstract class FrameParsingStrategy {
  bool isValidHeader(Uint8List data, int startIndex);

  int sizeFieldSize();

  int sizeFieldIndex();

  int calculateCRC(Uint8List data);

  int commandIdStartIndex();

  int commandIdFieldSize();

  int crcFieldSize();

  int headerFieldSize();

  int sizeWithoutPayload() {
    return headerFieldSize() +
        sizeFieldSize() +
        commandIdFieldSize() +
        crcFieldSize();
  }

  int payloadStartIndex({int extraBytes = 0}) {
    return headerFieldSize() +
        sizeFieldSize() +
        commandIdFieldSize() +
        extraBytes;
  }

  int totalSize(int payloadSize) {
    return sizeWithoutPayload() + payloadSize;
  }

  int commandId(Uint8List data, int startIndex, Endian endian) {
    final byteData = ByteData.sublistView(data);
    if (commandIdFieldSize() == 1) {
      return byteData.getUint8(startIndex + commandIdStartIndex());
    } else {
      // Assuming 2 as the only other option for simplicity
      return byteData.getUint16(startIndex + commandIdStartIndex(), endian);
    }
  }

  int payloadSize(Uint8List data, int startIndex) {
    if (data.length < startIndex + headerFieldSize() + sizeFieldSize()) {
      throw Exception('Data too short to contain a valid size field.');
    }

    final byteData = ByteData.sublistView(data);

    if (sizeFieldSize() == 1) {
      return byteData.getUint8(startIndex + sizeFieldIndex());
    } else {
      // Assuming 2 as the only other option for simplicity
      return byteData.getUint16(startIndex + sizeFieldIndex(), Endian.big);
    }
  }

  // This function is used to extract CRC (Cyclic Redundancy Check) value from the data
  int extractCrc(Uint8List data) {
    final byteData = ByteData.sublistView(data);

    if (crcFieldSize() == 1) {
      return byteData.getUint8(data.length - crcFieldSize());
    } else if (crcFieldSize() == 2) {
      return byteData.getUint16(data.length - crcFieldSize(), Endian.big);
    } else if (crcFieldSize() == 4) {
      return byteData.getUint32(data.length - crcFieldSize(), Endian.big);
    } else {
      throw Exception('Unsupported CRC field size.');
    }
  }

  bool isValidCRC(Uint8List data) {
    return calculateCRC(data.sublist(0, data.length - crcFieldSize())) ==
        extractCrc(data);
  }
}
