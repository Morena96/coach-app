import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/athletes/services/group_validation_service.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';

class CreateGroupUseCase {
  final Groups _groupRepository;
  final AvatarRepository _avatarRepository;
  final GroupValidationService _validationService;

  CreateGroupUseCase(
    this._groupRepository,
    this._avatarRepository,
    this._validationService,
  );

  Future<Result<Group>> execute(
    Map<String, dynamic> groupData,
    String name,
    String? description,
    Sport? sport, {
    ImageData? avatarImage,
  }) async {
    final validationResult = _validationService.validateGroupData(groupData);
    if (!validationResult.isValid) {
      return Result.failure(
        validationResult.errors.map((e) => e.message).join('; '),
      );
    }

    var groupResult = await _groupRepository.createGroup(
      name,
      description,
      sport!,
    );

    if (groupResult.isFailure) {
      return Result.failure(groupResult.error);
    }

    Group group = groupResult.value!;

    if (avatarImage != null) {
      final avatarResult = await _saveAvatar(group.id, avatarImage);

      if (avatarResult.isFailure) {
        return Result.failure(avatarResult.error!);
      }

      group = group.copyWith(avatarId: avatarResult.value!.id);
      final updateResult = await _groupRepository.updateGroup(group);

      if (updateResult.isFailure) {
        return Result.failure(updateResult.error!);
      }

      return Result.success(group);
    }

    return groupResult;
  }

  Future<Result<Avatar>> _saveAvatar(
      String groupId, ImageData avatarImage) async {
    try {
      final avatar = await _avatarRepository.saveAvatar(groupId, avatarImage);
      return Result.success(avatar);
    } catch (e) {
      return Result.failure('Failed to save avatar: $e');
    }
  }
}
