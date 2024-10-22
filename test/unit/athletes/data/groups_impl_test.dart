import 'package:coach_app/features/athletes/infrastructure/repositories/groups_impl.dart';
import 'package:domain/features/athletes/data/group_roles_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/id_generator.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks(
    [GroupsService, LoggerRepository, IdGenerator, GroupRolesService])
import 'groups_impl_test.mocks.dart';

void main() {
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
      when(groupsService.getAllGroups()).thenAnswer((_) async => []);
      final result = await groupsImpl.getAllGroups();
      expect(result.isSuccess, true);
      expect(result.value, []);
    });

    test('should return an error message', () async {
      when(groupsService.getAllGroups()).thenThrow(Exception('Error'));
      final result = await groupsImpl.getAllGroups();
      expect(result.isFailure, true);
      expect(result.error, 'Exception: Error');
      verify(loggerRepository.error('Exception: Error')).called(1);
    });
  });

  group('getGroupsByPage', () {
    final mockFilterCriteria = GroupsFilterCriteria(
      sports: ['1'],
      name: 'test',
    );

    test('should return paginated groups list', () async {
      // Arrange
      final expectedGroups = [
        const Group(
            id: '1', name: 'Group 1', sport: Sport(id: '1', name: 'Sport 1')),
        const Group(
            id: '2', name: 'Group 2', sport: Sport(id: '1', name: 'Sport 1')),
      ];
      when(groupsService.getGroupsByPage(1, 10,
              filterCriteria: mockFilterCriteria))
          .thenAnswer((_) async => expectedGroups);

      // Act
      final result = await groupsImpl.getGroupsByPage(1, 10,
          filterCriteria: mockFilterCriteria);

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, expectedGroups);
      verify(groupsService.getGroupsByPage(1, 10,
              filterCriteria: mockFilterCriteria))
          .called(1);
    });

    test('should return failure when pagination fails', () async {
      // Arrange
      when(groupsService.getGroupsByPage(1, 10,
              filterCriteria: mockFilterCriteria))
          .thenThrow(Exception('Pagination error'));

      // Act
      final result = await groupsImpl.getGroupsByPage(1, 10,
          filterCriteria: mockFilterCriteria);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Exception: Pagination error');
      verify(loggerRepository.error('Exception: Pagination error')).called(1);
    });
  });

  group('getGroupById', () {
    test('should return a group', () async {
      when(groupsService.getGroupById('1'))
          .thenAnswer((_) async => const Group(id: '1', name: 'Group 1'));
      final result = await groupsImpl.getGroupById('1');
      expect(result.isSuccess, true);
      expect(result.value, const Group(id: '1', name: 'Group 1'));
    });

    test('should return failure when group is not found', () async {
      when(groupsService.getGroupById('1')).thenAnswer((_) async => null);
      final result = await groupsImpl.getGroupById('1');
      expect(result.isFailure, true);
      expect(result.error, 'Group not found');
    });

    test('should return failure when error occurs', () async {
      when(groupsService.getGroupById('1')).thenThrow(Exception('Error'));
      final result = await groupsImpl.getGroupById('1');
      expect(result.isFailure, true);
      expect(result.error, 'Exception: Error');
      verify(loggerRepository.error('Exception: Error')).called(1);
    });
  });

  group('createGroup', () {
    const mockSport = Sport(id: '1', name: 'name');

    test('should return a group', () async {
      when(idGenerator.generate()).thenReturn('1');
      when(groupsService.createGroup(const Group(
        id: '1',
        name: 'Group 1',
        description: '',
        sport: mockSport,
      ))).thenAnswer((_) async => const Group(
            id: '1',
            name: 'Group 1',
            description: '',
            sport: mockSport,
          ));

      final result = await groupsImpl.createGroup('Group 1', '', mockSport);

      expect(result.isSuccess, true);
      expect(
          result.value,
          const Group(
            id: '1',
            name: 'Group 1',
            description: '',
            sport: mockSport,
          ));
    });
  });

  group('updateGroup', () {
    const mockGroup = Group(id: '1', name: 'Group 1');

    test('should return updated group', () async {
      when(groupsService.updateGroup(mockGroup))
          .thenAnswer((_) async => mockGroup);

      final result = await groupsImpl.updateGroup(mockGroup);

      expect(result.isSuccess, true);
      expect(result.value, mockGroup);
    });

    test('should return failure when update fails', () async {
      when(groupsService.updateGroup(mockGroup))
          .thenThrow(Exception('Update failed'));

      final result = await groupsImpl.updateGroup(mockGroup);

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Update failed');
      verify(loggerRepository.error('Exception: Update failed')).called(1);
    });
  });

  group('deleteGroup', () {
    test('should return success', () async {
      when(groupsService.deleteGroup('1')).thenAnswer((_) async => {});

      final result = await groupsImpl.deleteGroup('1');

      expect(result.isSuccess, true);
    });

    test('should return failure when deletion fails', () async {
      when(groupsService.deleteGroup('1'))
          .thenThrow(Exception('Deletion failed'));

      final result = await groupsImpl.deleteGroup('1');

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Deletion failed');
      verify(loggerRepository.error('Exception: Deletion failed')).called(1);
    });
  });

  group('getAllRoles', () {
    test('will return success with roles from GroupsService', () async {
      final expectedRoles = [GroupRole.athlete, GroupRole.coach];
      when(groupRolesService.getAllRoles())
          .thenAnswer((_) async => expectedRoles);

      final result = await groupsImpl.getAllRoles();

      expect(result.isSuccess, true);
      expect(result.value, expectedRoles);
      verify(groupRolesService.getAllRoles()).called(1);
    });

    test('will return failure and log error if exception is thrown', () async {
      when(groupRolesService.getAllRoles()).thenThrow(Exception('Error'));

      final result = await groupsImpl.getAllRoles();

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Error');
      verify(loggerRepository.error('Exception: Error')).called(1);
    });
  });

  group('restoreGroup', () {
    test('should successfully restore a group', () async {
      const groupId = '1';
      when(groupsService.restoreGroup(groupId)).thenAnswer((_) async => {});

      final result = await groupsImpl.restoreGroup(groupId);

      expect(result.isSuccess, true);
      verify(groupsService.restoreGroup(groupId)).called(1);
    });

    test('should return failure when an exception occurs', () async {
      const groupId = '1';
      when(groupsService.restoreGroup(groupId))
          .thenThrow(Exception('Restore error'));

      final result = await groupsImpl.restoreGroup(groupId);

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Restore error');
      verify(loggerRepository.error('Exception: Restore error')).called(1);
    });
  });
}
