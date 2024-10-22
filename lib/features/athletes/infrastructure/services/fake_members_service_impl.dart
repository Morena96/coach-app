import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/group_roles_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/members_service.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:faker/faker.dart';

import 'package:coach_app/features/athletes/infrastructure/services/fake_groups_service.dart';

class FakeMembersServiceImpl implements MembersService {
  final AthletesService _athletesService;
  final GroupsService _groupsService;
  final GroupRolesService _groupRolesService;
  final List<Member> _members = [];
  final Random _random = Random();

  bool _isInitialized = false;

  FakeMembersServiceImpl(
    this._athletesService,
    this._groupsService,
    this._groupRolesService,
  );

  /// Ensures that fake members are generated before any operation
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _isInitialized = true;
      await _generateFakeMembers();
    }
  }

  Future<void> _generateFakeMembers() async {
    final athletes = await _athletesService.getAllAthletes();
    final groups = await _groupsService.getAllGroups();
    final roles = await _groupRolesService.getAllRoles();

    if (groups.isEmpty) return;

    for (final group in groups.sublist(0, groups.length - 1)) {
      final memberCount = _random.nextInt(5) + 5;
      for (var i = 0; i < memberCount; i++) {
        final athlete = athletes[_random.nextInt(athletes.length)];
        final role = roles[_random.nextInt(roles.length)];
        _members.add(Member(
          id: Faker().guid.guid(),
          athleteId: athlete.id,
          groupId: group.id,
          role: role,
        ));

        // Update the group-athlete relationship in GroupsService
        if (_groupsService is FakeGroupsService) {
          _groupsService.updateGroupAthleteRelationship(
              group.id, athlete.id, true);
        }
      }
    }
  }

  @override
  Future<List<Member>> getMembersForGroup(String groupId) async {
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 100));

    return _members.where((member) => member.groupId == groupId).toList();
  }

  @override
  Future<Member?> getMemberByAthleteAndGroup(
      String athleteId, String groupId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _members.firstWhereOrNull(
        (member) => member.athleteId == athleteId && member.groupId == groupId);
  }

  @override
  Future<Member> addMemberToGroup(
      String athleteId, String groupId, GroupRole role) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final newMember = Member(
      id: Faker().guid.guid(),
      athleteId: athleteId,
      groupId: groupId,
      role: role,
    );
    _members.add(newMember);

    // Update the group-athlete relationship in GroupsService
    if (_groupsService is FakeGroupsService) {
      _groupsService.updateGroupAthleteRelationship(groupId, athleteId, true);
    }

    return newMember;
  }

  @override
  Future<Member> updateMemberRole(String memberId, GroupRole newRole) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _members.indexWhere((member) => member.id == memberId);
    if (index != -1) {
      _members[index] = Member(
        id: _members[index].id,
        athleteId: _members[index].athleteId,
        groupId: _members[index].groupId,
        role: newRole,
      );
      return _members[index];
    }
    throw Exception('Member not found');
  }

  @override
  Future<void> removeMembersFromGroup(String groupId, String memberIds) async {
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 100));
    if (memberIds == '*') {
      final membersToRemove =
          _members.where((member) => member.groupId == groupId).toList();

      for (final member in membersToRemove) {
        if (_groupsService is FakeGroupsService) {
          _groupsService.updateGroupAthleteRelationship(
              groupId, member.athleteId, false);
        }
        _members.removeWhere((member) => member.groupId == groupId);
      }
    } else {
      // Remove specific member(s)
      final idsToRemove = memberIds.split(',').map((id) => id.trim()).toSet();
      _members.removeWhere(
        (member) {
          if (member.groupId == groupId && idsToRemove.contains(member.id)) {
            if (_groupsService is FakeGroupsService) {
              _groupsService.updateGroupAthleteRelationship(
                  groupId, member.athleteId, false);
            }
            return true;
          }
          return false;
        },
      );
    }
  }

  @override
  Future<List<Member>> getGroupsForAthlete(String athleteId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _members.where((member) => member.athleteId == athleteId).toList();
  }

  @override
  Future<bool> isAthleteMemberOfGroup(String athleteId, String groupId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _members.any(
        (member) => member.athleteId == athleteId && member.groupId == groupId);
  }

  @override
  Future<int> getMemberCountForGroup(String groupId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _members.where((member) => member.groupId == groupId).length;
  }

  @override
  Future<List<Member>> getMembersForGroupPaginated(
      String groupId, int page, int pageSize) async {
    await _ensureInitialized();
    final groupMembers =
        _members.where((member) => member.groupId == groupId).toList();

    final athletes = await _athletesService.getAllAthletes();

    final athleteMap = {for (var a in athletes) a.id: a};

    groupMembers.sort((a, b) {
      final athleteA = athleteMap[a.athleteId];
      final athleteB = athleteMap[b.athleteId];
      if (athleteA == null || athleteB == null) return 0;
      return athleteA.name.toLowerCase().compareTo(athleteB.name.toLowerCase());
    });

    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, groupMembers.length);

    return groupMembers.sublist(startIndex, endIndex);
  }

  @override
  Future<List<Member>> searchMembersInGroup(
      String groupId, String searchTerm) async {
    await Future.delayed(const Duration(milliseconds: 150));
    final groupMembers =
        _members.where((member) => member.groupId == groupId).toList();
    final athletes = await _athletesService.getAllAthletes();
    return groupMembers.where((member) {
      final athlete = athletes.firstWhere((a) => a.id == member.athleteId);
      return athlete.name.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }

  @override
  Future<List<Member>> batchAddMembersToGroup(
      String groupId, List<String> athleteIds, GroupRole role) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newMembers = <Member>[];
    for (final athleteId in athleteIds) {
      final newMember = Member(
        id: _generateUniqueId(),
        athleteId: athleteId,
        groupId: groupId,
        role: role,
      );

      _members.add(newMember);
      newMembers.add(newMember);

      // Update the group-athlete relationship in GroupsService
      if (_groupsService is FakeGroupsService) {
        _groupsService.updateGroupAthleteRelationship(groupId, athleteId, true);
      }
    }
    return newMembers;
  }

  @override
  Future<List<Member>> batchAddGroupsToMember(
      String athleteId, List<String> groupIds, GroupRole role) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final newMembers = <Member>[];
    final errors = <String>[];

    for (final groupId in groupIds) {
      // Check if the athlete is already a member of the group
      if (await isAthleteMemberOfGroup(athleteId, groupId)) {
        errors.add('Athlete is already a member of group $groupId');
        continue;
      }

      final newMember = Member(
        id: _generateUniqueId(),
        athleteId: athleteId,
        groupId: groupId,
        role: role,
      );

      _members.add(newMember);
      newMembers.add(newMember);

      // Update the group-athlete relationship in GroupsService
      if (_groupsService is FakeGroupsService) {
        _groupsService.updateGroupAthleteRelationship(groupId, athleteId, true);
      }
    }
    return newMembers;
  }

  @override
  Future<void> batchRemoveMembersFromGroup(
      String groupId, List<String> memberIds) async {
    await Future.delayed(const Duration(milliseconds: 150));

    _members.removeWhere(
        (member) => member.groupId == groupId && memberIds.contains(member.id));
  }

  String _generateUniqueId() {
      return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }

  @override
  Future<Map<String, List<Member>>> getGroupsForAthletes(
      List<String> athleteIds) async {
    await Future.delayed(const Duration(milliseconds: 200));

    Map<String, List<Member>> athleteGroups = {};

    for (final member in _members) {
      if (athleteIds.contains(member.athleteId)) {
        athleteGroups.putIfAbsent(member.athleteId, () => []).add(member);
      }
    }

    return athleteGroups;
  }

  @override
  Future<Map<String, bool>> areAthletesMembersOfGroup(
    List<String> athleteIds,
    String groupId,
  ) async {
    await _ensureInitialized();
    await Future.delayed(const Duration(milliseconds: 100));

    Map<String, bool> membershipStatus = {};

    for (final athleteId in athleteIds) {
      bool isMember = _members.any((member) =>
          member.athleteId == athleteId && member.groupId == groupId);
      membershipStatus[athleteId] = isMember;
    }

    return membershipStatus;
  }
}
