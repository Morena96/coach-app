import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/sessions/infrastructure/repositories/sessions_repository_impl.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_data_service_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

part 'sessions_repository_provider.g.dart';

@Riverpod(keepAlive: true)
SessionsRepository sessionsRepository(SessionsRepositoryRef ref) {
  final sessionsService = ref.watch(sessionsDataServiceProvider);
  final logger = ref.watch(loggerProvider);
  return SessionsRepositoryImpl(sessionsService, logger);
}
