
import 'package:application/auth/use_cases/logout_use_case.dart';
import 'package:coach_app/features/auth/data/repositories/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'logout_use_case_provider.g.dart';

@riverpod
LogoutUseCase logoutUseCase(LogoutUseCaseRef ref) =>
    LogoutUseCase(ref.watch(authRepositoryProvider));
