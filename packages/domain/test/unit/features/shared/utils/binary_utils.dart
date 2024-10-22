import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:domain/features/shared/utilities/binary_utils/binary_utils.dart';

void main() {
  group('BinaryUtils', () {
    test('padBinary should pad binary data to 16 bytes if length is 16 or less', () {
      final binary = Uint8List.fromList([1, 2, 3]);
      final padded = BinaryUtils.padBinary(binary);
      expect(padded.length, equals(16));
      expect(padded.sublist(0, 3), equals(binary));
      expect(padded.sublist(3), equals(Uint8List(13)));
    });

    test('padBinary should pad binary data to 32 bytes if length is between 17 and 31', () {
      final binary = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17]);
      final padded = BinaryUtils.padBinary(binary);
      expect(padded.length, equals(32));
      expect(padded.sublist(0, 17), equals(binary));
      expect(padded.sublist(17), equals(Uint8List(15)));
    });

    test('padBinary should not pad if binary length is 32 or greater', () {
      final binary = Uint8List(32);
      binary.fillRange(0, 32, 1);
      final padded = BinaryUtils.padBinary(binary);
      expect(padded, equals(binary));
      expect(padded.length, equals(32));

      final largerBinary = Uint8List(40);
      largerBinary.fillRange(0, 40, 1);
      final largerPadded = BinaryUtils.padBinary(largerBinary);
      expect(largerPadded, equals(largerBinary));
      expect(largerPadded.length, equals(40));
    });

    test('padBinary should handle empty input', () {
      final binary = Uint8List(0);
      final padded = BinaryUtils.padBinary(binary);
      expect(padded, equals(Uint8List(16)));
      expect(padded.length, equals(16));
    });

    test('padBinary should pad to 16 bytes for input with length 16', () {
      final binary = Uint8List.fromList(List.generate(16, (index) => index));
      final padded = BinaryUtils.padBinary(binary);
      expect(padded, equals(binary));
      expect(padded.length, equals(16));
    });

    test('padBinary should pad to 32 bytes for input with length 31', () {
      final binary = Uint8List.fromList(List.generate(31, (index) => index));
      final padded = BinaryUtils.padBinary(binary);
      expect(padded.length, equals(32));
      expect(padded.sublist(0, 31), equals(binary));
      expect(padded[31], equals(0));
    });
  });
}
