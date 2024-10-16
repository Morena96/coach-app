import 'package:application/athletes/use_cases/remove_member_from_group_use_case.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Members])
import 'remove_member_from_group_use_case_test.mocks.dart';

void main() {
  late RemoveMemberFromGroupUseCase useCase;
  late MockMembers mockRepository;

  setUp(() {
    mockRepository = MockMembers();
    useCase = RemoveMemberFromGroupUseCase(mockRepository);
  });

  group('RemoveMemberFromGroupUseCase', () {
    const groupId = '1';
    const memberIds = '2,3,4';

    test('should return success when the repository call is successful',
        () async {
      when(mockRepository.removeMemberFromGroup(groupId, memberIds))
          .thenAnswer((_) async => Result.success(null));

      final result = await useCase.execute(groupId, memberIds);

      expect(result.isSuccess, true);
      verify(mockRepository.removeMemberFromGroup(groupId, memberIds))
          .called(1);
    });

    test('should return a failure result when the repository call fails',
        () async {
      const errorMessage = 'Failed to remove members';
      when(mockRepository.removeMemberFromGroup(groupId, memberIds))
          .thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute(groupId, memberIds);

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.removeMemberFromGroup(groupId, memberIds))
          .called(1);
    });

    test('should pass empty string for memberIds when not provided', () async {
      when(mockRepository.removeMemberFromGroup(groupId, ''))
          .thenAnswer((_) async => Result.success(null));

      final result = await useCase.execute(groupId, '');

      expect(result.isSuccess, true);
      verify(mockRepository.removeMemberFromGroup(groupId, '')).called(1);
    });

    test('should handle multiple member IDs correctly', () async {
      const multipleIds = '2,3,4,5,6';
      when(mockRepository.removeMemberFromGroup(groupId, multipleIds))
          .thenAnswer((_) async => Result.success(null));

      final result = await useCase.execute(groupId, multipleIds);

      expect(result.isSuccess, true);
      verify(mockRepository.removeMemberFromGroup(groupId, multipleIds))
          .called(1);
    });
  });
}
