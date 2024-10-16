import 'package:coach_app/features/athletes/infrastructure/repositories/members_impl.dart';
import 'package:domain/features/athletes/data/members_service.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([MembersService, LoggerRepository])
import 'members_impl_test.mocks.dart';

void main() {
  late MembersImpl membersRepository;
  late MockMembersService mockService;
  late MockLoggerRepository mockLoggerRepository;

  setUp(() {
    mockService = MockMembersService();
    mockLoggerRepository = MockLoggerRepository();
    membersRepository = MembersImpl(mockService, mockLoggerRepository);
  });

  group('MembersImpl', () {
    test('getMembersForGroup should return success result with list of members',
        () async {
      final members = [
        const Member(
            id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete),
        const Member(
            id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach),
      ];
      when(mockService.getMembersForGroup('g1'))
          .thenAnswer((_) => Future.value(members));

      final result = await membersRepository.getMembersForGroup('g1');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(members));
    });

    test('getMembersForGroup should return failure result when an error occurs',
        () async {
      when(mockService.getMembersForGroup('g1'))
          .thenThrow(Exception('Failed to get members'));

      final result = await membersRepository.getMembersForGroup('g1');

      expect(result.isFailure, isTrue);
      expect(result.error, equals('Exception: Failed to get members'));
    });

    test(
        'getMemberByAthleteAndGroup should return success result with correct member',
        () async {
      const member = Member(
          id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete);
      when(mockService.getMemberByAthleteAndGroup('a1', 'g1'))
          .thenAnswer((_) => Future.value(member));

      final result =
          await membersRepository.getMemberByAthleteAndGroup('a1', 'g1');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(member));
    });

    test('addMemberToGroup should return success result when member is added',
        () async {
      const member = Member(
          id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete);
      when(mockService.addMemberToGroup('a1', 'g1', GroupRole.athlete))
          .thenAnswer((_) => Future.value(member));

      final result = await membersRepository.addMemberToGroup(
          'a1', 'g1', GroupRole.athlete);

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(member));
    });

    test('updateMemberRole should return success result when role is updated',
        () async {
      const updatedMember = Member(
          id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.coach);
      when(mockService.updateMemberRole('1', GroupRole.coach))
          .thenAnswer((_) => Future.value(updatedMember));

      final result =
          await membersRepository.updateMemberRole('1', GroupRole.coach);

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(updatedMember));
    });

    test(
        'removeMemberFromGroup should return success result when member is removed',
        () async {
      when(mockService.removeMembersFromGroup('1', '1'))
          .thenAnswer((_) => Future.value());

      final result = await membersRepository.removeMemberFromGroup('1', '1');

      expect(result.isSuccess, isTrue);
    });

    test(
        'getGroupsForAthlete should return success result with list of members',
        () async {
      final members = [
        const Member(
            id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete),
        const Member(
            id: '2', athleteId: 'a1', groupId: 'g2', role: GroupRole.coach),
      ];
      when(mockService.getGroupsForAthlete('a1'))
          .thenAnswer((_) => Future.value(members));

      final result = await membersRepository.getGroupsForAthlete('a1');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(members));
    });

    test(
        'isAthleteMemberOfGroup should return success result with correct boolean',
        () async {
      when(mockService.isAthleteMemberOfGroup('a1', 'g1'))
          .thenAnswer((_) => Future.value(true));

      final result = await membersRepository.isAthleteMemberOfGroup('a1', 'g1');

      expect(result.isSuccess, isTrue);
      expect(result.value, isTrue);
    });

    test(
        'getMemberCountForGroup should return success result with correct count',
        () async {
      when(mockService.getMemberCountForGroup('g1'))
          .thenAnswer((_) => Future.value(5));

      final result = await membersRepository.getMemberCountForGroup('g1');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(5));
    });

    test(
        'getMembersForGroupPaginated should return success result with correct page of members',
        () async {
      final members = List.generate(
        5,
        (index) => Member(
            id: index.toString(),
            athleteId: 'a$index',
            groupId: 'g1',
            role: GroupRole.athlete),
      );
      when(mockService.getMembersForGroupPaginated('g1', 1, 5))
          .thenAnswer((_) => Future.value(members));

      final result =
          await membersRepository.getMembersForGroupPaginated('g1', 1, 5);

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(members));
    });

    test(
        'searchMembersInGroup should return success result with correct members',
        () async {
      final members = [
        const Member(
            id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete),
        const Member(
            id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach),
      ];
      when(mockService.searchMembersInGroup('g1', 'John'))
          .thenAnswer((_) => Future.value(members));

      final result = await membersRepository.searchMembersInGroup('g1', 'John');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(members));
    });

    test(
        'batchAddMembersToGroup should return success result with added members',
        () async {
      final members = [
        const Member(
            id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete),
        const Member(
            id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.athlete),
      ];
      when(mockService.batchAddMembersToGroup(
              'g1', ['a1', 'a2'], GroupRole.athlete))
          .thenAnswer((_) => Future.value(members));

      final result = await membersRepository.batchAddMembersToGroup(
          'g1', ['a1', 'a2'], GroupRole.athlete);

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(members));
    });

    test(
        'batchRemoveMembersFromGroup should return success result when members are removed',
        () async {
      when(mockService.batchRemoveMembersFromGroup('g1', ['1', '2']))
          .thenAnswer((_) => Future.value());

      final result =
          await membersRepository.batchRemoveMembersFromGroup('g1', ['1', '2']);

      expect(result.isSuccess, isTrue);
    });

    test('should return success result with correct membership status',
        () async {
      final athleteIds = ['a1', 'a2', 'a3'];
      const groupId = 'g1';
      final expectedMembershipStatus = {
        'a1': true,
        'a2': false,
        'a3': true,
      };

      when(mockService.areAthletesMembersOfGroup(athleteIds, groupId))
          .thenAnswer((_) => Future.value(expectedMembershipStatus));

      final result = await membersRepository.areAthletesMembersOfGroup(
          athleteIds, groupId);

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(expectedMembershipStatus));
      verify(mockService.areAthletesMembersOfGroup(athleteIds, groupId))
          .called(1);
    });

    test('should handle empty list of athlete IDs', () async {
      final athleteIds = <String>[];
      const groupId = 'g1';

      when(mockService.areAthletesMembersOfGroup(athleteIds, groupId))
          .thenAnswer((_) => Future.value({}));

      final result = await membersRepository.areAthletesMembersOfGroup(
          athleteIds, groupId);

      expect(result.isSuccess, isTrue);
      expect(result.value, isEmpty);
    });
  });
}
