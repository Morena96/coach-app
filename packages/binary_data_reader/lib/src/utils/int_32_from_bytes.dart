import 'dart:typed_data';

int int32FromBytes(Uint8List bytes, int offset,
    {Endian endian = Endian.little}) {
  return bytes.buffer.asByteData().getInt32(offset, endian);
}
