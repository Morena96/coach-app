import 'package:application/sessions/use_cases/update_session_use_case.dart';
import 'package:coach_app/features/sessions/presentation/providers/session_validation_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/sessions/presentation/providers/sessions_repository_provider.dart';

part 'update_session_use_case_provider.g.dart';

@riverpod
UpdateSessionUseCase updateSessionUseCase(UpdateSessionUseCaseRef ref) {
  final sessionsRepository = ref.watch(sessionsRepositoryProvider);
  final sessionsValidationService = ref.watch(sessionValidationServiceProvider);
  return UpdateSessionUseCase(sessionsRepository, sessionsValidationService);
}
