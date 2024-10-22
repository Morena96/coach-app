import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/shared/utilities/result.dart';

abstract class Members {
  Future<Result<List<Member>>> getMembersForGroup(String groupId);

  Future<Result<Member?>> getMemberByAthleteAndGroup(String athleteId, String groupId);

  Future<Result<Member>> addMemberToGroup(String athleteId, String groupId, GroupRole role);

  Future<Result<Member>> updateMemberRole(String memberId, GroupRole newRole);

  Future<Result<void>> removeMemberFromGroup(String groupId, String memberIds);

  Future<Result<List<Member>>> getGroupsForAthlete(String athleteId);

  Future<Result<bool>> isAthleteMemberOfGroup(String athleteId, String groupId);

  Future<Result<int>> getMemberCountForGroup(String groupId);

  Future<Result<List<Member>>> getMembersForGroupPaginated(String groupId, int page, int pageSize);

  Future<Result<List<Member>>> searchMembersInGroup(String groupId, String searchTerm);

  Future<Result<List<Member>>> batchAddMembersToGroup(String groupId, List<String> athleteIds, GroupRole role);

  Future<Result<List<Member>>> batchAddGroupsToMember(String athleteId, List<String> groupIds, GroupRole role);

  Future<Result<void>> batchRemoveMembersFromGroup(String groupId, List<String> memberIds);

  Future<Result<Map<String, bool>>> areAthletesMembersOfGroup(
      List<String> athleteIds, String groupId);
}
