import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/infrastructure/services/avatar_generator_service.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_groups_service.dart';

@GenerateMocks([
  SportsService,
  AvatarGeneratorService,
  AvatarRepository,
])
import 'fake_groups_service_test.mocks.dart';
import 'fake_members_service_test.mocks.dart';

void main() {
  late FakeGroupsService fakeGroupsService;
  late MockSportsService mockSportsService;
  late MockAthletesService mockAthletesService;
  late MockAvatarGeneratorService mockAvatarGeneratorService;
  late MockAvatarRepository mockAvatarRepository;

  setUp(() async {
    mockSportsService = MockSportsService();
    mockAthletesService = MockAthletesService();
    mockAvatarGeneratorService = MockAvatarGeneratorService();
    mockAvatarRepository = MockAvatarRepository();

    when(mockSportsService.getAllSports()).thenAnswer((_) async => [
          const Sport(id: '1', name: 'Football'),
          const Sport(id: '2', name: 'Basketball'),
          const Sport(id: '3', name: 'Tennis'),
        ]);

    // Mock the getAllAthletes method
    when(mockAthletesService.getAllAthletes()).thenAnswer((_) async => const [
          Athlete(id: 'athlete1', name: 'John Doe'),
          Athlete(id: 'athlete2', name: 'Jane Smith'),
          Athlete(id: 'athlete3', name: 'Mike Johnson'),
        ]);

    when(mockAvatarGeneratorService.generateAvatar()).thenReturn('fake_avatar');
    when(mockAvatarRepository.saveAvatar(any, any)).thenAnswer((_) async =>
        Avatar(
            id: 'fake_avatar_id',
            lastUpdated: DateTime.now(),
            localPath: 'test',
            syncStatus: SyncStatus.synced));

    fakeGroupsService = FakeGroupsService(
      mockAvatarGeneratorService,
      mockAvatarRepository,
      mockSportsService,
    );

    await fakeGroupsService.initializeDatabase();
  });

  group('FakeGroupsService', () {
    test('constructor generates 500 fake groups', () async {
      final groups = await fakeGroupsService.getAllGroups();
      expect(groups.length, 500);
    });

    test('getAllGroups returns all groups', () async {
      final groups = await fakeGroupsService.getAllGroups();
      expect(groups.length, 500);
    });

    test('getGroupsByPage with name filter returns filtered groups', () async {
      final filterCriteria = GroupsFilterCriteria(name: 'Football');
      final groups = await fakeGroupsService.getGroupsByPage(0, 10,
          filterCriteria: filterCriteria);
      for (var group in groups) {
        expect(group.name.toLowerCase(), contains('football'));
      }
    });

    test('getGroupsByPage with sports filter returns filtered groups',
        () async {
      final filterCriteria = GroupsFilterCriteria(sports: const ['1']);
      final groups = await fakeGroupsService.getGroupsByPage(0, 10,
          filterCriteria: filterCriteria);
      for (var group in groups) {
        expect(group.sport?.id, '1');
      }
    });

    test('getGroupsByFilterCriteria returns all groups', () async {
      final groups = await fakeGroupsService
          .getGroupsByFilterCriteria(GroupsFilterCriteria());
      expect(groups.length, 500);
    });

    test('getGroupById returns correct group', () async {
      final allGroups = await fakeGroupsService.getAllGroups();
      final targetGroup = allGroups.first;
      final retrievedGroup =
          await fakeGroupsService.getGroupById(targetGroup.id);
      expect(retrievedGroup?.id, equals(targetGroup.id));
      expect(retrievedGroup?.name, equals(targetGroup.name));
    });

    test('createGroup adds a new group', () async {
      const newGroup = Group(
        id: 'new_id',
        name: 'New Group',
        avatarId: 'fake_avatar_id',
        sport: Sport(id: '1', name: 'Football'),
      );
      final createdGroup = await fakeGroupsService.createGroup(newGroup);
      final retrievedGroup =
          await fakeGroupsService.getGroupById(createdGroup.id);
      expect(retrievedGroup?.id, equals(createdGroup.id));
      expect(retrievedGroup?.name, equals(newGroup.name));
    });

    test('updateGroup modifies an existing group', () async {
      final allGroups = await fakeGroupsService.getAllGroups();
      final targetGroup = allGroups.first;
      final updatedGroup = targetGroup.copyWith(name: 'Updated Name');
      await fakeGroupsService.updateGroup(updatedGroup);
      final retrievedGroup =
          await fakeGroupsService.getGroupById(targetGroup.id);
      expect(retrievedGroup?.name, equals('Updated Name'));
    });

    test('updateGroup throws exception for non-existent group', () async {
      const nonExistentGroup = Group(
        id: 'non_existent_id',
        name: 'Non-existent Group',
        avatarId: 'fake_avatar_id',
        sport: Sport(id: '1', name: 'Football'),
      );
      expect(() => fakeGroupsService.updateGroup(nonExistentGroup),
          throwsA(isA<Exception>()));
    });
  });

  group('deleteGroup', () {
    test('archives an existing group', () async {
      final allGroups = await fakeGroupsService.getAllGroups();
      final targetGroup = allGroups.first;

      await fakeGroupsService.deleteGroup(targetGroup.id);

      final updatedGroup = await fakeGroupsService.getGroupById(targetGroup.id);
      expect(updatedGroup?.archived, isTrue);
    });

    test('does nothing for non-existent group ID', () async {
      final initialGroups = await fakeGroupsService.getAllGroups();

      await fakeGroupsService.deleteGroup('non_existent_id');

      final finalGroups = await fakeGroupsService.getAllGroups();
      expect(finalGroups, equals(initialGroups));
    });
  });

  group('restoreGroup', () {
    test('restores an archived group', () async {
      final allGroups = await fakeGroupsService.getAllGroups();
      final targetGroup = allGroups.first;

      await fakeGroupsService.deleteGroup(targetGroup.id);
      final restoredGroup =
          await fakeGroupsService.restoreGroup(targetGroup.id);

      expect(restoredGroup.archived, isFalse);
      expect(restoredGroup.id, equals(targetGroup.id));
      expect(restoredGroup.name, equals(targetGroup.name));
    });

    test('throws exception for non-existent group ID', () async {
      expect(() => fakeGroupsService.restoreGroup('non_existent_id'),
          throwsA(isA<Exception>()));
    });

    test('does not change an already active group', () async {
      final allGroups = await fakeGroupsService.getAllGroups();
      final targetGroup = allGroups.first;

      final restoredGroup =
          await fakeGroupsService.restoreGroup(targetGroup.id);

      expect(restoredGroup.archived, isFalse);
      expect(restoredGroup.id, equals(targetGroup.id));
      expect(restoredGroup.name, equals(targetGroup.name));
    });
  });
}
