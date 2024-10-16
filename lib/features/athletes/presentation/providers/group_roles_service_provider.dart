import 'package:domain/features/athletes/data/group_roles_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/services/in_memory_group_roles_service.dart';

part 'group_roles_service_provider.g.dart';

@Riverpod(keepAlive: true)
GroupRolesService groupRoles(GroupRolesRef ref) {
  return InMemoryGroupRolesService();
}
