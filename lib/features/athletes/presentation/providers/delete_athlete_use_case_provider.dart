import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:application/athletes/use_cases/delete_athlete_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';

part 'delete_athlete_use_case_provider.g.dart';

@riverpod
DeleteAthleteUseCase deleteAthleteUseCase(DeleteAthleteUseCaseRef ref) {
  final athletes = ref.watch(athletesProvider);
  return DeleteAthleteUseCase(athletes);
}
