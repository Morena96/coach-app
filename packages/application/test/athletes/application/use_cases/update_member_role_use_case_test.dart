import 'package:application/athletes/use_cases/update_member_role_use_case.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Members])
import 'update_member_role_use_case_test.mocks.dart';

void main() {
  late UpdateMemberRoleUseCase useCase;
  late MockMembers mockRepository;

  setUp(() {
    mockRepository = MockMembers();
    useCase = UpdateMemberRoleUseCase(mockRepository);
  });

  group('UpdateMemberRoleUseCase', () {
    test('should return an updated member when the repository call is successful', () async {
      const updatedMember = Member(id: '1', athleteId: 'a1', groupId: 'g1', role: GroupRole.coach);
      when(mockRepository.updateMemberRole('1', GroupRole.coach)).thenAnswer((_) async => Result.success(updatedMember));

      final result = await useCase.execute('1', GroupRole.coach);

      expect(result.isSuccess, true);
      expect(result.value, updatedMember);
      verify(mockRepository.updateMemberRole('1', GroupRole.coach)).called(1);
    });

    test('should return a failure result when the repository call fails', () async {
      const errorMessage = 'Failed to update member role';
      when(mockRepository.updateMemberRole('1', GroupRole.coach)).thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute('1', GroupRole.coach);

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.updateMemberRole('1', GroupRole.coach)).called(1);
    });
  });
}