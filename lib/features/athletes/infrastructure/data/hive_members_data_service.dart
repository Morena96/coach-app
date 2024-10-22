import 'dart:async';

import 'package:coach_app/features/athletes/infrastructure/data/models/hive_member.dart';
import 'package:domain/features/athletes/data/members_service.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:collection/collection.dart';

class HiveMembersDataService implements MembersService {
  late Box<HiveMember> membersBox;
  late LoggerRepository loggerRepository;
  List<Member>? _cachedMembers;
  Timer? _cacheTimer;
  final Duration _cacheDuration = const Duration(seconds: 10);

  HiveMembersDataService(this.membersBox, this.loggerRepository);

  Future<List<Member>> _getCachedMembers() async {
    if (_cachedMembers == null) {
      _cachedMembers = membersBox.values.map((e) => e.toDomain()).toList();
      _resetCacheTimer();
    }
    return _cachedMembers!;
  }

  void _resetCacheTimer() {
    _cacheTimer?.cancel();
    _cacheTimer = Timer(_cacheDuration, () {
      _cachedMembers = null;
    });
  }

  @override
  Future<List<Member>> getMembersForGroup(String groupId) async {
    final allMembers = await _getCachedMembers();
    return allMembers.where((member) => member.groupId == groupId).toList();
  }

  @override
  Future<Member?> getMemberByAthleteAndGroup(String athleteId, String groupId) async {
    final allMembers = await _getCachedMembers();
    return allMembers.firstWhereOrNull(
      (member) => member.athleteId == athleteId && member.groupId == groupId,
     
    );
  }

  @override
  Future<Member> addMemberToGroup(String athleteId, String groupId, GroupRole role) async {
    final newMember = Member(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      athleteId: athleteId,
      groupId: groupId,
      role: role,
    );
    await membersBox.put(newMember.id, HiveMember.fromDomain(newMember));
    _cachedMembers = null;
    return newMember;
  }

  @override
  Future<Member> updateMemberRole(String memberId, GroupRole newRole) async {
    final member = membersBox.get(memberId);
    if (member == null) {
      throw Exception('Member not found');
    }
    final updatedMember = member.toDomain().copyWith(role: newRole);
    await membersBox.put(memberId, HiveMember.fromDomain(updatedMember));
    _cachedMembers = null;
    return updatedMember;
  }

  @override
  Future<void> removeMembersFromGroup(String groupId, String memberIds) async {
    if (memberIds == '*') {
      await membersBox.deleteAll(
        membersBox.values.where((member) => member.groupId == groupId).map((e) => e.id),
      );
    } else {
      final idsToRemove = memberIds.split(',').map((id) => id.trim()).toSet();
      await membersBox.deleteAll(idsToRemove);
    }
    _cachedMembers = null;
  }

  @override
  Future<List<Member>> getGroupsForAthlete(String athleteId) async {
    final allMembers = await _getCachedMembers();
    return allMembers.where((member) => member.athleteId == athleteId).toList();
  }

  @override
  Future<bool> isAthleteMemberOfGroup(String athleteId, String groupId) async {
    final allMembers = await _getCachedMembers();
    return allMembers.any((member) => member.athleteId == athleteId && member.groupId == groupId);
  }

  @override
  Future<int> getMemberCountForGroup(String groupId) async {
    final allMembers = await _getCachedMembers();
    return allMembers.where((member) => member.groupId == groupId).length;
  }

  @override
  Future<List<Member>> getMembersForGroupPaginated(String groupId, int page, int pageSize) async {
    final groupMembers = await getMembersForGroup(groupId);
    final startIndex = page * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, groupMembers.length);
    return groupMembers.sublist(startIndex, endIndex);
  }

  @override
  Future<List<Member>> searchMembersInGroup(String groupId, String searchTerm) async {
    final groupMembers = await getMembersForGroup(groupId);
    return groupMembers.where((member) => 
      member.athleteId.toLowerCase().contains(searchTerm.toLowerCase())
    ).toList();
  }

  @override
  Future<List<Member>> batchAddMembersToGroup(String groupId, List<String> athleteIds, GroupRole role) async {
    final newMembers = <Member>[];
    for (final athleteId in athleteIds) {
      final newMember = await addMemberToGroup(athleteId, groupId, role);
      newMembers.add(newMember);
    }
    return newMembers;
  }

  @override
  Future<List<Member>> batchAddGroupsToMember(String athleteId, List<String> groupIds, GroupRole role) async {
    final newMembers = <Member>[];
    for (final groupId in groupIds) {
      final newMember = await addMemberToGroup(athleteId, groupId, role);
      newMembers.add(newMember);
    }
    return newMembers;
  }

  @override
  Future<void> batchRemoveMembersFromGroup(String groupId, List<String> memberIds) async {
    await membersBox.deleteAll(memberIds);
    _cachedMembers = null;
  }

  @override
  Future<Map<String, List<Member>>> getGroupsForAthletes(List<String> athleteIds) async {
    final allMembers = await _getCachedMembers();
    final Map<String, List<Member>> result = {};
    for (final athleteId in athleteIds) {
      result[athleteId] = allMembers.where((member) => member.athleteId == athleteId).toList();
    }
    return result;
  }

  @override
  Future<Map<String, bool>> areAthletesMembersOfGroup(List<String> athleteIds, String groupId) async {
    final allMembers = await _getCachedMembers();
    final Map<String, bool> result = {};
    for (final athleteId in athleteIds) {
      result[athleteId] = allMembers.any((member) => member.athleteId == athleteId && member.groupId == groupId);
    }
    return result;
  }

  void dispose() {
    _cacheTimer?.cancel();
  }
}
