import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/repositories/groups_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_roles_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/id_generator_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

part 'groups_provider.g.dart';

@Riverpod(keepAlive: true)
Groups groups(GroupsRef ref) {
  final groupsService = ref.watch(groupsServiceProvider);
  final logger = ref.watch(loggerProvider);
  final idGenerator = ref.watch(idGeneratorProvider);
  final groupRoles = ref.watch(groupRolesProvider);

  return GroupsImpl(
    groupsService,
    logger,
    idGenerator,
    groupRoles,
  );
}
