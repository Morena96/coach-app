import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:domain/features/images/services/image_format_detector.dart';
import 'package:domain/features/images/value_objects/image_format.dart';

class ImageFormatDetectorImpl implements ImageFormatDetector {
  @override
  ImageFormat detectFormat(Uint8List bytes) {
    final format = img.findDecoderForData(bytes)?.format;
    
    switch (format) {
      case img.ImageFormat.png:
        return ImageFormat.png;
      case img.ImageFormat.jpg:
        return ImageFormat.jpg;
      case img.ImageFormat.gif:
        return ImageFormat.gif;
      case img.ImageFormat.webp:
        return ImageFormat.webp;
      case img.ImageFormat.tiff:
        return ImageFormat.tiff;
      case img.ImageFormat.bmp:
        return ImageFormat.bmp;
      default:
        return ImageFormat.invalid;
    }
  }
}
