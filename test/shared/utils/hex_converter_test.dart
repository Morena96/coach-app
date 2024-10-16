import 'dart:async';
import 'dart:typed_data';
import 'package:coach_app/shared/utils/hex_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HexConverter', () {
    test('byteToHex converts byte to hex string correctly', () {
      expect(HexConverter.byteToHex(0), equals('00'));
      expect(HexConverter.byteToHex(15), equals('0f'));
      expect(HexConverter.byteToHex(255), equals('ff'));
    });

    test('bytesToHex converts Uint8List to hex string correctly', () {
      final bytes = Uint8List.fromList([0, 15, 255]);
      expect(HexConverter.bytesToHex(bytes), equals('00 0f ff'));
    });

    test('bytesToHex handles empty Uint8List', () {
      final bytes = Uint8List(0);
      expect(HexConverter.bytesToHex(bytes), equals(''));
    });

    test('streamToHex converts stream of Uint8List to stream of hex strings',
        () async {
      final input = Stream<Uint8List>.fromIterable([
        Uint8List.fromList([0, 15]),
        Uint8List.fromList([255]),
      ]);

      final output = HexConverter.streamToHex(input);
      expect(await output.toList(), equals(['00 0f', 'ff']));
    });

    test('hexToBytes converts hex string to Uint8List correctly', () {
      const hex = '00 0f ff';
      final bytes = HexConverter.hexToBytes(hex);
      expect(bytes, equals(Uint8List.fromList([0, 15, 255])));
    });

    test('hexToBytes throws FormatException for invalid hex string', () {
      const invalidHex = '00 gg ff';
      expect(() => HexConverter.hexToBytes(invalidHex), throwsFormatException);
    });

    test('roundtrip conversion maintains data integrity', () {
      final original = Uint8List.fromList([0, 15, 255, 128, 64, 32]);
      final hex = HexConverter.bytesToHex(original);
      final roundtrip = HexConverter.hexToBytes(hex);
      expect(roundtrip, equals(original));
    });
  });
}
