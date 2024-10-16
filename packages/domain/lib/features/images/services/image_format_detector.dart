import 'dart:typed_data';

import 'package:domain/features/images/value_objects/image_format.dart';

abstract class ImageFormatDetector {
  ImageFormat detectFormat(Uint8List bytes);
}
