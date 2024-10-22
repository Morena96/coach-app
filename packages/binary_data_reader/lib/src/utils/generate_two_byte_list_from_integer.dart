import 'dart:typed_data';

Uint8List generateTwoByteListFromInteger(int value) {
  assert(value >= 0 && value <= 65535,
      'Value must be between 0 and 65535, inclusive!');
  final buffer = Uint8List(2);
  buffer[0] = (value & 0xFF00) >> 8;
  buffer[1] = value & 0xFF;
  return buffer;
}