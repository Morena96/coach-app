import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetSessionByIdUseCase {
  final SessionsRepository _sessionsRepository;

  GetSessionByIdUseCase(this._sessionsRepository);

  Future<Result<Session?>> execute(String id) async {
    return await _sessionsRepository.getSessionById(id);
  }
}
