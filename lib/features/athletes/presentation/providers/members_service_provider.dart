import 'package:coach_app/features/athletes/infrastructure/services/fake_members_service_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_roles_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_service_provider.dart';
import 'package:domain/features/athletes/data/members_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'members_service_provider.g.dart';

@Riverpod(keepAlive: true)
MembersService membersService(MembersServiceRef ref) {
  final athletesService = ref.watch(athletesServiceProvider);
  final groupsService = ref.watch(groupsServiceProvider);
  final groupRolesService = ref.watch(groupRolesProvider);

  return FakeMembersServiceImpl(
    athletesService,
    groupsService,
    groupRolesService,
  );
}
