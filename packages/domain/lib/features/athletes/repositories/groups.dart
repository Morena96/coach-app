import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';

abstract class Groups {
  Future<Result<List<Group>>> getAllGroups();

  Future<Result<List<Group>>> getGroupsByPage(
    int page,
    int pageSize, {
    GroupsFilterCriteria? filterCriteria,
  });

  Future<Result<Group>> getGroupById(String id);

  Future<Result<Group>> createGroup(
    String name,
    String? description,
    Sport sport,
  );

  Future<Result<Group>> updateGroup(Group group);

  Future<Result<void>> deleteGroup(String id);

  Future<Result<void>> restoreGroup(String id);

  Future<Result<List<GroupRole>>> getAllRoles();
}
