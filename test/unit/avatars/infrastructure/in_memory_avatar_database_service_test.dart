import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:coach_app/features/avatars/infrastructure/services/in_memory_avatar_database_service.dart';

void main() {
  late InMemoryAvatarDatabaseService service;

  setUp(() {
    service = InMemoryAvatarDatabaseService();
  });

  group('InMemoryAvatarDatabaseService', () {
    test('insertAvatar should add an avatar and return it', () async {
      final avatarData = {
        'id': '1',
        'localPath': '/path/to/avatar.png',
        'lastUpdated': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.synced.index,
      };

      final result = await service.insertAvatar(avatarData);

      expect(result, isA<Avatar>());
      expect(result.id, equals('1'));
      expect(result.localPath, equals('/path/to/avatar.png'));
    });

    test('findById should return the correct avatar', () async {
      final avatarData = {
        'id': '2',
        'localPath': '/path/to/avatar2.png',
        'lastUpdated': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.synced.index,
      };
      await service.insertAvatar(avatarData);

      final result = await service.findById('2');

      expect(result, isNotNull);
      expect(result!.id, equals('2'));
      expect(result.localPath, equals('/path/to/avatar2.png'));
    });

    test('findById should return null for non-existent avatar', () async {
      final result = await service.findById('non-existent');

      expect(result, isNull);
    });

    test('findAvatarByPath should return the correct avatar', () async {
      final avatarData = {
        'id': '3',
        'localPath': '/path/to/avatar3.png',
        'remotePath': 'https://example.com/avatar3.png',
        'lastUpdated': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.synced.index,
      };
      await service.insertAvatar(avatarData);

      final result = await service.findAvatarByPath('/path/to/avatar3.png');

      expect(result, isNotNull);
      expect(result!.id, equals('3'));
      expect(result.localPath, equals('/path/to/avatar3.png'));
    });

    test('findAvatarByPath should return null for non-existent path', () async {
      final result = await service.findAvatarByPath('/non/existent/path.png');

      expect(result, isNull);
    });

    test('updateAvatar should modify an existing avatar', () async {
      final avatarData = {
        'id': '4',
        'localPath': '/path/to/avatar4.png',
        'lastUpdated': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.synced.index,
      };
      await service.insertAvatar(avatarData);

      final updatedAvatar = Avatar(
        id: '4',
        localPath: '/new/path/to/avatar4.png',
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.synced,
      );

      final result = await service.updateAvatar(updatedAvatar);

      expect(result.localPath, equals('/new/path/to/avatar4.png'));

      final fetchedAvatar = await service.findById('4');
      expect(fetchedAvatar!.localPath, equals('/new/path/to/avatar4.png'));
    });

    test('deleteById should remove the avatar', () async {
      final avatarData = {
        'id': '5',
        'localPath': '/path/to/avatar5.png',
        'lastUpdated': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.synced.index,
      };
      await service.insertAvatar(avatarData);

      await service.deleteById('5');

      final result = await service.findById('5');
      expect(result, isNull);
    });

    test('insertAvatar should overwrite existing avatar with same id', () async {
      final avatarData1 = {
        'id': '6',
        'localPath': '/path/to/avatar6.png',
        'lastUpdated': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.synced.index,
      };
      await service.insertAvatar(avatarData1);

      final avatarData2 = {
        'id': '6',
        'localPath': '/path/to/new_avatar6.png',
        'lastUpdated': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.synced.index,
      };
      final result = await service.insertAvatar(avatarData2);

      expect(result.localPath, equals('/path/to/new_avatar6.png'));

      final fetchedAvatar = await service.findById('6');
      expect(fetchedAvatar!.localPath, equals('/path/to/new_avatar6.png'));
    });
  });
}
