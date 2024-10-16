import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:application/athletes/use_cases/restore_athlete_use_case.dart';

part 'restore_athlete_use_case_provider.g.dart';

@riverpod
RestoreAthleteUseCase restoreAthleteUseCase(RestoreAthleteUseCaseRef ref) {
  final athletes = ref.watch(athletesProvider);
  return RestoreAthleteUseCase(athletes);
}
