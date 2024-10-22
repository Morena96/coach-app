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

/// Test suite for MembersImpl repository implementation
void main() {
  late MembersImpl membersRepository;
  late MockMembersService mockService;
  late MockLoggerRepository mockLoggerRepository;

  setUp(() {
    mockService = MockMembersService();
    mockLoggerRepository = MockLoggerRepository();
    membersRepository = MembersImpl(mockService, mockLoggerRepository);
  });

  group('MembersImpl -', () {
    group('getMembersForGroup', () {
      test('success - should return list of members', () async {
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

      test('failure - should log error and return failure result', () async {
        when(mockService.getMembersForGroup('g1'))
            .thenThrow(Exception('Failed to get members'));

        final result = await membersRepository.getMembersForGroup('g1');

        expect(result.isFailure, isTrue);
        expect(result.error, equals('Exception: Failed to get members'));
        verify(mockLoggerRepository.error('Exception: Failed to get members'))
            .called(1);
      });

      test('success - should handle empty list', () async {
        when(mockService.getMembersForGroup('g1'))
            .thenAnswer((_) => Future.value([]));

        final result = await membersRepository.getMembersForGroup('g1');

        expect(result.isSuccess, isTrue);
        expect(result.value, isEmpty);
      });
    });

    group('getMemberByAthleteAndGroup', () {
      test('success - should return member when found', () async {
        const member = Member(
            id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete);
        when(mockService.getMemberByAthleteAndGroup('a1', 'g1'))
            .thenAnswer((_) => Future.value(member));

        final result =
            await membersRepository.getMemberByAthleteAndGroup('a1', 'g1');

        expect(result.isSuccess, isTrue);
        expect(result.value, equals(member));
      });

      test('success - should return null when member not found', () async {
        when(mockService.getMemberByAthleteAndGroup('a1', 'g1'))
            .thenAnswer((_) => Future.value(null));

        final result =
            await membersRepository.getMemberByAthleteAndGroup('a1', 'g1');

        expect(result.isSuccess, isTrue);
        expect(result.value, isNull);
      });

      test('failure - should log error and return failure result', () async {
        when(mockService.getMemberByAthleteAndGroup('a1', 'g1'))
            .thenThrow(Exception('Member not found'));

        final result =
            await membersRepository.getMemberByAthleteAndGroup('a1', 'g1');

        expect(result.isFailure, isTrue);
        verify(mockLoggerRepository.error('Exception: Member not found'))
            .called(1);
      });
    });

    // Additional test groups for remaining methods...

    group('batchOperations', () {
      test('batchAddMembersToGroup - should handle empty athlete list',
          () async {
        when(mockService.batchAddMembersToGroup('g1', [], GroupRole.athlete))
            .thenAnswer((_) => Future.value([]));

        final result = await membersRepository.batchAddMembersToGroup(
            'g1', [], GroupRole.athlete);

        expect(result.isSuccess, isTrue);
        expect(result.value, isEmpty);
      });

      test('batchRemoveMembersFromGroup - should handle empty member list',
          () async {
        when(mockService.batchRemoveMembersFromGroup('g1', []))
            .thenAnswer((_) => Future.value());

        final result =
            await membersRepository.batchRemoveMembersFromGroup('g1', []);

        expect(result.isSuccess, isTrue);
      });

      test('batchAddGroupsToMember - should return failure when service throws',
          () async {
        when(mockService.batchAddGroupsToMember(
                'memberId', ['g1', 'g2'], GroupRole.athlete))
            .thenThrow(Exception('Failed to add groups'));

        final result = await membersRepository.batchAddGroupsToMember(
            'memberId', ['g1', 'g2'], GroupRole.athlete);

        expect(result.isFailure, isTrue);
        verify(mockLoggerRepository.error('Exception: Failed to add groups'))
            .called(1);
      });
    });

    group('searchMembersInGroup', () {
      test('should handle empty search term', () async {
        when(mockService.searchMembersInGroup('g1', ''))
            .thenAnswer((_) => Future.value([]));

        final result = await membersRepository.searchMembersInGroup('g1', '');

        expect(result.isSuccess, isTrue);
        expect(result.value, isEmpty);
      });

      test('should return matching members', () async {
        final members = [
          const Member(
              id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete)
        ];
        when(mockService.searchMembersInGroup('g1', 'John'))
            .thenAnswer((_) => Future.value(members));

        final result =
            await membersRepository.searchMembersInGroup('g1', 'John');

        expect(result.isSuccess, isTrue);
        expect(result.value, equals(members));
      });
    });

    group('pagination', () {
      test('getMembersForGroupPaginated - should handle empty page', () async {
        when(mockService.getMembersForGroupPaginated('g1', 1, 10))
            .thenAnswer((_) => Future.value([]));

        final result =
            await membersRepository.getMembersForGroupPaginated('g1', 1, 10);

        expect(result.isSuccess, isTrue);
        expect(result.value, isEmpty);
      });

      test('getMembersForGroupPaginated - should handle error', () async {
        when(mockService.getMembersForGroupPaginated('g1', 1, 10))
            .thenThrow(Exception('Pagination failed'));

        final result =
            await membersRepository.getMembersForGroupPaginated('g1', 1, 10);

        expect(result.isFailure, isTrue);
        verify(mockLoggerRepository.error('Exception: Pagination failed'))
            .called(1);
      });
    });
  });

  group('addMemberToGroup', () {
    test('success - should add member to group', () async {
      const member = Member(
        id: '1',
        athleteId: 'a1',
        groupId: 'g1',
        role: GroupRole.athlete,
      );
      when(mockService.addMemberToGroup('a1', 'g1', GroupRole.athlete))
          .thenAnswer((_) => Future.value(member));

      final result = await membersRepository.addMemberToGroup(
        'a1',
        'g1',
        GroupRole.athlete,
      );

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(member));
    });

    test('failure - should log error and return failure result', () async {
      when(mockService.addMemberToGroup('a1', 'g1', GroupRole.athlete))
          .thenThrow(Exception('Failed to add member'));

      final result = await membersRepository.addMemberToGroup(
        'a1',
        'g1',
        GroupRole.athlete,
      );

      expect(result.isFailure, isTrue);
      verify(mockLoggerRepository.error('Exception: Failed to add member'))
          .called(1);
    });
  });

  group('updateMemberRole', () {
    test('success - should update member role', () async {
      const updatedMember = Member(
        id: '1',
        athleteId: 'a1',
        groupId: 'g1',
        role: GroupRole.coach,
      );
      when(mockService.updateMemberRole('1', GroupRole.coach))
          .thenAnswer((_) => Future.value(updatedMember));

      final result = await membersRepository.updateMemberRole(
        '1',
        GroupRole.coach,
      );

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(updatedMember));
    });

    test('failure - should log error and return failure result', () async {
      when(mockService.updateMemberRole('1', GroupRole.coach))
          .thenThrow(Exception('Failed to update role'));

      final result = await membersRepository.updateMemberRole(
        '1',
        GroupRole.coach,
      );

      expect(result.isFailure, isTrue);
      verify(mockLoggerRepository.error('Exception: Failed to update role'))
          .called(1);
    });
  });

  group('removeMemberFromGroup', () {
    test('success - should remove member from group', () async {
      when(mockService.removeMembersFromGroup('g1', 'm1'))
          .thenAnswer((_) => Future.value());

      final result = await membersRepository.removeMemberFromGroup('g1', 'm1');

      expect(result.isSuccess, isTrue);
    });

    test('failure - should log error and return failure result', () async {
      when(mockService.removeMembersFromGroup('g1', 'm1'))
          .thenThrow(Exception('Failed to remove member'));

      final result = await membersRepository.removeMemberFromGroup('g1', 'm1');

      expect(result.isFailure, isTrue);
      verify(mockLoggerRepository.error('Exception: Failed to remove member'))
          .called(1);
    });
  });

  group('getGroupsForAthlete', () {
    test('success - should return list of groups', () async {
      final members = [
        const Member(
          id: '1',
          athleteId: 'a1',
          groupId: 'g1',
          role: GroupRole.athlete,
        ),
      ];
      when(mockService.getGroupsForAthlete('a1'))
          .thenAnswer((_) => Future.value(members));

      final result = await membersRepository.getGroupsForAthlete('a1');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(members));
    });

    test('failure - should log error and return failure result', () async {
      when(mockService.getGroupsForAthlete('a1'))
          .thenThrow(Exception('Failed to get groups'));

      final result = await membersRepository.getGroupsForAthlete('a1');

      expect(result.isFailure, isTrue);
      verify(mockLoggerRepository.error('Exception: Failed to get groups'))
          .called(1);
    });
  });

  group('isAthleteMemberOfGroup', () {
    test('success - should return membership status', () async {
      when(mockService.isAthleteMemberOfGroup('a1', 'g1'))
          .thenAnswer((_) => Future.value(true));

      final result = await membersRepository.isAthleteMemberOfGroup('a1', 'g1');

      expect(result.isSuccess, isTrue);
      expect(result.value, isTrue);
    });

    test('failure - should log error and return failure result', () async {
      when(mockService.isAthleteMemberOfGroup('a1', 'g1'))
          .thenThrow(Exception('Failed to check membership'));

      final result = await membersRepository.isAthleteMemberOfGroup('a1', 'g1');

      expect(result.isFailure, isTrue);
      verify(mockLoggerRepository
              .error('Exception: Failed to check membership'))
          .called(1);
    });
  });

  group('getMemberCountForGroup', () {
    test('success - should return member count', () async {
      when(mockService.getMemberCountForGroup('g1'))
          .thenAnswer((_) => Future.value(5));

      final result = await membersRepository.getMemberCountForGroup('g1');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(5));
    });

    test('failure - should log error and return failure result', () async {
      when(mockService.getMemberCountForGroup('g1'))
          .thenThrow(Exception('Failed to get count'));

      final result = await membersRepository.getMemberCountForGroup('g1');

      expect(result.isFailure, isTrue);
      verify(mockLoggerRepository.error('Exception: Failed to get count'))
          .called(1);
    });
  });

  group('areAthletesMembersOfGroup', () {
    test('success - should return membership status map', () async {
      final statusMap = {'a1': true, 'a2': false};
      when(mockService.areAthletesMembersOfGroup(['a1', 'a2'], 'g1'))
          .thenAnswer((_) => Future.value(statusMap));

      final result =
          await membersRepository.areAthletesMembersOfGroup(['a1', 'a2'], 'g1');

      expect(result.isSuccess, isTrue);
      expect(result.value, equals(statusMap));
    });

    test('failure - should log error and return failure result', () async {
      when(mockService.areAthletesMembersOfGroup(['a1', 'a2'], 'g1'))
          .thenThrow(Exception('Failed to check memberships'));

      final result =
          await membersRepository.areAthletesMembersOfGroup(['a1', 'a2'], 'g1');

      expect(result.isFailure, isTrue);
      verify(mockLoggerRepository
              .error('Exception: Failed to check memberships'))
          .called(1);
    });
  });
}
