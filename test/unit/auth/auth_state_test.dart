import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/features/auth/presentation/providers/auth_state.dart';

void main() {
  group('AuthState', () {
    test('initial state should have isLoggedIn false and isLoading false', () {
      final initialState = AuthState.initial();
      expect(initialState.isLoggedIn, false);
      expect(initialState.isLoading, false);
      expect(initialState.error, null);
    });

    test('copyWith should only change specified fields', () {
      const initialState = AuthState(isLoggedIn: false, isLoading: false);
      final updatedState = initialState.copyWith(isLoggedIn: true);

      expect(updatedState.isLoggedIn, true);
      expect(updatedState.isLoading, false);
      expect(updatedState.error, null);
    });
  });
}
