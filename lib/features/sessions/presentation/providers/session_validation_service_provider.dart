import 'package:coach_app/features/athletes/infrastructure/adapters/form_validators_adapter.dart';
import 'package:coach_app/features/sessions/infrastructure/services/session_validation_service_impl.dart';
import 'package:domain/features/sessions/services/session_validation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_validation_service_provider.g.dart';

@riverpod
SessionValidationService sessionValidationService(
    SessionValidationServiceRef ref) {
  return SessionValidationServiceImpl(FormValidatorsAdapter());
}
