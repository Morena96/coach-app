import 'package:application/athletes/use_cases/update_athlete_use_case.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/services/athlete_validation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/athlete_validation_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';

part 'update_athlete_use_case_provider.g.dart';

@riverpod
UpdateAthleteUseCase updateAthleteUseCase(UpdateAthleteUseCaseRef ref) {
  final Athletes athletes = ref.watch(athletesProvider);
  final AthleteValidationService validationService =
      ref.watch(athleteValidationServiceProvider);
  final avatarRepository = ref.watch(avatarRepositoryProvider);

  return UpdateAthleteUseCase(athletes, validationService, avatarRepository);
}
