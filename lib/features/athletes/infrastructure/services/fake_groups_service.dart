import 'dart:convert';
import 'dart:math';

import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:faker/faker.dart' hide Sport;

import 'package:coach_app/features/athletes/infrastructure/services/avatar_generator_service.dart';
import 'package:coach_app/features/avatars/infrastructure/models/memory_image_data.dart';
import 'package:coach_app/shared/extensions/int.dart';

/// A mock implementation of the [GroupsService] for testing and development purposes.
class FakeGroupsService implements GroupsService {
  /// Internal list to store fake group data.
  final List<Group> _groups = [];
  late List<Sport> _sports;
  final AvatarGeneratorService _avatarGeneratorService;
  final AvatarRepository _avatarRepository;
  final SportsService _sportsService;

  /// Creates a [FakeGroupsService] and generates 50 fake groups.
  FakeGroupsService(this._avatarGeneratorService, this._avatarRepository,
      this._sportsService) {
    _generateFakeGroups(500);
  }

  /// Generates a specified number of fake groups.
  void _generateFakeGroups(int count) async {
    _sports = await _sportsService.getAllSports();

    final faker = Faker();
    for (int i = 0; i < count; i++) {
      final groupId = faker.guid.guid();
      final avatarSvg = _avatarGeneratorService.generateAvatar();
      final avatar = await _avatarRepository.saveAvatar(
        groupId,
        MemoryImageData(utf8.encode(avatarSvg)),
      );

      _groups.add(
        Group(
          id: groupId,
          name: '${faker.sport.name()} ${faker.company.name()}',
          members: _generateFakeMembers(groupId, Random().nextInt(10) + 1),
          avatarId: avatar.id,
          description: faker.lorem.sentences(3).join(' '),
          sport: _sports.isNotEmpty
              ? _sports[Random().nextInt(_sports.length)]
              : null,
        ),
      );
    }
  }

  /// Generates fake members for a group.
  List<Member> _generateFakeMembers(String groupId, int count) {
    final faker = Faker();
    return List.generate(
      count,
      (_) => Member(
        id: faker.guid.guid(),
        athleteId: faker.guid.guid(),
        groupId: groupId,
        role: Random().nextBool() ? GroupRole.coach : GroupRole.athlete,
      ),
    );
  }

  @override
  Future<List<Group>> getAllGroups() async {
    return Future.delayed(const Duration(milliseconds: 500), () => _groups);
  }

  @override
  Future<List<Group>> getGroupsByPage(
    int page,
    int pageSize, {
    GroupsFilterCriteria? filterCriteria,
  }) async {
    if (_groups.isEmpty) await Future.delayed(500.ms);
    List<Group> filteredGroups = List.from(_groups);

    if (filterCriteria != null) {
      filteredGroups = filteredGroups.where((group) {
        // Apply name filter
        if (filterCriteria.name != null && filterCriteria.name!.isNotEmpty) {
          if (!group.name
              .toLowerCase()
              .contains(filterCriteria.name!.toLowerCase())) {
            return false;
          }
        }

        // Apply sports filter
        if (filterCriteria.sports != null &&
            filterCriteria.sports!.isNotEmpty &&
            !filterCriteria.sports!.contains(group.sport?.id)) {
          return false;
        }

        return true;
      }).toList();
    }

    final startIndex = page * pageSize;
    final endIndex = startIndex + pageSize;

    return Future.delayed(const Duration(milliseconds: 500), () {
      if (startIndex >= filteredGroups.length) {
        return <Group>[];
      }

      return filteredGroups.sublist(
        startIndex,
        endIndex > filteredGroups.length ? filteredGroups.length : endIndex,
      );
    });
  }

  @override
  Future<List<Group>> getGroupsByFilterCriteria(
      FilterCriteria filterCriteria) async {
    return Future.delayed(const Duration(milliseconds: 500), () => _groups);
  }

  @override
  Future<Group?> getGroupById(String id) async {
    return Future.delayed(const Duration(milliseconds: 500), () {
      return _groups.firstWhere((group) => group.id == id);
    });
  }

  @override
  Future<Group> createGroup(Group group) async {
    final newGroup = group.copyWith(id: Faker().guid.guid());
    _groups.add(newGroup);
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => newGroup,
    );
  }

  @override
  Future<Group> updateGroup(Group group) async {
    final index = _groups.indexWhere((g) => g.id == group.id);
    if (index == -1) throw Exception('Group not found');
    _groups[index] = group;
    return Future.delayed(const Duration(milliseconds: 500), () => group);
  }

  /// Archives a group by its ID with a simulated delay.
  ///
  /// [id] The ID of the group to archive.
  ///
  /// Returns a [Future] that completes after a 500ms delay.
  @override
  Future<void> deleteGroup(String id) async {
    final index = _groups.indexWhere((group) => group.id == id);
    if (index != -1) {
      _groups[index] = _groups[index].copyWith(archived: true);
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  /// Restores an archived group by its ID with a simulated delay.
  ///
  /// [id] The ID of the group to restore.
  ///
  /// Returns a [Future] that completes with the restored group after a 500ms delay.
  /// Throws an exception if the group is not found.
  @override
  Future<Group> restoreGroup(String id) async {
    return Future.delayed(const Duration(milliseconds: 500), () {
      final index = _groups.indexWhere((group) => group.id == id);
      if (index == -1) throw Exception('Group not found');
      final restoredGroup = _groups[index].copyWith(archived: false);
      _groups[index] = restoredGroup;
      return restoredGroup;
    });
  }
}
