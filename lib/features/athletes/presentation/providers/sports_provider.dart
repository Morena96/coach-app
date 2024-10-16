import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/repositories/sports_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

part 'sports_provider.g.dart';

@riverpod
Sports sports(SportsRef ref) {
  final sportsService = ref.watch(sportsServiceProvider);
  final logger = ref.watch(loggerProvider);
  return SportsImpl(sportsService, logger);
}
