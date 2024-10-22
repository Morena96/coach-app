import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/services/fake_groups_service.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_generator_service.dart';

part 'groups_service_provider.g.dart';

/// Provides a singleton instance of GroupsService for the entire app.
@Riverpod(keepAlive: true)
GroupsService groupsService(GroupsServiceRef ref) {
  /// Service for generating fake avatars
  final avatarGenerationService = FakeAvatarGeneratorService();

  /// Repository for managing avatars
  final avatarRepository = ref.watch(avatarRepositoryProvider);

  /// Service for managing sports-related data
  final sportsService = ref.watch(sportsServiceProvider);

  /// Initialize the GroupsService with required dependencies
  final service = FakeGroupsService(
    avatarGenerationService,
    avatarRepository,
    sportsService,
  );

  /// Initialize the database asynchronously
  Future.microtask(() async {
    await service.initializeDatabase();
  });

  return service;
}
