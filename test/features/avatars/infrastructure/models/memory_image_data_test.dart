import 'package:coach_app/features/avatars/infrastructure/models/memory_image_data.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MemoryImageData', () {
    test('should return the correct bytes', () {
      // Arrange
      final bytes = [1, 2, 3, 4, 5];
      final memoryImageData = MemoryImageData(bytes);

      // Act
      final result = memoryImageData.getBytes();

      // Assert
      expect(result, equals(bytes));
      expect(result, isA<List<int>>());
    });

    test('should not modify the original bytes', () {
      // Arrange
      final originalBytes = [1, 2, 3, 4, 5];
      final memoryImageData = MemoryImageData(originalBytes);

      // Act
      final returnedBytes = memoryImageData.getBytes();
      returnedBytes.add(6);

      // Assert
      expect(memoryImageData.getBytes(), equals(originalBytes));
    });

    group('equality', () {
      test('instances with the same bytes should be equal', () {
        // Arrange
        final bytes = [1, 2, 3, 4, 5];
        final memoryImageData1 = MemoryImageData(bytes);
        final memoryImageData2 = MemoryImageData(List.from(bytes));

        // Assert
        expect(memoryImageData1, equals(memoryImageData2));
        expect(memoryImageData1.hashCode, equals(memoryImageData2.hashCode));
      });

      test('instances with different bytes should not be equal', () {
        // Arrange
        const memoryImageData1 = MemoryImageData([1, 2, 3, 4, 5]);
        const memoryImageData2 = MemoryImageData([1, 2, 3, 4, 6]);

        // Assert
        expect(memoryImageData1, isNot(equals(memoryImageData2)));
        expect(memoryImageData1.hashCode,
            isNot(equals(memoryImageData2.hashCode)));
      });
    });

    test('props should contain bytes', () {
      // Arrange
      final bytes = [1, 2, 3, 4, 5];
      final memoryImageData = MemoryImageData(bytes);

      // Assert
      expect(memoryImageData.props, [bytes]);
    });
  });
}
