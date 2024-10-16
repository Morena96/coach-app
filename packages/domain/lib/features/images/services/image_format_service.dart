import 'dart:typed_data';

abstract class ImageFormatService {
  String getFileExtension(Uint8List bytes);
}