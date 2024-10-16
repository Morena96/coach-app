import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:application/athletes/use_cases/set_athlete_avatar_use_case.dart';

part 'set_athlete_usecase_provider.g.dart';

@riverpod
SetAthleteAvatarUseCase setAthleteAvatarUseCase(
    SetAthleteAvatarUseCaseRef ref) {
  final athleteRepository = ref.watch(athletesProvider);
  final avatarRepository = ref.watch(avatarRepositoryProvider);
  final logger = ref.watch(loggerProvider);
  return SetAthleteAvatarUseCase(athleteRepository, avatarRepository, logger);
}
