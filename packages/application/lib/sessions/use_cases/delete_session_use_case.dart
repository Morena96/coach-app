import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';

class DeleteSessionUseCase {
  final SessionsRepository _sessionsRepository;

  DeleteSessionUseCase(this._sessionsRepository);

  Future<Result<void>> execute(String sessionId) async {
    return await _sessionsRepository.deleteSession(sessionId);
  }
}