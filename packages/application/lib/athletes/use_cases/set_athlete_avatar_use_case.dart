import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/logging/repositories/logger.dart';

class SetAthleteAvatarUseCase {
  final Athletes _athleteRepository;
  final AvatarRepository _avatarRepository;
  final LoggerRepository _logger;

  SetAthleteAvatarUseCase(
      this._athleteRepository, this._avatarRepository, this._logger);

  Future<void> execute(String athleteId, ImageData avatarImage) async {
    try {
      final athlete = await _getAthlete(athleteId);
      final avatar = await _saveAvatar(athleteId, avatarImage);
      await _updateAthleteWithAvatar(athlete, avatar.id);
    } catch (e, stackTrace) {
      _logger.error('Failed to set athlete avatar', e, stackTrace);
      rethrow;
    }
  }

  Future<Athlete> _getAthlete(String athleteId) async {
    final result = await _athleteRepository.getAthleteById(athleteId);
    if (result.isFailure) {
      throw AthleteNotFoundException('Failed to get athlete: ${result.error}');
    }
    if (result.value == null) {
      throw AthleteNotFoundException('Athlete not found');
    }
    return result.value!;
  }

  Future<Avatar> _saveAvatar(String athleteId, ImageData avatarImage) async {
    _logger.info('Saving avatar');
    final avatar = await _avatarRepository.saveAvatar(athleteId, avatarImage);
    _logger.info('Saved avatar');
    return avatar;
  }

  Future<void> _updateAthleteWithAvatar(
      Athlete athlete, String avatarId) async {
    final updatedAthlete = athlete.copyWith(avatarId: avatarId);
    final result = await _athleteRepository.updateAthlete(updatedAthlete);
    if (result.isFailure) {
      throw AthleteUpdateException('Failed to update athlete: ${result.error}');
    }
  }
}

class AthleteNotFoundException implements Exception {
  final String message;

  AthleteNotFoundException(this.message);

  @override
  String toString() => 'AthleteNotFoundException: $message';
}

class AthleteUpdateException implements Exception {
  final String message;

  AthleteUpdateException(this.message);

  @override
  String toString() => 'AthleteUpdateException: $message';
}
