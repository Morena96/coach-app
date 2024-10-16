import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:coach_app/features/athletes/infrastructure/data/hive_members_data_service.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_member.dart';

@GenerateMocks([Box<HiveMember>, LoggerRepository])
import 'hive_members_data_service_test.mocks.dart';

void main() {
  late HiveMembersDataService dataService;
  late MockBox<HiveMember> mockBox;
  late MockLoggerRepository mockLoggerRepository;

  setUp(() {
    mockBox = MockBox<HiveMember>();
    mockLoggerRepository = MockLoggerRepository();
    dataService = HiveMembersDataService(mockBox, mockLoggerRepository);
  });

  group('HiveMembersDataService', () {
    test('getMembersForGroup should return correct members', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach.name),
        HiveMember(id: '3', athleteId: 'a3', groupId: 'g2', role: GroupRole.athlete.name),
      ];
      when(mockBox.values).thenReturn(members);

      final result = await dataService.getMembersForGroup('g1');

      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[1].id, '2');
    });

    test('getMemberByAthleteAndGroup should return correct member', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach.name),
      ];
      when(mockBox.values).thenReturn(members);

      final result = await dataService.getMemberByAthleteAndGroup('a1', 'g1');

      expect(result?.id, '1');
      expect(result?.athleteId, 'a1');
      expect(result?.groupId, 'g1');
    });

    test('addMemberToGroup should add member to the box', () async {
      when(mockBox.put(any, any)).thenAnswer((_) => Future.value());

      final result = await dataService.addMemberToGroup('a1', 'g1', GroupRole.athlete);

      verify(mockBox.put(any, any)).called(1);
      expect(result.athleteId, 'a1');
      expect(result.groupId, 'g1');
      expect(result.role, GroupRole.athlete);
    });

    test('updateMemberRole should update member role', () async {
      final member = HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name);
      when(mockBox.get('1')).thenReturn(member);
      when(mockBox.put(any, any)).thenAnswer((_) => Future.value());

      final result = await dataService.updateMemberRole('1', GroupRole.coach);

      verify(mockBox.put('1', any)).called(1);
      expect(result.id, '1');
      expect(result.role, GroupRole.coach);
    });

    test('removeMembersFromGroup should remove all members when memberIds is "*"', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach.name),
        HiveMember(id: '3', athleteId: 'a3', groupId: 'g2', role: GroupRole.athlete.name),
      ];
      when(mockBox.values).thenReturn(members);
      when(mockBox.deleteAll(any)).thenAnswer((_) => Future.value());

      await dataService.removeMembersFromGroup('g1', '*');

      verify(mockBox.deleteAll(['1', '2'])).called(1);
    });

    test('getGroupsForAthlete should return correct groups', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'a1', groupId: 'g2', role: GroupRole.coach.name),
        HiveMember(id: '3', athleteId: 'a2', groupId: 'g1', role: GroupRole.athlete.name),
      ];
      when(mockBox.values).thenReturn(members);

      final result = await dataService.getGroupsForAthlete('a1');

      expect(result.length, 2);
      expect(result[0].groupId, 'g1');
      expect(result[1].groupId, 'g2');
    });

    test('isAthleteMemberOfGroup should return correct boolean', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach.name),
      ];
      when(mockBox.values).thenReturn(members);

      final result = await dataService.isAthleteMemberOfGroup('a1', 'g1');
      final result2 = await dataService.isAthleteMemberOfGroup('a3', 'g1');

      expect(result, true);
      expect(result2, false);
    });

    test('getMemberCountForGroup should return correct count', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach.name),
        HiveMember(id: '3', athleteId: 'a3', groupId: 'g2', role: GroupRole.athlete.name),
      ];
      when(mockBox.values).thenReturn(members);

      final result = await dataService.getMemberCountForGroup('g1');

      expect(result, 2);
    });

    test('getMembersForGroupPaginated should return correct page of members', () async {
      final members = List.generate(
        20,
        (index) => HiveMember(id: index.toString(), athleteId: 'a$index', groupId: 'g1', role: GroupRole.athlete.name),
      );
      when(mockBox.values).thenReturn(members);

      final result = await dataService.getMembersForGroupPaginated('g1', 1, 5);

      expect(result.length, 5);
      expect(result[0].id, '5');
      expect(result[4].id, '9');
    });

    test('searchMembersInGroup should return correct members', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'john', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'jane', groupId: 'g1', role: GroupRole.coach.name),
        HiveMember(id: '3', athleteId: 'bob', groupId: 'g1', role: GroupRole.athlete.name),
      ];
      when(mockBox.values).thenReturn(members);

      final result = await dataService.searchMembersInGroup('g1', 'jo');

      expect(result.length, 1);
      expect(result[0].athleteId, 'john');
    });

    test('batchAddMembersToGroup should add multiple members', () async {
      when(mockBox.put(any, any)).thenAnswer((_) => Future.value());

      final athleteIds = ['a1', 'a2', 'a3'];
      final result = await dataService.batchAddMembersToGroup('g1', athleteIds, GroupRole.athlete);

      verify(mockBox.put(any, any)).called(3);
      expect(result.length, 3);
      expect(result.every((member) => member.groupId == 'g1'), true);
      expect(result.every((member) => member.role == GroupRole.athlete), true);
    });

    test('batchRemoveMembersFromGroup should remove multiple members', () async {
      when(mockBox.deleteAll(any)).thenAnswer((_) => Future.value());

      await dataService.batchRemoveMembersFromGroup('g1', ['1', '2', '3']);

      verify(mockBox.deleteAll(['1', '2', '3'])).called(1);
    });

    test('getGroupsForAthletes should return correct groups for multiple athletes', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'a1', groupId: 'g2', role: GroupRole.coach.name),
        HiveMember(id: '3', athleteId: 'a2', groupId: 'g1', role: GroupRole.athlete.name),
      ];
      when(mockBox.values).thenReturn(members);

      final result = await dataService.getGroupsForAthletes(['a1', 'a2']);

      expect(result.length, 2);
      expect(result['a1']?.length, 2);
      expect(result['a2']?.length, 1);
    });

    test('areAthletesMembersOfGroup should return correct boolean for multiple athletes', () async {
      final members = [
        HiveMember(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete.name),
        HiveMember(id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach.name),
      ];
      when(mockBox.values).thenReturn(members);

      final result = await dataService.areAthletesMembersOfGroup(['a1', 'a2', 'a3'], 'g1');

      expect(result['a1'], true);
      expect(result['a2'], true);
      expect(result['a3'], false);
    });
  });
}
