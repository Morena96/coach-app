import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:application/athletes/use_cases/get_all_athletes_by_page_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';

part 'get_all_athletes_by_page_use_case_provider.g.dart';

@riverpod
GetAllAthletesByPageUseCase getAllAthletesByPageUseCase(GetAllAthletesByPageUseCaseRef ref) {
  final athletes = ref.watch(athletesProvider);
  return GetAllAthletesByPageUseCase(athletes);
}
