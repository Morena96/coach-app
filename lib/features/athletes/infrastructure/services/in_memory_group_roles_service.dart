import 'package:domain/features/athletes/data/group_roles_service.dart';
import 'package:domain/features/athletes/entities/group_role.dart';

class InMemoryGroupRolesService implements GroupRolesService {
  final List<GroupRole> _roles = [
    GroupRole.coach,
    GroupRole.athlete,
    GroupRole.trainer,
    GroupRole.familyMember,
    GroupRole.other
  ];

  @override
  Future<List<GroupRole>> getAllRoles() async {
    return _roles;
  }

  @override
  Future<GroupRole?> getRoleByName(String name) async {
    return _roles.firstWhere((role) => role.name == name);
  }
}
