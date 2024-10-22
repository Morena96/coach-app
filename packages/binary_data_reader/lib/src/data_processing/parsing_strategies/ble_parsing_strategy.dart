// Concrete implementation for Gateway data
import 'dart:typed_data';

import 'package:binary_data_reader/src/utils/crc16.dart';
import 'package:binary_data_reader/src/utils/crc32.dart';

import 'parsing_strategy.dart';

class BleParsingStrategy extends FrameParsingStrategy {
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
    return crc16Compute(data);
  }

  @override
  int sizeFieldSize() {
    return 1;
  }

  @override
  int sizeFieldIndex() {
    return headerFieldSize() + commandIdFieldSize();
  }

  @override
  int commandIdFieldSize() {
    return 1;
  }

  @override
  int commandIdStartIndex() {
    return headerFieldSize();
  }

  @override
  int crcFieldSize() {
    return 2;
  }

  @override
  int headerFieldSize() {
    return 2;
  }
}
