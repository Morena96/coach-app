import 'package:coach_app/features/athletes/infrastructure/services/in_memory_group_roles_service.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InMemoryGroupRolesService service;

  setUp(() {
    service = InMemoryGroupRolesService();
  });

  group('InMemoryGroupRolesService', () {
    test('getAllRoles returns all predefined roles', () async {
      final roles = await service.getAllRoles();
      expect(roles.length, 5);
      expect(
          roles,
          containsAll([
            GroupRole.coach,
            GroupRole.athlete,
            GroupRole.trainer,
            GroupRole.familyMember,
            GroupRole.other
          ]));
    });

    test('getRoleByName returns correct role for valid name', () async {
      final role = await service.getRoleByName('coach');
      expect(role, GroupRole.coach);
    });
  });
}
