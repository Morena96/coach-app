import 'dart:io';

import 'package:application/avatars/image_data_factory.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';

class UploadAvatarUseCase {
  final AvatarRepository _avatarRepository;
  final ImageDataFactory _imageDataFactory;

  UploadAvatarUseCase(this._avatarRepository, this._imageDataFactory);

  Future<Avatar> execute(String userId, File imageFile) async {
    if (!imageFile.existsSync()) {
      throw Exception('Image file does not exist');
    }

    final ImageData imageData = _imageDataFactory.createFromFile(imageFile);

    try {
      return await _avatarRepository.saveAvatar(userId, imageData);
    } catch (e) {
      throw Exception('Failed to upload avatar: ${e.toString()}');
    }
  }
}
