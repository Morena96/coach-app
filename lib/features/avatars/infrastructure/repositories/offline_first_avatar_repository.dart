import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/images/services/image_format_service.dart';
import 'package:path/path.dart' as path;

import 'package:coach_app/features/avatars/infrastructure/models/memory_image_data.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_database_service.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/file_system.dart';

class OfflineFirstAvatarRepository implements AvatarRepository {
  final AvatarDatabaseService db;
  final Directory localStorageDir;
  final Dio _dio;
  final FileSystemService fileSystem;
  final ImageFormatService imageFormatService;

  OfflineFirstAvatarRepository(
      this.db, this.localStorageDir, this._dio, this.fileSystem, this.imageFormatService);

  @override
  Future<Avatar> saveAvatar(String id, ImageData imageData) async {
    final String localPath = await _saveImageLocally(id, imageData);

    final avatarMap = {
      'id': id,
      'localPath': localPath,
      'lastUpdated': DateTime.now().toIso8601String(),
      'syncStatus': SyncStatus.pendingUpload.index,
    };

    var avatar = await db.insertAvatar(avatarMap);

    return avatar;
  }

  @override
  Future<ImageData?> getAvatarImage(String avatarId) async {
    final avatar = await db.findById(avatarId);

    if (avatar != null) {
      if (await fileSystem.exists(avatar.localPath)) {
        return MemoryImageData(await fileSystem.read(avatar.localPath));
      } else {
      }
    }
    return null;
  }

  @override
  Future<void> downloadAvatar(String avatarId, String remoteUrl) async {
    final response = await _dio.get(remoteUrl,
        options: Options(responseType: ResponseType.bytes));
    if (response.statusCode == 200) {
      final imageData = MemoryImageData(response.data);
      final String localPath = await _saveImageLocally(avatarId, imageData);
      await db.insertAvatar({
        'id': avatarId,
        'localPath': localPath,
        'lastUpdated': DateTime.now().toIso8601String(),
        'syncStatus': SyncStatus.synced.index,
      });
    } else {
      throw Exception('Failed to download avatar');
    }
  }

  @override
  Future<void> markAvatarAsSynced(Avatar avatar) async {
    await db.updateAvatar(avatar.copyWith(syncStatus: SyncStatus.synced));
  }

  Future<String> _saveImageLocally(String id, ImageData imageData) async {
    final bytes = Uint8List.fromList(imageData.getBytes());
    final fileExtension = imageFormatService.getFileExtension(bytes);
    final String localPath =
        path.join(localStorageDir.path, 'avatars', '$id.$fileExtension');

    return fileSystem.write(localPath, bytes);
  }

  @override
  Future<Avatar> getAvatar(String avatarId) async {
    var avatar = await db.findById(avatarId);

    if (avatar == null) {
      throw Exception('Avatar not found');
    }

    return avatar;
  }
}