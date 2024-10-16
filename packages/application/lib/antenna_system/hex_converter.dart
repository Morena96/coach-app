
import 'dart:typed_data';

abstract class HexConverter {
  Stream<String> streamToHex(Stream<Uint8List> stream);
  Uint8List hexToBytes(String hex);
  String bytesToHex(Uint8List bytes);
}