import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_database_service.dart';
import 'package:collection/collection.dart';

class InMemoryAvatarDatabaseService implements AvatarDatabaseService {
  final Map<String, Avatar> _avatars = {};

  InMemoryAvatarDatabaseService();

  @override
  Future<void> deleteById(String id) async {
    _avatars.remove(id);
  }

  @override
  Future<Avatar?> findById(String id) async {
    return _avatars[id];
  }

  @override
  Future<Avatar?> findAvatarByPath(String path) async {
    return _avatars.values.firstWhereOrNull(
      (avatar) => avatar.localPath == path,
    );
  }

  @override
  Future<Avatar> insertAvatar(Map<String, dynamic> data) async {
    final avatar = Avatar.fromJson(data);
    _avatars[avatar.id] = avatar;
    return avatar;
  }

  @override
  Future<Avatar> updateAvatar(Avatar avatar) async {
    _avatars[avatar.id] = avatar;
    return avatar;
  }
}
