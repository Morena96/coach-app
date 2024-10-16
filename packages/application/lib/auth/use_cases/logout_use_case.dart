
import 'package:domain/features/auth/repositories/auth_repository.dart';

class LogoutUseCase {
  final AuthRepository _authRepository;
  LogoutUseCase(this._authRepository);
  Future<void> execute() => _authRepository.logout();
}
