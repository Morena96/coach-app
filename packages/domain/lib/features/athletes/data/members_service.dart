import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';

abstract class MembersService {
  /// Get all members for a specific group
  Future<List<Member>> getMembersForGroup(String groupId);

  /// Get member by athlete ID and group ID
  Future<Member?> getMemberByAthleteAndGroup(String athleteId, String groupId);

  /// Add a new member to a group
  Future<Member> addMemberToGroup(
      String athleteId, String groupId, GroupRole role);

  /// Update a member's role in a group
  Future<Member> updateMemberRole(String memberId, GroupRole newRole);

  /// Remove  member(s) from a group,
  /// [memberIds] should be one memberId, comma separated memberIds
  /// or [*] to remove all members from the group
  Future<void> removeMembersFromGroup(String groupId, String memberIds);

  /// Get all groups for a specific athlete
  Future<List<Member>> getGroupsForAthlete(String athleteId);

  /// Check if an athlete is a member of a specific group
  Future<bool> isAthleteMemberOfGroup(String athleteId, String groupId);

  /// Get the total count of members in a group
  Future<int> getMemberCountForGroup(String groupId);

  /// Get members for a group with pagination
  Future<List<Member>> getMembersForGroupPaginated(
      String groupId, int page, int pageSize);

  /// Search for members in a group by name
  Future<List<Member>> searchMembersInGroup(String groupId, String searchTerm);

  /// Add multiple members to a group in a single operation
  Future<List<Member>> batchAddMembersToGroup(
      String groupId, List<String> athleteIds, GroupRole role);

  /// Remove multiple members from a group in a single operation
  Future<void> batchRemoveMembersFromGroup(
      String groupId, List<String> memberIds);

  /// Get all groups for a list of athletes
  ///
  /// This method returns a map where the keys are athlete IDs and the values are
  /// lists of Member objects representing the groups each athlete belongs to.
  ///
  /// [athleteIds] A list of athlete IDs to fetch groups for
  ///
  /// Returns a Future that resolves to a Map<String, List<Member>>
  Future<Map<String, List<Member>>> getGroupsForAthletes(List<String> athleteIds);

  Future<Map<String, bool>> areAthletesMembersOfGroup(
    List<String> athleteIds,
    String groupId,
  );
}
