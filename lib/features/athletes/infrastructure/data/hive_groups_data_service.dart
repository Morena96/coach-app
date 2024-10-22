import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:hive/hive.dart';

import 'package:coach_app/features/athletes/infrastructure/data/models/hive_group.dart';

class HiveGroupsDataService extends GroupsService {
  late Box<HiveGroup> groupsBox;
  late LoggerRepository loggerRepository;

  @override
  Future<Group> createGroup(Group group) async {
    await groupsBox.put(group.id, HiveGroup.fromDomain(group));

    return group;
  }

  @override
  Future<void> deleteGroup(String id) async {
    final group = await getGroupById(id);
    if (group == null) throw Exception('Group not found');
    final updatedGroup = group.copyWith(archived: true);
    await updateGroup(updatedGroup);
  }

  @override
  Future<Group> restoreGroup(String id) async {
    final group = await getGroupById(id);
    if (group == null) throw Exception('Group not found');
    final restoredGroup = group.copyWith(archived: false);
    await updateGroup(restoredGroup);
    return restoredGroup;
  }

  @override
  Future<List<Group>> getAllGroups() {
    return Future.value(groupsBox.values.map((e) => e.toDomain()).toList());
  }

  @override
  Future<Group?> getGroupById(String id) {
    return Future.value(groupsBox.get(id)?.toDomain());
  }

  @override
  Future<List<Group>> getGroupsByFilterCriteria(
      FilterCriteria filterCriteria) async {
    return groupsBox.values.map((a) => a.toDomain()).where((athlete) {
      var criteria = filterCriteria.toMap();

      if (criteria['name'] != null) {
        if (!athlete.name.contains(criteria['name'])) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Future<List<Group>> getGroupsByPage(int page, int pageSize,
      {GroupsFilterCriteria? filterCriteria}) {
    final allGroups = groupsBox.values.map((e) => e.toDomain()).toList();
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= allGroups.length) {
      return Future.value([]);
    }

    return Future.value(
        allGroups.sublist(startIndex, endIndex.clamp(0, allGroups.length)));
  }

  @override
  Future<Group> updateGroup(Group group) async {
    await groupsBox.put(group.id, HiveGroup.fromDomain(group));

    return group;
  }

  @override
  Future<void> initializeDatabase() {
    throw UnimplementedError();
  }
}
