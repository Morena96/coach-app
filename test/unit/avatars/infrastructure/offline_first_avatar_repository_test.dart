import 'dart:io';
import 'dart:typed_data';

import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:coach_app/features/avatars/infrastructure/models/memory_image_data.dart';
import 'package:coach_app/features/avatars/infrastructure/repositories/offline_first_avatar_repository.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_database_service.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/memory_file_system_service.dart';
import 'package:dio/dio.dart';
import 'package:domain/features/images/services/image_format_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path/path.dart' as path;

@GenerateMocks([AvatarDatabaseService, Dio, Directory, File, ImageFormatService])
import 'offline_first_avatar_repository_test.mocks.dart';

void main() {
  late OfflineFirstAvatarRepository repository;
  late MockAvatarDatabaseService mockDb;
  late MockDio mockDio;
  late MockDirectory mockDirectory;
  late MemoryFileSystemService fileSystem;
  late MockImageFormatService mockImageFormatService;

  setUp(() {
    mockDb = MockAvatarDatabaseService();
    mockDio = MockDio();
    mockDirectory = MockDirectory();
    fileSystem = MemoryFileSystemService();
    mockImageFormatService = MockImageFormatService();

    when(mockDirectory.path).thenReturn('/test/path');
    when(mockImageFormatService.getFileExtension(any)).thenReturn('jpg');

    repository = OfflineFirstAvatarRepository(
        mockDb, mockDirectory, mockDio, fileSystem, mockImageFormatService);
  });

  group('saveAvatar', () {
    test('should save avatar successfully', () async {
      final imageData = MemoryImageData(Uint8List.fromList([1, 2, 3]));
      final expectedAvatar = Avatar(
        id: '1',
        localPath: path.join('/test/path', 'avatars', '1.jpg'),
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.pendingUpload,
      );

      when(mockDb.insertAvatar(any)).thenAnswer((_) async => expectedAvatar);

      final result = await repository.saveAvatar('1', imageData);

      expect(result, equals(expectedAvatar));
      verify(mockDb.insertAvatar(any)).called(1);
      verify(mockImageFormatService.getFileExtension(any)).called(1);
    });

    test('saveAvatar saves avatar to local storage and database', () async {
      const avatarId = '123';
      const imageData = MemoryImageData([1, 2, 3, 4]);

      final localPath =
          path.join(mockDirectory.path, 'avatars', '$avatarId.jpg');
      final avatar = Avatar(
        id: avatarId,
        localPath: localPath,
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.pendingUpload,
      );

      when(mockDb.insertAvatar(any)).thenAnswer((_) async => avatar);

      final result = await repository.saveAvatar(avatarId, imageData);

      expect(result, isA<Avatar>());
      expect(result.id, equals(avatarId));
      expect(result.localPath, equals(localPath));
      expect(result.syncStatus, equals(SyncStatus.pendingUpload));

      verify(mockDb.insertAvatar(any)).called(1);
      verify(mockImageFormatService.getFileExtension(any)).called(1);
      expect(await fileSystem.exists(localPath), true);
    });
  });

  group('getAvatarImage', () {
    test('should return MemoryImageData when avatar exists', () async {
      final avatar = Avatar(
        id: '1',
        localPath: '/test/path/avatars/1.jpg',
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.synced,
      );

      when(mockDb.findById('1')).thenAnswer((_) async => avatar);

      await fileSystem.write(avatar.localPath, Uint8List.fromList([1, 2, 3]));

      final result = await repository.getAvatarImage('1');

      expect(result, isA<MemoryImageData>());
    });

    test('should return null when avatar does not exist', () async {
      when(mockDb.findById('1')).thenAnswer((_) async => null);

      final result = await repository.getAvatarImage('1');

      expect(result, isNull);
    });
  });

  group('downloadAvatar', () {
    test('should download and save avatar successfully', () async {
      final responseData = Uint8List.fromList([1, 2, 3]);
      final expectedAvatar = Avatar(
        id: '1',
        localPath: path.join('/test/path', 'avatars', '1.jpg'),
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.synced,
      );
      when(mockDb.insertAvatar(any)).thenAnswer((_) async => expectedAvatar);

      when(mockDio.get('https://example.com/avatar.jpg',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));

      await repository.downloadAvatar('1', 'https://example.com/avatar.jpg');

      verify(mockDb.insertAvatar(any)).called(1);
      verify(mockImageFormatService.getFileExtension(any)).called(1);
    });

    test('should throw exception when download fails', () async {
      when(mockDio.get('https://example.com/avatar.jpg',
              options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                statusCode: 404,
                requestOptions: RequestOptions(path: ''),
              ));

      expect(
          () =>
              repository.downloadAvatar('1', 'https://example.com/avatar.jpg'),
          throwsException);
    });
  });

  group('markAvatarAsSynced', () {
    test('should mark avatar as synced', () async {
      final avatar = Avatar(
        id: '1',
        localPath: '/test/path/avatars/1.jpg',
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.pendingUpload,
      );

      when(mockDb.updateAvatar(any)).thenAnswer((_) async => avatar);

      await repository.markAvatarAsSynced(avatar);

      verify(mockDb.updateAvatar(any)).called(1);
    });
  });

  group('getAvatar', () {
    test('should return avatar when it exists', () async {
      final expectedAvatar = Avatar(
        id: '1',
        localPath: '/test/path/avatars/1.jpg',
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.synced,
      );

      when(mockDb.findById('1')).thenAnswer((_) async => expectedAvatar);

      final result = await repository.getAvatar('1');

      expect(result, equals(expectedAvatar));
      verify(mockDb.findById('1')).called(1);
    });

    test('should throw exception when avatar does not exist', () async {
      when(mockDb.findById('1')).thenAnswer((_) async => null);

      expect(() => repository.getAvatar('1'), throwsException);
      verify(mockDb.findById('1')).called(1);
    });
  });
}
