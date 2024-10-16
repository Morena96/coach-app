import 'package:application/athletes/use_cases/delete_group_use_case.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'update_group_use_case_test.mocks.dart';

void main() {
  late DeleteGroupUseCase deleteGroupUseCase;
  late MockGroups mockGroups;

  setUp(() {
    mockGroups = MockGroups();
    deleteGroupUseCase = DeleteGroupUseCase(mockGroups);
  });

  group('DeleteGroupUseCase', () {
    test('should return Success when repository successfully deletes group',
        () async {
      // Arrange
      const groupId = '123';
      when(mockGroups.deleteGroup(groupId))
          .thenAnswer((_) async => Result.success(null));

      // Act
      final result = await deleteGroupUseCase.execute(groupId);

      // Assert
      expect(result.isSuccess, true);
      verify(mockGroups.deleteGroup(groupId)).called(1);
    });

    test('should return Failure when repository fails to delete group',
        () async {
      // Arrange
      const groupId = '123';
      const errorMessage = 'Failed to delete group';
      when(mockGroups.deleteGroup(groupId))
          .thenAnswer((_) async => Result.failure(errorMessage));

      // Act
      final result = await deleteGroupUseCase.execute(groupId);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, errorMessage);
      verify(mockGroups.deleteGroup(groupId)).called(1);
    });
  });
}
