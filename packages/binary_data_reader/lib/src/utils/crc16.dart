import 'dart:typed_data';

int crc16Compute(Uint8List pData) {

  int crc = 0xFFFF;

  for (int i = 0; i < pData.length; i++) {
    crc = ((crc >> 8) & 0xFF) | (crc << 8);
    crc ^= pData[i];
    crc ^= (crc & 0xFF) >> 4;
    crc ^= (crc << 8) << 4;
    crc ^= ((crc & 0xFF) << 4) << 1;
  }

  return crc & 0xFFFF;
}