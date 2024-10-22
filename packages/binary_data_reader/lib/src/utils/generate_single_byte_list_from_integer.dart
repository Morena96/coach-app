import 'dart:typed_data';

Uint8List generateSingleByteFromAnInteger(int value) {
  assert(value >= 0 && value <= 255,
      'Value must be between 0 and 255, inclusive!');
  final buffer = Uint8List(1);
  buffer[0] = value;
  return buffer;
}
