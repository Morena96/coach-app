import 'package:application/athletes/use_cases/get_member_by_athlete_and_group_use_case.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Members])
import 'get_member_by_athlete_and_group_use_case_test.mocks.dart';

void main() {
  late GetMemberByAthleteAndGroupUseCase useCase;
  late MockMembers mockRepository;

  setUp(() {
    mockRepository = MockMembers();
    useCase = GetMemberByAthleteAndGroupUseCase(mockRepository);
  });

  group('GetMemberByAthleteAndGroupUseCase', () {
    test('should return a member when the repository call is successful', () async {
      const member = Member(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete);
      when(mockRepository.getMemberByAthleteAndGroup('a1', 'g1')).thenAnswer((_) async => Result.success(member));

      final result = await useCase.execute('a1', 'g1');

      expect(result.isSuccess, true);
      expect(result.value, member);
      verify(mockRepository.getMemberByAthleteAndGroup('a1', 'g1')).called(1);
    });

    test('should return a failure result when the repository call fails', () async {
      const errorMessage = 'Failed to fetch member';
      when(mockRepository.getMemberByAthleteAndGroup('a1', 'g1')).thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute('a1', 'g1');

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.getMemberByAthleteAndGroup('a1', 'g1')).called(1);
    });
  });
}