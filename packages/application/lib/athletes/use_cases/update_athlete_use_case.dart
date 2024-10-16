import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/services/athlete_validation_service.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';

class UpdateAthleteUseCase {
  final Athletes _repository;
  final AthleteValidationService _validationService;
  final AvatarRepository _avatarsRepository;

  UpdateAthleteUseCase(
      this._repository, this._validationService, this._avatarsRepository);

  Future<Result<void>> execute(Athlete athlete,
      Map<String, dynamic> athleteData, ImageData? avatar) async {
    final validationResult = 
        _validationService.validateAthleteData(athleteData);
    if (!validationResult.isValid) {
      return Result.failure(validationResult.errors.first.message);
    }

    // Upload the avatar if provided
    if (avatar != null) {
      final avatarResult =
          await _avatarsRepository.saveAvatar(athlete.id, avatar);

      // Update the athlete with the new avatar ID
      final updatedAthlete = athlete.copyWith(avatarId: avatarResult.id);
      final updateResult = await _repository.updateAthlete(updatedAthlete);
      if (updateResult.isFailure) {
        return Result.failure(
            'Athlete created but failed to update with avatar: ${updateResult.error}');
      }

      return Result.success(null);
    }

    return await _repository.updateAthlete(athlete.copyWith(
      name: athleteData['name'],
    ));
  }
}
