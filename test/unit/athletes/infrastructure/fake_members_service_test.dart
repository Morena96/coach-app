import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/group_roles_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/infrastructure/services/fake_members_service_impl.dart';

@GenerateMocks([AthletesService, GroupsService, GroupRolesService])
import 'fake_members_service_test.mocks.dart';

void main() {
  late FakeMembersServiceImpl fakeMembersService;
  late MockAthletesService mockAthletesService;
  late MockGroupsService mockGroupsService;
  late MockGroupRolesService mockGroupRolesService;

  setUp(() {
    mockAthletesService = MockAthletesService();
    mockGroupsService = MockGroupsService();
    mockGroupRolesService = MockGroupRolesService();

    when(mockAthletesService.getAllAthletes()).thenAnswer((_) async => [
          const Athlete(id: 'athlete1', name: 'Athlete 1'),
          const Athlete(id: 'athlete2', name: 'Athlete 2'),
          const Athlete(id: 'athlete3', name: 'Athlete 3'),
        ]);
    when(mockGroupsService.getAllGroups()).thenAnswer((_) async => [
          const Group(id: 'group1', name: 'Group 1'),
          const Group(id: 'group2', name: 'Group 2'),
        ]);
    when(mockGroupRolesService.getAllRoles())
        .thenAnswer((_) async => [GroupRole.athlete, GroupRole.coach]);

    fakeMembersService = FakeMembersServiceImpl(
      mockAthletesService,
      mockGroupsService,
      mockGroupRolesService,
    );
  });
  group('FakeMembersServiceImpl', () {
    test('getMembersForGroup returns correct members', () async {
      final members = await fakeMembersService.getMembersForGroup('group1');
      expect(members, isA<List<Member>>());
    });

    test('getMemberByAthleteAndGroup returns correct member', () async {
      final member = await fakeMembersService.getMemberByAthleteAndGroup(
          'athlete1', 'group1');
      expect(member, isA<Member?>());
    });

    test('addMemberToGroup adds a new member', () async {
      final newMember = await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      expect(newMember, isA<Member>());
      expect(newMember.athleteId, equals('athlete1'));
      expect(newMember.groupId, equals('group1'));
      expect(newMember.role, equals(GroupRole.athlete));
    });

    test('updateMemberRole updates role correctly', () async {
      final newMember = await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      final updatedMember = await fakeMembersService.updateMemberRole(
          newMember.id, GroupRole.coach);
      expect(updatedMember.role, equals(GroupRole.coach));
    });

    test('removeMemberFromGroup removes member', () async {
      await fakeMembersService.removeMembersFromGroup('group1', '*');
      final newMember = await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      await fakeMembersService.removeMembersFromGroup('group1', newMember.id);
      final members = await fakeMembersService.getMembersForGroup('group1');
      expect(members.length, 0);
    });

    test('getGroupsForAthlete returns correct groups', () async {
      await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      await fakeMembersService.addMemberToGroup(
          'athlete1', 'group2', GroupRole.coach);
      final groups = await fakeMembersService.getGroupsForAthlete('athlete1');
      expect(groups.length, equals(2));
    });

    test('isAthleteMemberOfGroup returns correct boolean', () async {
      await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      final isMember =
          await fakeMembersService.isAthleteMemberOfGroup('athlete1', 'group1');
      expect(isMember, isTrue);
    });

    test('getMemberCountForGroup returns correct count', () async {
      await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      await fakeMembersService.addMemberToGroup(
          'athlete2', 'group1', GroupRole.coach);
      final count = await fakeMembersService.getMemberCountForGroup('group1');
      expect(count, equals(2));
    });

    test('getMembersForGroupPaginated returns correct page', () async {
      await fakeMembersService.removeMembersFromGroup('group1', '*');
      for (int i = 0; i < 15; i++) {
        await fakeMembersService.addMemberToGroup(
            'athlete$i', 'group1', GroupRole.athlete);
      }
      final page1 =
          await fakeMembersService.getMembersForGroupPaginated('group1', 0, 10);
      expect(page1.length, equals(10));
      final page2 =
          await fakeMembersService.getMembersForGroupPaginated('group1', 1, 10);
      expect(page2.length, equals(5));
    });

    test('searchMembersInGroup returns correct members', () async {
      when(mockAthletesService.getAllAthletes()).thenAnswer((_) async => [
            const Athlete(id: 'athlete1', name: 'John Doe'),
            const Athlete(id: 'athlete2', name: 'Jane Smith'),
          ]);
      await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      await fakeMembersService.addMemberToGroup(
          'athlete2', 'group1', GroupRole.coach);
      final searchResults =
          await fakeMembersService.searchMembersInGroup('group1', 'John');
      expect(searchResults.length, equals(1));
      expect(searchResults.first.athleteId, equals('athlete1'));
    });

    test('batchAddMembersToGroup adds multiple members', () async {
      final initialLength =
          (await fakeMembersService.getMembersForGroup('group1')).length;

      final athleteIds = ['athlete1', 'athlete2', 'athlete3'];
      final newMembers = await fakeMembersService.batchAddMembersToGroup(
          'group1', athleteIds, GroupRole.athlete);

      expect(newMembers.length, equals(3));
      for (final member in newMembers) {
        expect(member.groupId, equals('group1'));
        expect(member.role, equals(GroupRole.athlete));
        expect(athleteIds.contains(member.athleteId), isTrue);
      }

      final groupMembers =
          await fakeMembersService.getMembersForGroup('group1');
      expect(groupMembers.length - initialLength, equals(3));
    });

    test('batchRemoveMembersFromGroup removes multiple members', () async {
      final initialLength =
          (await fakeMembersService.getMembersForGroup('group1')).length;

      final member1 = await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      final member2 = await fakeMembersService.addMemberToGroup(
          'athlete2', 'group1', GroupRole.athlete);
      final member3 = await fakeMembersService.addMemberToGroup(
          'athlete3', 'group1', GroupRole.athlete);

      await fakeMembersService
          .batchRemoveMembersFromGroup('group1', [member1.id, member2.id]);

      final remainingMembers =
          await fakeMembersService.getMembersForGroup('group1');
      expect(remainingMembers.length - initialLength, equals(1));
      expect(
          remainingMembers.map((e) => e.id).contains(member3.id), equals(true));
    });

    test('batchAddMembersToGroup handles empty list', () async {
      final newMembers = await fakeMembersService.batchAddMembersToGroup(
          'group1', [], GroupRole.athlete);
      expect(newMembers, isEmpty);
    });

    test('batchRemoveMembersFromGroup handles non-existent members', () async {
      final initialLength =
          (await fakeMembersService.getMembersForGroup('group1')).length;

      await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);
      await fakeMembersService
          .batchRemoveMembersFromGroup('group1', ['non-existent-id']);

      final remainingMembers =
          await fakeMembersService.getMembersForGroup('group1');
      expect(remainingMembers.length - initialLength, equals(1));
    });

    test('returns all false for non-existent group', () async {
      final athleteIds = ['athlete1', 'athlete2'];
      const groupId = 'non_existent_group';

      final result = await fakeMembersService.areAthletesMembersOfGroup(
          athleteIds, groupId);

      expect(result, {
        'athlete1': false,
        'athlete2': false,
      });
    });

    test('returns empty map for empty athlete list', () async {
      final athleteIds = <String>[];
      const groupId = 'group1';

      final result = await fakeMembersService.areAthletesMembersOfGroup(
          athleteIds, groupId);

      expect(result, isEmpty);
    });

    test('handles non-existent athletes correctly', () async {
      await fakeMembersService.addMemberToGroup(
          'athlete1', 'group1', GroupRole.athlete);

      final athleteIds = ['athlete1', 'non_existent_athlete'];
      const groupId = 'group1';

      final result = await fakeMembersService.areAthletesMembersOfGroup(
          athleteIds, groupId);

      expect(result, {
        'athlete1': true,
        'non_existent_athlete': false,
      });
    });

    group('getGroupsForAthletes', () {
      test('returns correct groups for multiple athletes', () async {
        await fakeMembersService.addMemberToGroup(
            'athlete1', 'group1', GroupRole.athlete);
        await fakeMembersService.addMemberToGroup(
            'athlete1', 'group2', GroupRole.coach);
        await fakeMembersService.addMemberToGroup(
            'athlete2', 'group1', GroupRole.athlete);

        final result = await fakeMembersService
            .getGroupsForAthletes(['athlete1', 'athlete2']);

        expect(result.keys, containsAll(['athlete1', 'athlete2']));
        expect(result['athlete1']!.length, 2);
        expect(result['athlete2']!.length, 1);
        expect(
            result['athlete1']!.any(
                (m) => m.groupId == 'group1' && m.role == GroupRole.athlete),
            isTrue);
        expect(
            result['athlete1']!
                .any((m) => m.groupId == 'group2' && m.role == GroupRole.coach),
            isTrue);
        expect(
            result['athlete2']!.any(
                (m) => m.groupId == 'group1' && m.role == GroupRole.athlete),
            isTrue);
      });

      test('returns empty list for athlete with no groups', () async {
        await fakeMembersService.addMemberToGroup(
            'athlete1', 'group1', GroupRole.athlete);

        final result = await fakeMembersService
            .getGroupsForAthletes(['athlete1', 'athlete2']);

        expect(result.keys, containsAll(['athlete1']));
        expect(result['athlete1']!.length, 1);
        expect(result['athlete2'], isNull);
      });

      test('returns empty map for non-existent athletes', () async {
        final result = await fakeMembersService
            .getGroupsForAthletes(['non_existent_athlete']);

        expect(result, isEmpty);
      });

      test('returns empty map for empty athlete list', () async {
        final result = await fakeMembersService.getGroupsForAthletes([]);

        expect(result, isEmpty);
      });
    });
  });
}
