import 'package:coach_app/features/athletes/infrastructure/repositories/groups_impl.dart';
import 'package:domain/features/athletes/data/group_roles_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/id_generator.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks(
    [GroupsService, LoggerRepository, IdGenerator, GroupRolesService])
import 'groups_impl_test.mocks.dart';

main() {
  late GroupsService groupsService;
  late GroupRolesService groupRolesService;
  late LoggerRepository loggerRepository;
  late IdGenerator idGenerator;

  late GroupsImpl groupsImpl;

  setUp(() {
    groupsService = MockGroupsService();
    loggerRepository = MockLoggerRepository();
    idGenerator = MockIdGenerator();
    groupRolesService = MockGroupRolesService();
    groupsImpl = GroupsImpl(
        groupsService, loggerRepository, idGenerator, groupRolesService);
  });

  group('getAllGroups', () {
    test('should return a list of groups', () async {
      // Arrange
      when(groupsService.getAllGroups()).thenAnswer((_) async => []);
      // Act
      final result = await groupsImpl.getAllGroups();
      // Assert
      expect(result.isSuccess, true);
      expect(result.value, []);
    });

    test('should return an error message', () async {
      // Arrange
      when(groupsService.getAllGroups()).thenThrow(Exception('Error'));
      // Act
      final result = await groupsImpl.getAllGroups();
      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Exception: Error');
    });
  });

  group('getGroupById', () {
    test('should return a group', () async {
      // Arrange
      when(groupsService.getGroupById('1')).thenAnswer(
          (_) async => const Group(id: '1', name: 'Group 1', members: []));
      // Act
      final result = await groupsImpl.getGroupById('1');
      // Assert
      expect(result.isSuccess, true);
      expect(result.value, const Group(id: '1', name: 'Group 1', members: []));
    });
  });

  group('createGroup', () {
    test('should return a group', () async {
      // Arrange
      when(idGenerator.generate()).thenReturn('1');
      when(groupsService.createGroup(const Group(
              id: '1',
              name: 'Group 1',
              description: '',
              members: [],
              sport: Sport(id: '1', name: 'name'))))
          .thenAnswer((_) async => const Group(
              id: '1',
              name: 'Group 1',
              description: '',
              members: [],
              sport: Sport(id: '1', name: 'name')));
      // Act
      final result = await groupsImpl.createGroup(
        'Group 1',
        '',
        const Sport(id: '1', name: 'name'),
      );
      // Assert
      expect(
        result.value,
        const Group(
            id: '1',
            name: 'Group 1',
            description: '',
            members: [],
            sport: Sport(id: '1', name: 'name')),
      );
    });
  });

  group('updateGroup', () {
    test('should return a group', () async {
      // Arrange
      const updatedGroup = Group(id: '1', name: 'Group 1', members: []);
      when(groupsService.updateGroup(updatedGroup))
          .thenAnswer((_) async => updatedGroup);
      // Act
      final result = await groupsImpl.updateGroup(updatedGroup);
      // Assert
      expect(result.isSuccess, true);
      expect(result.value, updatedGroup);
    });
  });

  group('deleteGroup', () {
    test('should return null', () async {
      // Arrange
      when(groupsService.deleteGroup('1')).thenAnswer((_) async => {});
      // Act
      final result = await groupsImpl.deleteGroup('1');
      // Assert
      expect(result.isSuccess, true);
    });
  });

  group('getAllRoles', () {
    test('will return success with roles from GroupsService', () async {
      // Arrange
      final expectedRoles = [GroupRole.athlete, GroupRole.coach];
      when(groupRolesService.getAllRoles())
          .thenAnswer((_) async => expectedRoles);

      // Act
      final result = await groupsImpl.getAllRoles();

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, expectedRoles);
      verify(groupRolesService.getAllRoles()).called(1);
    });

    test('will return failure and log error if exception is thrown', () async {
      // Arrange
      when(groupRolesService.getAllRoles()).thenThrow(Exception('Error'));

      // Act
      final result = await groupsImpl.getAllRoles();

      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Exception: Error');
      verify(loggerRepository.error('Exception: Error')).called(1);
    });
  });

  group('restoreGroup', () {
    test('should successfully restore a group', () async {
      // Arrange
      const groupId = '1';
      when(groupsService.restoreGroup(groupId)).thenAnswer((_) async => {});

      // Act
      final result = await groupsImpl.restoreGroup(groupId);

      // Assert
      expect(result.isSuccess, true);
      verify(groupsService.restoreGroup(groupId)).called(1);
    });

    test('should return failure when an exception occurs', () async {
      // Arrange
      const groupId = '1';
      when(groupsService.restoreGroup(groupId))
          .thenThrow(Exception('Restore error'));

      // Act
      final result = await groupsImpl.restoreGroup(groupId);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Exception: Restore error');
      verify(loggerRepository.error('Exception: Restore error')).called(1);
    });
  });
}
