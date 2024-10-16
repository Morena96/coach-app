import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/avatars/infrastructure/models/file_image_data.dart';

import '../../../../unit/avatars/infrastructure/offline_first_avatar_repository_test.mocks.dart';

void main() {
  group('FileImageData', () {
    late MockFile mockFile;
    late FileImageData fileImageData;

    setUp(() {
      mockFile = MockFile();
      fileImageData = FileImageData(mockFile);
    });

    test('getBytes should return Uint8List from file', () {
      // Arrange
      final expectedBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      when(mockFile.readAsBytesSync()).thenReturn(expectedBytes);

      // Act
      final result = fileImageData.getBytes();

      // Assert
      expect(result, equals(expectedBytes));
      expect(result, isA<Uint8List>());
      verify(mockFile.readAsBytesSync()).called(1);
    });

    test('getBytes should throw when file read fails', () {
      // Arrange
      when(mockFile.readAsBytesSync())
          .thenThrow(const FileSystemException('File read error'));

      // Act & Assert
      expect(
          () => fileImageData.getBytes(), throwsA(isA<FileSystemException>()));
      verify(mockFile.readAsBytesSync()).called(1);
    });
  });
}
