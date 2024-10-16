import 'package:application/sessions/use_cases/get_session_by_id_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/sessions/presentation/providers/sessions_repository_provider.dart';

part 'get_session_by_id_use_case_provider.g.dart';

/// Riverpod provider for the GetSessionByIdUseCase
@riverpod
GetSessionByIdUseCase getSessionByIdUseCase(GetSessionByIdUseCaseRef ref) {
  /// Watches the sessionsRepository provider
  final sessionsRepository = ref.watch(sessionsRepositoryProvider);

  /// Returns a new instance of GetSessionByIdUseCase
  return GetSessionByIdUseCase(sessionsRepository);
}
