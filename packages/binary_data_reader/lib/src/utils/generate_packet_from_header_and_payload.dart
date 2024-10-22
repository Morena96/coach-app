import 'dart:typed_data';

import 'crc16.dart';
import 'generate_two_byte_list_from_integer.dart';

Uint8List generatePacketFromHeaderAndPayload(List<int> header, List<int> payload) {
  List<int> headerAndPayload = [...header, ...payload];
  int crc = crc16Compute(Uint8List.fromList(headerAndPayload));
  List<int> frameWithCRC = [...headerAndPayload, ...generateTwoByteListFromInteger(crc)];
  return Uint8List.fromList(frameWithCRC);
}