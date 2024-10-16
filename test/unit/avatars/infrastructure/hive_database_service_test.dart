import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/hive_avatar.dart';
import 'package:coach_app/features/avatars/infrastructure/services/hive_avatar_database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Box<Avatar>])
import 'hive_database_service_test.mocks.dart';

void main() {
  late HiveAvatarDatabaseService hiveDatabaseService;
  late MockBox<HiveAvatar> mockBox;

  setUp(() {
    mockBox = MockBox();
    hiveDatabaseService = HiveAvatarDatabaseService(mockBox);
  });

  group('findById', () {
    test('returns avatar when found', () async {
      const avatarId = '123';
      final hiveAvatar = HiveAvatar(
        id: avatarId,
        localPath: '/path/to/avatar',
        lastUpdated: DateTime.now(),
        syncStatus: SyncStatus.synced.index,
      );
      final expectedAvatar = hiveAvatar.toDomain();

      when(mockBox.get(avatarId)).thenReturn(hiveAvatar);

      final result = await hiveDatabaseService.findById(avatarId);

      expect(result, equals(expectedAvatar));
      verify(mockBox.get(avatarId)).called(1);
    });

    test('returns null when avatar not found', () async {
      const avatarId = '456';

      when(mockBox.get(avatarId)).thenReturn(null);

      final result = await hiveDatabaseService.findById(avatarId);

      expect(result, isNull);
      verify(mockBox.get(avatarId)).called(1);
    });
  });

  group('HiveAvatarDatabaseService Tests', () {
    test('deleteById deletes avatar with given id', () async {
      const avatarId = '123';

      when(mockBox.delete(avatarId)).thenAnswer((_) async {});

      await hiveDatabaseService.deleteById(avatarId);

      verify(mockBox.delete(avatarId)).called(1);
    });

    test('findAvatarByPath returns avatar with given path', () async {
      const avatarPath = '/path/to/avatar';
      final avatar = Avatar(
          id: '123',
          localPath: avatarPath,
          lastUpdated: DateTime.now(),
          syncStatus: SyncStatus.synced);

      when(mockBox.values).thenReturn([HiveAvatar.fromDomain(avatar)]);

      final result = await hiveDatabaseService.findAvatarByPath(avatarPath);

      expect(result, equals(avatar));
    });

    test('insertAvatar inserts and returns new avatar', () async {
      final fixedDateTime = DateTime(2024, 8, 1);
      final avatarData = {
        'id': '123',
        'localPath': '/path/to/avatar',
        'lastUpdated': fixedDateTime.toIso8601String(),
        'syncStatus': SyncStatus.synced.index
      };
      final avatar = Avatar.fromJson(avatarData);
      final hiveAvatar = HiveAvatar.fromDomain(avatar);

      when(mockBox.put('123', hiveAvatar)).thenAnswer((_) async {});

      final result = await hiveDatabaseService.insertAvatar(avatarData);

      expect(result, equals(avatar));
      final captured = verify(mockBox.put('123', captureAny)).captured;
      expect(captured.single, isA<HiveAvatar>());
      final capturedHiveAvatar = captured.single as HiveAvatar;
      expect(capturedHiveAvatar.id, equals(hiveAvatar.id));
      expect(capturedHiveAvatar.localPath, equals(hiveAvatar.localPath));
      expect(capturedHiveAvatar.lastUpdated, equals(hiveAvatar.lastUpdated));
      expect(capturedHiveAvatar.syncStatus, equals(hiveAvatar.syncStatus));
    });

    test('updateAvatar updates and returns the avatar', () async {
      final avatar = Avatar(
          id: '123',
          localPath: 'path/to/avatar',
          lastUpdated: DateTime.now(),
          syncStatus: SyncStatus.synced);

      when(mockBox.put(avatar.id, HiveAvatar.fromDomain(avatar)))
          .thenAnswer((_) async {});

      final result = await hiveDatabaseService.updateAvatar(avatar);

      expect(result, equals(avatar));
      final captured = verify(mockBox.put(avatar.id, captureAny)).captured;
      final capturedHiveAvatar = captured.single as HiveAvatar;
      expect(capturedHiveAvatar.id, equals(avatar.id));
      expect(capturedHiveAvatar.localPath, equals(avatar.localPath));
      expect(capturedHiveAvatar.lastUpdated, equals(avatar.lastUpdated));
      expect(capturedHiveAvatar.syncStatus, equals(avatar.syncStatus.index));
    });
  });
}
