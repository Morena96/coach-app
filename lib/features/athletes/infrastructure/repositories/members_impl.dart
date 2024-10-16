import 'package:domain/features/athletes/data/members_service.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/utilities/result.dart';

class MembersImpl implements Members {
  final MembersService _membersService;
  final LoggerRepository _loggerRepository;

  MembersImpl(this._membersService, this._loggerRepository);

  @override
  Future<Result<List<Member>>> getMembersForGroup(String groupId) async {
    try {
      final members = await _membersService.getMembersForGroup(groupId);
      return Result.success(members);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Member?>> getMemberByAthleteAndGroup(
      String athleteId, String groupId) async {
    try {
      final member =
          await _membersService.getMemberByAthleteAndGroup(athleteId, groupId);
      return Result.success(member);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Member>> addMemberToGroup(
      String athleteId, String groupId, GroupRole role) async {
    try {
      final member =
          await _membersService.addMemberToGroup(athleteId, groupId, role);
      return Result.success(member);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Member>> updateMemberRole(
      String memberId, GroupRole newRole) async {
    try {
      final updatedMember =
          await _membersService.updateMemberRole(memberId, newRole);
      return Result.success(updatedMember);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> removeMemberFromGroup(
      String groupId, String memberIds) async {
    try {
      await _membersService.removeMembersFromGroup(groupId, memberIds);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Member>>> getGroupsForAthlete(String athleteId) async {
    try {
      final groups = await _membersService.getGroupsForAthlete(athleteId);
      return Result.success(groups);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<bool>> isAthleteMemberOfGroup(
      String athleteId, String groupId) async {
    try {
      final isMember =
          await _membersService.isAthleteMemberOfGroup(athleteId, groupId);
      return Result.success(isMember);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<int>> getMemberCountForGroup(String groupId) async {
    try {
      final count = await _membersService.getMemberCountForGroup(groupId);
      return Result.success(count);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Member>>> getMembersForGroupPaginated(
      String groupId, int page, int pageSize) async {
    try {
      final members = await _membersService.getMembersForGroupPaginated(
          groupId, page, pageSize);
      return Result.success(members);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Member>>> searchMembersInGroup(
      String groupId, String searchTerm) async {
    try {
      final members =
          await _membersService.searchMembersInGroup(groupId, searchTerm);
      return Result.success(members);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Member>>> batchAddMembersToGroup(
      String groupId, List<String> athleteIds, GroupRole role) async {
    try {
      final members = await _membersService.batchAddMembersToGroup(
          groupId, athleteIds, role);
      return Result.success(members);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> batchRemoveMembersFromGroup(
      String groupId, List<String> memberIds) async {
    try {
      await _membersService.batchRemoveMembersFromGroup(groupId, memberIds);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

   @override
  Future<Result<Map<String, bool>>> areAthletesMembersOfGroup(
      List<String> athleteIds, String groupId) async {
    try {
      final membershipStatus = await _membersService.areAthletesMembersOfGroup(athleteIds, groupId);
      return Result.success(membershipStatus);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }
}
