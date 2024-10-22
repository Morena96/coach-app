import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/sessions/services/session_validation_service.dart';
import 'package:domain/features/shared/utilities/result.dart';

class UpdateSessionUseCase {
  final SessionsRepository _sessionsRepository;
  final SessionValidationService _validationService;

  UpdateSessionUseCase(this._sessionsRepository, this._validationService);

  Future<Result<void>> execute(
      Session session, Map<String, dynamic> sessionData) async {
    final validationResult =
        _validationService.validateSessionData(sessionData);
    print(sessionData);
    print(validationResult);

    if (!validationResult.isValid) {
      return Result.failure(validationResult.errors.first.message);
    }

    return await _sessionsRepository.updateSession(session);
  }
}
