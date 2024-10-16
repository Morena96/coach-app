import 'dart:typed_data';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/features/images/services/image_format_detector.dart';
import 'package:domain/features/images/value_objects/image_format.dart';

@GenerateMocks([ImageFormatDetector])
import 'image_format_service_impl_test.mocks.dart';

void main() {
  late ImageFormatServiceImpl imageFormatService;
  late MockImageFormatDetector mockImageFormatDetector;

  setUp(() {
    mockImageFormatDetector = MockImageFormatDetector();
    imageFormatService = ImageFormatServiceImpl(mockImageFormatDetector);
  });

  group('ImageFormatServiceImpl', () {
    test('getFileExtension returns svg for SVG data', () {
      final svgBytes = Uint8List.fromList('<?xml'.codeUnits);
      expect(imageFormatService.getFileExtension(svgBytes), equals('svg'));
    });

    test('getFileExtension returns correct extension for PNG', () {
      final pngBytes = Uint8List.fromList([0]);
      when(mockImageFormatDetector.detectFormat(pngBytes)).thenReturn(ImageFormat.png);
      expect(imageFormatService.getFileExtension(pngBytes), equals('png'));
    });

    test('getFileExtension returns correct extension for JPG', () {
      final jpgBytes = Uint8List.fromList([0]);
      when(mockImageFormatDetector.detectFormat(jpgBytes)).thenReturn(ImageFormat.jpg);
      expect(imageFormatService.getFileExtension(jpgBytes), equals('jpg'));
    });

    test('getFileExtension returns correct extension for GIF', () {
      final gifBytes = Uint8List.fromList([0]);
      when(mockImageFormatDetector.detectFormat(gifBytes)).thenReturn(ImageFormat.gif);
      expect(imageFormatService.getFileExtension(gifBytes), equals('gif'));
    });

    test('getFileExtension returns correct extension for WebP', () {
      final webpBytes = Uint8List.fromList([0]);
      when(mockImageFormatDetector.detectFormat(webpBytes)).thenReturn(ImageFormat.webp);
      expect(imageFormatService.getFileExtension(webpBytes), equals('webp'));
    });

    test('getFileExtension returns correct extension for TIFF', () {
      final tiffBytes = Uint8List.fromList([0]);
      when(mockImageFormatDetector.detectFormat(tiffBytes)).thenReturn(ImageFormat.tiff);
      expect(imageFormatService.getFileExtension(tiffBytes), equals('tiff'));
    });

    test('getFileExtension returns correct extension for BMP', () {
      final bmpBytes = Uint8List.fromList([0]);
      when(mockImageFormatDetector.detectFormat(bmpBytes)).thenReturn(ImageFormat.bmp);
      expect(imageFormatService.getFileExtension(bmpBytes), equals('bmp'));
    });

    test('getFileExtension throws exception for invalid image format', () {
      final invalidBytes = Uint8List.fromList([0]);
      when(mockImageFormatDetector.detectFormat(invalidBytes)).thenReturn(ImageFormat.invalid);
      expect(() => imageFormatService.getFileExtension(invalidBytes), throwsException);
    });
  });
}
