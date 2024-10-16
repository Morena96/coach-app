import 'package:application/athletes/use_cases/is_athlete_member_of_group_use_case.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Members])
import 'is_athlete_member_of_group_use_case_test.mocks.dart';

void main() {
  late IsAthleteMemberOfGroupUseCase useCase;
  late MockMembers mockRepository;

  setUp(() {
    mockRepository = MockMembers();
    useCase = IsAthleteMemberOfGroupUseCase(mockRepository);
  });

  group('IsAthleteMemberOfGroupUseCase', () {
    test('should return true when the repository call is successful', () async {
      when(mockRepository.isAthleteMemberOfGroup('a1', 'g1')).thenAnswer((_) async => Result.success(true));

      final result = await useCase.execute('a1', 'g1');

      expect(result.isSuccess, true);
      expect(result.value, true);
      verify(mockRepository.isAthleteMemberOfGroup('a1', 'g1')).called(1);
    });

    test('should return a failure result when the repository call fails', () async {
      const errorMessage = 'Failed to check membership';
      when(mockRepository.isAthleteMemberOfGroup('a1', 'g1')).thenAnswer((_) async => Result.failure(errorMessage));

      final result = await useCase.execute('a1', 'g1');

      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockRepository.isAthleteMemberOfGroup('a1', 'g1')).called(1);
    });
  });
}