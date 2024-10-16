import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/services/fake_athletes_service.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_generator_service.dart';

part 'athletes_service_provider.g.dart';

@Riverpod(keepAlive: true)
AthletesService athletesService(AthletesServiceRef ref) {
  final sportsService = ref.watch(sportsServiceProvider);
  final avatarGenerationService = FakeAvatarGeneratorService();
  final avatarRepository = ref.watch(avatarRepositoryProvider);
  final service = FakeAthletesService(
      sportsService, avatarGenerationService, avatarRepository);

  Future.microtask(() {
    service.initializeDatabase();
  });

  return service;
}
