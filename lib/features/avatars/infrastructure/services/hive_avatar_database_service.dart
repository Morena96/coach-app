import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/hive_avatar.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_database_service.dart';
import 'package:collection/collection.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveAvatarDatabaseService implements AvatarDatabaseService {
  late Box<HiveAvatar> box;

  HiveAvatarDatabaseService(this.box);

  @override
  Future<void> deleteById(String id) {
    return box.delete(id);
  }

  @override
  Future<Avatar?> findById(String id) async {
    var hiveAvatar = box.get(id);
    if (hiveAvatar != null) {
      return hiveAvatar.toDomain();
    }
    return null;
  }

  @override
  Future<Avatar?> findAvatarByPath(String path) async {
    var hiveAvatar =
        box.values.firstWhereOrNull((element) => element.localPath == path);

    if (hiveAvatar != null) {
      return hiveAvatar.toDomain();
    }

    return null;
  }

  @override
  Future<Avatar> insertAvatar(Map<String, dynamic> data) async {
    var avatar = Avatar.fromJson(data);
    var hiveAvatar = HiveAvatar.fromDomain(avatar);
    await box.put(data['id'], hiveAvatar);
    return avatar;
  }

  @override
  Future<Avatar> updateAvatar(Avatar avatar) async {
    await box.put(avatar.id, HiveAvatar.fromDomain(avatar));
    return avatar;
  }
}

