import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/athletes/services/group_validation_service.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';

class UpdateGroupUseCase {
  final Groups _repository;
  final GroupValidationService _validationService;
  final AvatarRepository _avatarsRepository;

  UpdateGroupUseCase(
      this._repository, this._validationService, this._avatarsRepository);

  Future<Result<void>> execute(
    Group group,
    Map<String, dynamic> groupData,
    ImageData? avatar,
  ) async {
    Group updatedGroup = group;

    // await _groupRepository.updateGroup(group);
    final validationResult = _validationService.validateGroupData(groupData);
    if (!validationResult.isValid) {
      return Result.failure(
        validationResult.errors.map((e) => e.message).join('; '),
      );
    }

    // Upload the avatar if provided
    if (avatar != null) {
      final avatarResult =
          await _avatarsRepository.saveAvatar(group.id, avatar);

      // Update the athlete with the new avatar ID
      updatedGroup = group.copyWith(avatarId: avatarResult.id);
      final updateResult = await _repository.updateGroup(updatedGroup);
      if (updateResult.isFailure) {
        return Result.failure(
          'Athlete created but failed to update with avatar: ${updateResult.error}',
        );
      }
      return Result.success(null);
    }

    return await _repository.updateGroup(updatedGroup);
  }
}
