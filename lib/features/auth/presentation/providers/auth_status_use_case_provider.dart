
import 'package:application/auth/use_cases/auth_status_use_case.dart';
import 'package:coach_app/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_status_use_case_provider.g.dart';

@riverpod
AuthStatusUseCase authStatusUseCase(AuthStatusUseCaseRef ref) =>
    AuthStatusUseCase(ref.watch(authRepositoryProvider));