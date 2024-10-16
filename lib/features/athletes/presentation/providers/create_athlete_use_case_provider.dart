import 'package:coach_app/features/athletes/presentation/providers/athlete_validation_service_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:application/athletes/use_cases/create_new_athlete_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_provider.dart';

part 'create_athlete_use_case_provider.g.dart';

@riverpod
CreateNewAthleteUseCase createNewAthleteUseCase(CreateNewAthleteUseCaseRef ref) {
  final athletes = ref.watch(athletesProvider);
  final sports = ref.watch(sportsProvider);
  final validationService = ref.watch(athleteValidationServiceProvider);
  final avatarRepository = ref.watch(avatarRepositoryProvider);
  
  return CreateNewAthleteUseCase(
    athletes,
    sports,
    validationService,
    avatarRepository,
  );
}
