
import 'package:domain/features/auth/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;
  LoginUseCase(this._authRepository);
  Future<bool> execute(String username, String password) =>
      _authRepository.login(username, password);
}
