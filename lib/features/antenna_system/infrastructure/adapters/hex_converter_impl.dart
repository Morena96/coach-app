import 'dart:typed_data';

import 'package:application/antenna_system/hex_converter.dart';

class HexConverterImpl implements HexConverter {

  String _byteToHex(int byte) {
    return byte.toRadixString(16).padLeft(2, '0');
  }

  @override
  String bytesToHex(Uint8List bytes) {
    return bytes.map(_byteToHex).join(' ');
  }

  @override
  Stream<String> streamToHex(Stream<Uint8List> stream) {
    return stream.map((chunk) => bytesToHex(chunk));
  }

  @override
  Uint8List hexToBytes(String hex) {
    final bytes = <int>[];
    final parts = hex.split(' ');
    for (var part in parts) {
      bytes.add(int.parse(part, radix: 16));
    }
    return Uint8List.fromList(bytes);
  }
}