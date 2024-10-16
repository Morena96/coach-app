import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';

class UpdateSessionUseCase {
  final SessionsRepository _sessionsRepository;

  UpdateSessionUseCase(this._sessionsRepository);

  Future<Result<void>> execute(Session session) async {
    return await _sessionsRepository.updateSession(session);
  }
}
