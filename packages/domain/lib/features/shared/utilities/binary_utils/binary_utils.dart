import 'dart:typed_data';

class BinaryUtils {
  static Uint8List padBinary(Uint8List binary) {
    if (binary.length <= 16) {
      return Uint8List.fromList(binary + List<int>.filled(16 - binary.length, 0x00));
    } else if (binary.length > 16 && binary.length < 32) {
      return Uint8List.fromList(binary + List<int>.filled(32 - binary.length, 0x00));
    }
    return binary;
  }
}
