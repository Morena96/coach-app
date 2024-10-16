import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:application/athletes/use_cases/get_athlete_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';

part 'get_athlete_by_id_use_case_provider.g.dart';

@riverpod
GetAthleteByIdUseCase getAthleteByIdUseCase(GetAthleteByIdUseCaseRef ref) {
  final athletes = ref.watch(athletesProvider);
  return GetAthleteByIdUseCase(athletes);
}
