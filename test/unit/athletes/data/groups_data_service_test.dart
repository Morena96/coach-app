import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/infrastructure/data/hive_groups_data_service.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_group.dart';

@GenerateMocks([Box<HiveGroup>, LoggerRepository])
import 'groups_data_service_test.mocks.dart';

void main() {
  late HiveGroupsDataService dataService;
  late MockBox<HiveGroup> mockBox;
  late MockLoggerRepository mockLoggerRepository;

  setUp(() {
    mockBox = MockBox<HiveGroup>();
    mockLoggerRepository = MockLoggerRepository();
    dataService = HiveGroupsDataService()
      ..groupsBox = mockBox
      ..loggerRepository = mockLoggerRepository;
  });

  group('GroupsDataService', () {
    test('createGroup should add group to the box', () async {
      const group = Group(id: '1', name: 'Test Group');

      when(mockBox.put('1', any)).thenAnswer((_) => Future.value());

      final result = await dataService.createGroup(group);

      verify(mockBox.put('1', any)).called(1);
      expect(result, equals(group));
    });

    test('getAllGroups should return all groups from the box', () async {
      final groups = [
        HiveGroup(id: '1', name: 'Group 1'),
        HiveGroup(id: '2', name: 'Group 2'),
      ];
      when(mockBox.values).thenReturn(groups);

      final result = await dataService.getAllGroups();

      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[1].id, equals('2'));
    });

    test('getGroupById should return the correct group', () async {
      final group = HiveGroup(id: '1', name: 'Test Group');
      when(mockBox.get('1')).thenReturn(group);

      final result = await dataService.getGroupById('1');

      expect(result, isNotNull);
      expect(result!.id, equals('1'));
      expect(result.name, equals('Test Group'));
    });

    test('getGroupById should return null when group not found', () async {
      when(mockBox.get('1')).thenReturn(null);

      final result = await dataService.getGroupById('1');

      expect(result, isNull);
    });

    test('getGroupsByFilterCriteria should return filtered groups', () async {
      final groups = [
        HiveGroup(id: '1', name: 'Test Group 1'),
        HiveGroup(id: '2', name: 'Another Group'),
      ];
      when(mockBox.values).thenReturn(groups);

      var filterCriteria = GroupsFilterCriteria(name: 'Test');

      final result =
          await dataService.getGroupsByFilterCriteria(filterCriteria);

      expect(result.length, equals(1));
      expect(result[0].id, equals('1'));
    });

    test('getGroupsByFilterCriteria should return all groups when no criteria',
        () async {
      final groups = [
        HiveGroup(id: '1', name: 'Test Group 1'),
        HiveGroup(id: '2', name: 'Another Group'),
      ];
      when(mockBox.values).thenReturn(groups);

      final result =
          await dataService.getGroupsByFilterCriteria(GroupsFilterCriteria());

      expect(result.length, equals(2));
    });

    test('getGroupsByPage should return correct page of groups', () async {
      final groups = List.generate(
        20,
        (index) =>
            HiveGroup(id: index.toString(), name: 'Group $index'),
      );
      when(mockBox.values).thenReturn(groups);

      final result = await dataService.getGroupsByPage(2, 5);

      expect(result.length, equals(5));
      expect(result.first.id, equals('5'));
      expect(result.last.id, equals('9'));
    });

    test('getGroupsByPage should return empty list for out of range page',
        () async {
      final groups = List.generate(
        5,
        (index) =>
            HiveGroup(id: index.toString(), name: 'Group $index'),
      );
      when(mockBox.values).thenReturn(groups);

      final result = await dataService.getGroupsByPage(3, 5);

      expect(result, isEmpty);
    });

    test('updateGroup should update the group in the box', () async {
      const group = Group(id: '1', name: 'Updated Group');

      when(mockBox.put('1', any)).thenAnswer((_) => Future.value());

      final result = await dataService.updateGroup(group);

      verify(mockBox.put('1', any)).called(1);
      expect(result, equals(group));
    });
  });
}
