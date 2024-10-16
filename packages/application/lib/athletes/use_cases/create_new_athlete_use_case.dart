import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:domain/features/athletes/services/athlete_validation_service.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';

class CreateNewAthleteUseCase {
  final Athletes _repository;
  final Sports _sportsRepository;
  final AvatarRepository _avatarsRepository;
  final AthleteValidationService _validationService;

  CreateNewAthleteUseCase(
      this._repository, this._sportsRepository, this._validationService, this._avatarsRepository);

  Future<Result<Athlete>> execute(Map<String, dynamic> athleteData, List<String> sportIds, ImageData? avatar) async {
    final validationResult =
        _validationService.validateAthleteData(athleteData);
    if (!validationResult.isValid) {
      return Result.failure(validationResult.errors.first.message);
    }

    // Fetch sports using the provided sportIds
    final sportsResult = await _sportsRepository.getSportsByIds(sportIds);
    if (sportsResult.isFailure) {
      return Result.failure(sportsResult.error ?? 'Failed to fetch sports');
    }

    // Create the athlete with the fetched sports
    final athlete = Athlete.fromJson({
      ...athleteData,
      'sports': sportsResult.value,
    });

    // Add the athlete to the repository
    final addResult = await _repository.addAthlete(athlete);
    if (addResult.isFailure) {
      return Result.failure(addResult.error ?? 'Failed to add athlete');
    }

    final createdAthlete = addResult.value!;

    // Upload the avatar if provided
    if (avatar != null) {
      final avatarResult = await _avatarsRepository.saveAvatar(createdAthlete.id, avatar);
      
      // Update the athlete with the new avatar ID
      final updatedAthlete = createdAthlete.copyWith(avatarId: avatarResult.id);
      final updateResult = await _repository.updateAthlete(updatedAthlete);
      if (updateResult.isFailure) {
        return Result.failure('Athlete created but failed to update with avatar: ${updateResult.error}');
      }
      
      return Result.success(updatedAthlete);
    }
      

    return Result.success(createdAthlete);
  }
}
