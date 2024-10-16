import 'package:domain/features/athletes/entities/group_role.dart';

abstract class GroupRolesService {
  /// Get all available group \roles
  Future<List<GroupRole>> getAllRoles();

  /// Get role by name
  ///
  /// @param name - name of the role
  /// @return role
  Future<GroupRole?> getRoleByName(String name);
}
