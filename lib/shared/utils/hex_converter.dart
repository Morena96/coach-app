import 'dart:typed_data';

/// Utility class to convert between Uint8List and hex-encoded strings.
class HexConverter {
  /// Converts a single byte to a two-character hex string.
  static String byteToHex(int byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }

  /// Converts a Uint8List to a hex-encoded string.
  static String bytesToHex(Uint8List bytes) {
    return bytes.map(byteToHex).join(' ');
  }

  /// Converts a stream of Uint8List to a stream of hex-encoded strings.
  static Stream<String> streamToHex(Stream<Uint8List> stream) {
    return stream.map((chunk) => bytesToHex(chunk));
  }

  /// Converts a string in hex format with space separator to a Uint8List.
  static Uint8List hexToBytes(String hex) {
    final bytes = <int>[];
    final parts = hex.split(' ');
    for (var part in parts) {
      bytes.add(int.parse(part, radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}
