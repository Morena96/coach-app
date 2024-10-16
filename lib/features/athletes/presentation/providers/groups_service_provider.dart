import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/services/fake_groups_service.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_generator_service.dart';

part 'groups_service_provider.g.dart';

@Riverpod(keepAlive: true)
GroupsService groupsService(GroupsServiceRef ref) {
  final avatarGenerationService = FakeAvatarGeneratorService();
  final avatarRepository = ref.watch(avatarRepositoryProvider);
  final sportsService = ref.watch(sportsServiceProvider);
  return FakeGroupsService(
    avatarGenerationService,
    avatarRepository,
    sportsService,
  );
}
