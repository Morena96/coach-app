import 'package:application/athletes/use_cases/get_groups_for_athlete_use_case.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Members])
import 'get_groups_for_athlete_use_case_test.mocks.dart';

void main() {
  late GetGroupsForAthleteUseCase useCase;
  late MockMembers mockRepository;

  setUp(() {
    mockRepository = MockMembers();
    useCase = GetGroupsForAthleteUseCase(mockRepository);
  });

  group('GetGroupsForAthleteUseCase', () {
    test('should return a list of groups when the repository call is successful', () async {
      final members = [
        const Member(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete),
        const Member(id: '2', athleteId: 'a1', groupId: 'g2', role: GroupRole.coach),
      ];
      when(mockRepository.getGroupsForAthlete('a1')).thenAnswer((_) async => Result.success(members));

      final result = await useCase.execute('a1');

      expect(result.isSuccess, true);
      expect(result.value, members);
      verify(mockRepository.getGroupsForAthlete('a1')).called(1);
    });

    test('should return a failure result when the repository call fails', () async {
      const errorMessage = 'Failed to fetch groups';
      when(mockRepository.getGroupsForAthlete('a1')).thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute('a1');

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.getGroupsForAthlete('a1')).called(1);
    });
  });
}