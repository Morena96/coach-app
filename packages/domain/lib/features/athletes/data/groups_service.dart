import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';

abstract class GroupsService {
  /// Get groups
  Future<List<Group>> getAllGroups();

  /// Get groups by page
  Future<List<Group>> getGroupsByPage(
    int page,
    int pageSize, {
    GroupsFilterCriteria? filterCriteria,
  });

  /// Get groups by filter criteria
  Future<List<Group>> getGroupsByFilterCriteria(FilterCriteria filterCriteria);

  /// Get group by id
  Future<Group?> getGroupById(String id);

  /// Create group
  Future<Group> createGroup(Group group);

  /// Update group
  Future<Group> updateGroup(Group group);

  /// Delete group
  Future<void> deleteGroup(String id);

  /// Restore group
  Future<void> restoreGroup(String id);
}
