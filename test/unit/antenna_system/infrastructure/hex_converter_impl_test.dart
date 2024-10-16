import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/features/antenna_system/infrastructure/adapters/hex_converter_impl.dart';

void main() {
  late HexConverterImpl hexConverter;

  setUp(() {
    hexConverter = HexConverterImpl();
  });

  group('HexConverterImpl', () {
    test('bytesToHex converts Uint8List to hex string', () {
      final bytes = Uint8List.fromList([0, 255, 10, 1]);
      expect(hexConverter.bytesToHex(bytes), equals('00 ff 0a 01'));
    });

    test('hexToBytes converts hex string to Uint8List', () {
      const hexString = '00 ff 0a 01';
      final result = hexConverter.hexToBytes(hexString);
      expect(result, equals(Uint8List.fromList([0, 255, 10, 1])));
    });

    test('streamToHex converts Stream<Uint8List> to Stream<String>', () async {
      final inputStream = Stream.fromIterable([
        Uint8List.fromList([0, 255]),
        Uint8List.fromList([10, 1]),
      ]);

      final outputStream = hexConverter.streamToHex(inputStream);
      final results = await outputStream.toList();

      expect(results, equals(['00 ff', '0a 01']));
    });

    test('bytesToHex handles empty Uint8List', () {
      final bytes = Uint8List(0);
      expect(hexConverter.bytesToHex(bytes), equals(''));
    });

    test('hexToBytes throws FormatException for empty string', () {
      const hexString = '';
      expect(() => hexConverter.hexToBytes(hexString), throwsFormatException);
    });

    test('hexToBytes throws FormatException for invalid hex string', () {
      const invalidHexString = '00 gg 0a 01';
      expect(() => hexConverter.hexToBytes(invalidHexString), throwsFormatException);
    });

    test('streamToHex handles empty stream', () async {
      const inputStream = Stream<Uint8List>.empty();
      final outputStream = hexConverter.streamToHex(inputStream);
      final results = await outputStream.toList();
      expect(results, isEmpty);
    });
  });
}
