import 'package:application/athletes/use_cases/get_members_for_group_use_case.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Members, Athletes])
import 'get_members_for_group_use_case_test.mocks.dart';
void main() {
  late GetMembersForGroupUseCase useCase;
  late MockMembers mockMembersRepository;
  late MockAthletes mockAthletesRepository;

  setUp(() {
    mockMembersRepository = MockMembers();
    mockAthletesRepository = MockAthletes();
    useCase = GetMembersForGroupUseCase(mockMembersRepository, mockAthletesRepository);
  });

  group('GetMembersForGroupUseCase', () {
    test('should return a list of members with athletes when both repository calls are successful', () async {
      final members = [
        const Member(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete),
        const Member(id: '2', athleteId: 'a2', groupId: 'g1', role: GroupRole.coach),
      ];
      final athletes = [
        const Athlete(id: 'a1', name: 'Athlete 1'),
        const Athlete(id: 'a2', name: 'Athlete 2'),
      ];
      when(mockMembersRepository.getMembersForGroup('g1')).thenAnswer((_) async => Result.success(members));
      when(mockAthletesRepository.getAthletesByIds(['a1', 'a2'])).thenAnswer((_) async => Result.success(athletes));

      final result = await useCase.execute('g1');

      expect(result.isSuccess, true);
      expect(result.value!.length, 2);
      expect(result.value![0].member, members[0]);
      expect(result.value![0].athlete, athletes[0]);
      expect(result.value![1].member, members[1]);
      expect(result.value![1].athlete, athletes[1]);
      verify(mockMembersRepository.getMembersForGroup('g1')).called(1);
      verify(mockAthletesRepository.getAthletesByIds(['a1', 'a2'])).called(1);
    });

    test('should return a failure result when the members repository call fails', () async {
      const errorMessage = 'Failed to fetch members';
      when(mockMembersRepository.getMembersForGroup('g1')).thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute('g1');

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockMembersRepository.getMembersForGroup('g1')).called(1);
      verifyZeroInteractions(mockAthletesRepository);
    });

    test('should return a failure result when the athletes repository call fails', () async {
      final members = [
        const Member(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete),
      ];
      const errorMessage = 'Failed to fetch athletes';
      when(mockMembersRepository.getMembersForGroup('g1')).thenAnswer((_) async => Result.success(members));
      when(mockAthletesRepository.getAthletesByIds(['a1'])).thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute('g1');

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockMembersRepository.getMembersForGroup('g1')).called(1);
      verify(mockAthletesRepository.getAthletesByIds(['a1'])).called(1);
    });
  });
}