import 'dart:typed_data';
import 'package:domain/features/images/services/image_format_detector.dart';
import 'package:domain/features/images/services/image_format_service.dart';
import 'package:domain/features/images/value_objects/image_format.dart';

class ImageFormatServiceImpl implements ImageFormatService {
  final ImageFormatDetector _imageFormatDetector;

  ImageFormatServiceImpl(this._imageFormatDetector);

  @override
  String getFileExtension(Uint8List bytes) {
    if (_isSvg(bytes)) {
      return 'svg';
    }

    final imageFormat = _imageFormatDetector.detectFormat(bytes);

    if (imageFormat == ImageFormat.invalid) {
      throw Exception('Unable to decode image');
    }

    switch (imageFormat) {
      case ImageFormat.png:
        return 'png';
      case ImageFormat.jpg:
        return 'jpg';
      case ImageFormat.gif:
        return 'gif';
      case ImageFormat.webp:
        return 'webp';
      case ImageFormat.tiff:
        return 'tiff';
      case ImageFormat.bmp:
        return 'bmp';
      default:
        throw Exception('Unsupported image format');
    }
  }

  bool _isSvg(Uint8List bytes) {
    final header = String.fromCharCodes(bytes.take(5));
    return header.startsWith('<?xml') || header.startsWith('<svg');
  }
}
