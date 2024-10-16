import 'package:domain/features/auth/repositories/auth_repository.dart';

class AuthStatusUseCase {
  final AuthRepository _authRepository;

  AuthStatusUseCase(this._authRepository);

  Future<bool> execute() => _authRepository.isLoggedIn();
}
