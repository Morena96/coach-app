import 'package:domain/features/avatars/entities/avatar.dart';

abstract class AvatarDatabaseService {
  Future<Avatar> insertAvatar(Map<String, dynamic> data);

  Future<Avatar?> findAvatarByPath(String path);

  Future<Avatar> updateAvatar(Avatar avatar);

  Future<void> deleteById(String id);

  Future<Avatar?> findById(String id);
}
