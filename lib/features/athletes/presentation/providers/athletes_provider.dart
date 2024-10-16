import 'package:coach_app/features/athletes/presentation/providers/members_service_provider.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/repositories/athletes_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

part 'athletes_provider.g.dart';

@Riverpod(keepAlive: true)
Athletes athletes(AthletesRef ref) {
  final athletesService = ref.watch(athletesServiceProvider);
  final membersService = ref.watch(membersServiceProvider);
  final logger = ref.watch(loggerProvider);
  return AthletesImpl(athletesService, logger, membersService);
}
