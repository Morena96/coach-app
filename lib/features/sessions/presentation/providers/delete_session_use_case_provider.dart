import 'package:application/sessions/use_cases/delete_session_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/sessions/presentation/providers/sessions_repository_provider.dart';

part 'delete_session_use_case_provider.g.dart';

@riverpod
DeleteSessionUseCase deleteSessionUseCase(DeleteSessionUseCaseRef ref) {
  final sessionsRepository = ref.watch(sessionsRepositoryProvider);
  return DeleteSessionUseCase(sessionsRepository);
}
