import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isLoggedIn;
  final bool isLoading;
  final String? error;

  const AuthState({
    required this.isLoggedIn,
    required this.isLoading,
    this.error,
  });

  factory AuthState.initial() =>
      const AuthState(isLoggedIn: false, isLoading: false);

  AuthState copyWith({bool? isLoggedIn, bool? isLoading, String? error}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'AuthState(isLoggedIn: $isLoggedIn, isLoading: $isLoading, error: $error)';

  @override
  List<Object?> get props => [isLoggedIn, isLoading, error];
}
