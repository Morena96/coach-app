// Concrete implementation for Gateway data
import 'dart:typed_data';

import 'package:binary_data_reader/src/utils/crc32.dart';

import 'parsing_strategy.dart';

class GatewayParsingStrategy extends FrameParsingStrategy {
  static const int header1 = 0x43;
  static const int header2 = 0xF5;

  @override
  bool isValidHeader(Uint8List data, int startIndex) {
    // Ensure the data is long enough to contain the header
    if (data.length < headerFieldSize()) return false;
    // Check the first two bytes against the expected header values
    return data[startIndex] == header1 && data[startIndex + 1] == header2;
  }

  @override
  int calculateCRC(Uint8List data) {
    return crc32Compute(data, 0);
  }

  @override
  int sizeFieldSize() {
    return 2;
  }

  @override
  int sizeFieldIndex() {
    return headerFieldSize();
  }

  @override
  int commandIdFieldSize() {
    return 2;
  }

  @override
  int commandIdStartIndex() {
    return headerFieldSize() + sizeFieldSize();
  }

  @override
  int headerFieldSize() {
    return 2;
  }

  @override
  int crcFieldSize() {
    return 4;
  }

}
