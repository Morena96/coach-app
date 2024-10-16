import 'package:application/athletes/use_cases/get_member_count_for_group_use_case.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Members])
import 'get_member_count_for_group_use_case_test.mocks.dart';

void main() {
  late GetMemberCountForGroupUseCase useCase;
  late MockMembers mockRepository;

  setUp(() {
    mockRepository = MockMembers();
    useCase = GetMemberCountForGroupUseCase(mockRepository);
  });

  group('GetMemberCountForGroupUseCase', () {
    test('should return the member count when the repository call is successful', () async {
      const groupId = 'g1';
      const memberCount = 5;
      when(mockRepository.getMemberCountForGroup(groupId)).thenAnswer((_) async => Result.success(memberCount));

      final result = await useCase.execute(groupId);

      expect(result.isSuccess, true);
      expect(result.value, memberCount);
      verify(mockRepository.getMemberCountForGroup(groupId)).called(1);
    });

    test('should return a failure result when the repository call fails', () async {
      const groupId = 'g1';
      const errorMessage = 'Failed to fetch member count';
      when(mockRepository.getMemberCountForGroup(groupId)).thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute(groupId);

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.getMemberCountForGroup(groupId)).called(1);
    });
  });
}