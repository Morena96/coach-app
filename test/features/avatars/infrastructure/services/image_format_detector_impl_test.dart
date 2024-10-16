import 'dart:typed_data';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_detector_impl.dart';
import 'package:domain/features/images/value_objects/image_format.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  group('ImageFormatDetectorImpl', () {
    late ImageFormatDetectorImpl detector;

    setUp(() {
      detector = ImageFormatDetectorImpl();
    });

    Uint8List createDummyImage(img.ImageFormat format) {
      final image = img.Image(width: 1, height: 1);
      switch (format) {
        case img.ImageFormat.png:
          return Uint8List.fromList(img.encodePng(image));
        case img.ImageFormat.jpg:
          return Uint8List.fromList(img.encodeJpg(image));
        case img.ImageFormat.gif:
          return Uint8List.fromList(img.encodeGif(image));
        case img.ImageFormat.tiff:
          return Uint8List.fromList(img.encodeTiff(image));
        case img.ImageFormat.bmp:
          return Uint8List.fromList(img.encodeBmp(image));
        default:
          throw UnsupportedError('Unsupported format: $format');
      }
    }

    test('should detect PNG format', () {
      final bytes = createDummyImage(img.ImageFormat.png);
      expect(detector.detectFormat(bytes), equals(ImageFormat.png));
    });

    test('should detect JPG format', () {
      final bytes = createDummyImage(img.ImageFormat.jpg);
      expect(detector.detectFormat(bytes), equals(ImageFormat.jpg));
    });

    test('should detect GIF format', () {
      final bytes = createDummyImage(img.ImageFormat.gif);
      expect(detector.detectFormat(bytes), equals(ImageFormat.gif));
    });

    test('should detect TIFF format', () {
      final bytes = createDummyImage(img.ImageFormat.tiff);
      expect(detector.detectFormat(bytes), equals(ImageFormat.tiff));
    });

    test('should detect BMP format', () {
      final bytes = createDummyImage(img.ImageFormat.bmp);
      expect(detector.detectFormat(bytes), equals(ImageFormat.bmp));
    });
  });
}
