import 'package:application/sessions/use_cases/get_all_sessions_by_page_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/sessions/presentation/providers/sessions_repository_provider.dart';

part 'get_all_sessions_by_page_use_case_provider.g.dart';

@riverpod
GetAllSessionsByPageUseCase getAllSessionsByPageUseCase(
    GetAllSessionsByPageUseCaseRef ref) {
  final sessionsRepository = ref.watch(sessionsRepositoryProvider);
  return GetAllSessionsByPageUseCase(sessionsRepository);
}
