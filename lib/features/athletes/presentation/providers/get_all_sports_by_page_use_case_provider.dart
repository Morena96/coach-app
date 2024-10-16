import 'package:application/athletes/use_cases/get_all_sports_by_page_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/providers/sports_provider.dart';

part 'get_all_sports_by_page_use_case_provider.g.dart';

@riverpod
GetAllSportsByPageUseCase getAllSportsByPageUseCase(
    GetAllSportsByPageUseCaseRef ref) {
  final sports = ref.watch(sportsProvider);
  return GetAllSportsByPageUseCase(sports);
}
