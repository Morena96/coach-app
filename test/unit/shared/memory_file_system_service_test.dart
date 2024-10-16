import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/memory_file_system_service.dart';

void main() {
  group('MemoryFileSystemService', () {
    late MemoryFileSystemService fileSystemService;

    setUp(() {
      fileSystemService = MemoryFileSystemService();
    });

    tearDown(() {
      fileSystemService.clear();
    });

    test('should write a file and return its path', () async {
      const path = 'test/file.txt';
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);

      final writtenPath = await fileSystemService.write(path, data);

      expect(writtenPath, path);
      expect(await fileSystemService.exists(path), isTrue);
      expect(await fileSystemService.read(path), data);
    });

    test('should check if a file exists', () async {
      const path = 'test/file.txt';
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);

      expect(await fileSystemService.exists(path), isFalse);

      await fileSystemService.write(path, data);

      expect(await fileSystemService.exists(path), isTrue);
    });

    test('should throw Exception when reading a non-existent file', () async {
      const path = 'test/non_existent_file.txt';

      expect(
        () async => await fileSystemService.read(path),
        throwsA(isA<Exception>()),
      );
    });

    test('should read file as bytes', () async {
      const path = 'test/file.txt';
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);

      await fileSystemService.write(path, data);

      final bytes = await fileSystemService.read(path);

      expect(bytes, data);
    });

    test('should delete a file', () async {
      const path = 'test/file.txt';
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);

      await fileSystemService.write(path, data);

      expect(await fileSystemService.exists(path), isTrue);

      await fileSystemService.delete(path);

      expect(await fileSystemService.exists(path), isFalse);
    });

    test('should clear all files', () async {
      const path1 = 'test/file1.txt';
      final data1 = Uint8List.fromList([1, 2, 3, 4, 5]);
      const path2 = 'test/file2.txt';
      final data2 = Uint8List.fromList([6, 7, 8, 9, 10]);

      await fileSystemService.write(path1, data1);
      await fileSystemService.write(path2, data2);

      expect(await fileSystemService.exists(path1), isTrue);
      expect(await fileSystemService.exists(path2), isTrue);

      fileSystemService.clear();

      expect(await fileSystemService.exists(path1), isFalse);
      expect(await fileSystemService.exists(path2), isFalse);
    });
  });
}
