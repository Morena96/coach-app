import 'package:application/athletes/use_cases/add_member_to_group_use_case.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Members])
import 'add_member_to_group_use_case_test.mocks.dart';

void main() {
  late AddMemberToGroupUseCase useCase;
  late MockMembers mockRepository;

  setUp(() {
    mockRepository = MockMembers();
    useCase = AddMemberToGroupUseCase(mockRepository);
  });

  group('AddMemberToGroupUseCase', () {
    test('should return a member when the repository call is successful', () async {
      const member = Member(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.athlete);
      when(mockRepository.addMemberToGroup('a1', 'g1', GroupRole.athlete)).thenAnswer((_) async => Result.success(member));

      final result = await useCase.execute('a1', 'g1', GroupRole.athlete);

      expect(result.isSuccess, true);
      expect(result.value, member);
      verify(mockRepository.addMemberToGroup('a1', 'g1', GroupRole.athlete)).called(1);
    });

    test('should return a failure result when the repository call fails', () async {
      const errorMessage = 'Failed to add member';
      when(mockRepository.addMemberToGroup('a1', 'g1', GroupRole.athlete)).thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute('a1', 'g1', GroupRole.athlete);

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.addMemberToGroup('a1', 'g1', GroupRole.athlete)).called(1);
    });
  });
}