import 'package:domain/features/athletes/data/group_roles_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/id_generator.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GroupsImpl implements Groups {
  final GroupsService _groupsService;
  final GroupRolesService _groupRolesService;
  final LoggerRepository _loggerRepository;
  final IdGenerator _idGenerator;

  GroupsImpl(this._groupsService, this._loggerRepository, this._idGenerator,
      this._groupRolesService);

  @override
  Future<Result<List<Group>>> getAllGroups() async {
    try {
      final groups = await _groupsService.getAllGroups();
      return Result.success(groups);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<Group>>> getGroupsByPage(
    int page,
    int pageSize, {
    GroupsFilterCriteria? filterCriteria,
  }) async {
    try {
      final groups = await _groupsService.getGroupsByPage(
        page,
        pageSize,
        filterCriteria: filterCriteria,
      );
      return Result.success(groups);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Group>> getGroupById(String id) async {
    try {
      final group = await _groupsService.getGroupById(id);
      if (group == null) {
        return Result.failure('Group not found');
      }
      return Result.success(group);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Group>> createGroup(
    String name,
    String? description,
    Sport sport,
  ) async {
    try {
      final group = await _groupsService.createGroup(
        Group(
          id: _idGenerator.generate(),
          name: name,
          description: description,
          sport: sport,
          members: const [],
        ),
      );
      return Result.success(group);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Group>> updateGroup(Group group) async {
    try {
      final updatedGroup = await _groupsService.updateGroup(group);
      return Result.success(updatedGroup);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteGroup(String id) async {
    try {
      await _groupsService.deleteGroup(id);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<void>> restoreGroup(String id) async {
    try {
      await _groupsService.restoreGroup(id);
      return Result.success(null);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<List<GroupRole>>> getAllRoles() async {
    try {
      final groupRoles = await _groupRolesService.getAllRoles();
      return Result.success(groupRoles);
    } catch (e) {
      _loggerRepository.error(e.toString());
      return Result.failure(e.toString());
    }
  }
}
