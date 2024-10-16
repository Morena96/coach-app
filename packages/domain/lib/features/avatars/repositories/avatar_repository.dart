import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/image_data.dart';

abstract class AvatarRepository {
  Future<Avatar> saveAvatar(String id, ImageData imageData);

  Future<ImageData?> getAvatarImage(String avatarId);

  Future<void> downloadAvatar(String avatarId, String remoteUrl);

  Future<void> markAvatarAsSynced(Avatar avatar);

  Future<Avatar> getAvatar(String avatarId);
}
