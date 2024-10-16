import 'package:coach_app/features/auth/presentation/providers/auth_status_use_case_provider.dart';
import 'package:coach_app/features/auth/presentation/providers/login_use_case_provider.dart';
import 'package:coach_app/features/auth/presentation/providers/logout_use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/auth/presentation/providers/auth_state.dart';

part 'auth_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    Future.microtask(() => _checkAuthStatus());
    return AuthState.initial();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isLoggedIn = await ref.read(authStatusUseCaseProvider).execute();
      state = state.copyWith(isLoggedIn: isLoggedIn, isLoading: false);
    } catch (e) {
      state = state.copyWith(
          isLoggedIn: false, isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String username, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final isLoggedIn =
          await ref.read(loginUseCaseProvider).execute(username, password);
      state = state.copyWith(isLoggedIn: isLoggedIn, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoggedIn: false,
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await ref.read(logoutUseCaseProvider).execute();
      state = state.copyWith(isLoggedIn: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
