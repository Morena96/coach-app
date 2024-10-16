import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/providers/get_all_sports_by_page_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_view_model.dart';

final sportsViewModelProvider =
    StateNotifierProvider.autoDispose<SportsViewModel, AsyncValue<void>>((ref) {
  ref.keepAlive();

  final getAllSportsByPageUseCase =
      ref.watch(getAllSportsByPageUseCaseProvider);

  return SportsViewModel(getAllSportsByPageUseCase);
});
