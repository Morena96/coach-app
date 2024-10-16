import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/shared/infrastructure/file_system/io_file_system_service.dart';

void main() {
  group('IoFileSystemService', () {
    late IoFileSystemService fileSystemService;
    late Directory tempDir;

    setUp(() async {
      fileSystemService = IoFileSystemService();
      tempDir = await Directory.systemTemp.createTemp('io_file_system_test_');
    });

    tearDown(() async {
      await tempDir.delete(recursive: true);
    });

    String getTestFilePath(String filename) {
      return '${tempDir.path}/$filename';
    }

    test('should write a file and return its path', () async {
      final path = getTestFilePath('file.txt');
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);

      final writtenPath = await fileSystemService.write(path, data);

      expect(writtenPath, path);
      expect(await fileSystemService.exists(path), isTrue);
      expect(await fileSystemService.read(path), data);
    });

    test('should check if a file exists', () async {
      final path = getTestFilePath('file.txt');
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);

      expect(await fileSystemService.exists(path), isFalse);

      await fileSystemService.write(path, data);

      expect(await fileSystemService.exists(path), isTrue);
    });

    test('should throw Exception when reading a non-existent file', () async {
      final path = getTestFilePath('non_existent_file.txt');

      expect(
        () async => await fileSystemService.read(path),
        throwsA(isA<FileSystemException>()),
      );
    });

    test('should read file as bytes', () async {
      final path = getTestFilePath('file.txt');
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);

      await fileSystemService.write(path, data);

      final bytes = await fileSystemService.read(path);

      expect(bytes, data);
    });

    test('should delete a file', () async {
      final path = getTestFilePath('file.txt');
      final data = Uint8List.fromList([1, 2, 3, 4, 5]);

      await fileSystemService.write(path, data);

      expect(await fileSystemService.exists(path), isTrue);

      await fileSystemService.delete(path);

      expect(await fileSystemService.exists(path), isFalse);
    });

    test('should handle deleting a non-existent file', () async {
      final path = getTestFilePath('non_existent_file.txt');

      // This should not throw an exception
      await fileSystemService.delete(path);
    });

    test('should handle concurrent file operations', () async {
      final path = getTestFilePath('concurrent_file.txt');
      final data1 = Uint8List.fromList([1, 2, 3]);
      final data2 = Uint8List.fromList([4, 5, 6]);

      // Perform concurrent write operations
      final futures = [
        fileSystemService.write(path, data1),
        fileSystemService.write(path, data2),
      ];

      await Future.wait(futures);

      // The file should exist
      expect(await fileSystemService.exists(path), isTrue);
    });
  });
}
