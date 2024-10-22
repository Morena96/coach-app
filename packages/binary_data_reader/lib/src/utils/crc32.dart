import 'dart:typed_data';

// define function
int crc32Compute(Uint8List pData, int value) {
  int crc = ~(value);
  for (int i = 0; i < pData.length; i++) {
    crc = (crc ^ (pData[i] & 0xFF)) & 0xFFFFFFFF;
    for (int j = 8; j > 0; j--) {
      crc = (((crc >> 1) & 0x7FFFFFFF) ^
          (0xEDB88320 & ((crc & 1) == 1 ? 0xFFFFFFFF : 0)));
    }
  }
  return ~crc & 0xFFFFFFFF;
}
