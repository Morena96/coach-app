import 'package:application/athletes/use_cases/update_group_use_case.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/athletes/services/group_validation_service.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/utilities/validation/validation_error.dart';
import 'package:domain/features/shared/utilities/validation/validation_result.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([Groups, GroupValidationService, AvatarRepository])
import 'update_group_use_case_test.mocks.dart';
import 'image_mocks.dart';

void main() {
  late UpdateGroupUseCase updateGroupUseCase;
  late MockGroups mockGroupRepository;
  late MockGroupValidationService mockValidationService;
  late MockAvatarRepository mockAvatarRepository;

  setUp(() {
    mockGroupRepository = MockGroups();
    mockValidationService = MockGroupValidationService();
    mockAvatarRepository = MockAvatarRepository();
    updateGroupUseCase = UpdateGroupUseCase(
      mockGroupRepository,
      mockValidationService,
      mockAvatarRepository,
    );
  });

  group('UpdateGroupUseCase', () {
    const group = Group(
      id: '1',
      name: 'Test Group',
      
    );

    final validGroupData = {
      'name': 'Updated Test Group',
      'description': 'Updated description',
    };

    test('should update group when data is valid and no avatar is provided',
        () async {
      // Arrange
      when(mockValidationService.validateGroupData(validGroupData))
          .thenReturn(ValidationResult.valid());
      when(mockGroupRepository.updateGroup(any))
          .thenAnswer((_) async => Result.success(null));

      // Act
      final result =
          await updateGroupUseCase.execute(group, validGroupData, null);

      // Assert
      expect(result.isSuccess, true);
      verify(mockValidationService.validateGroupData(validGroupData)).called(1);
      verify(mockGroupRepository.updateGroup(any)).called(1);
    });

    test('should return failure when group data is invalid', () async {
      // Arrange
      final invalidGroupData = {'name': ''};
      when(mockValidationService.validateGroupData(invalidGroupData))
          .thenReturn(ValidationResult.invalid(
              [ValidationError('name', 'Group name cannot be empty')]));

      // Act
      final result =
          await updateGroupUseCase.execute(group, invalidGroupData, null);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Group name cannot be empty');
      verify(mockValidationService.validateGroupData(invalidGroupData))
          .called(1);
      verifyNever(mockGroupRepository.updateGroup(any));
    });

    test('should update group with avatar when avatar is provided', () async {
      // Arrange
      var imageDataFactory = MockImageDataFactory();
      var avatarImage = imageDataFactory.createFromBytes([1, 2, 3]);
      final avatar = Avatar(
        id: 'avatar1',
        localPath: 'path/to/avatar.jpg',
        syncStatus: SyncStatus.synced,
        lastUpdated: DateTime.now(),
      );

      when(mockValidationService.validateGroupData(validGroupData))
          .thenReturn(ValidationResult.valid());
      when(mockAvatarRepository.saveAvatar(group.id, avatarImage))
          .thenAnswer((_) async => avatar);
      when(mockGroupRepository.updateGroup(any))
          .thenAnswer((_) async => Result.success(null));

      // Act
      final result =
          await updateGroupUseCase.execute(group, validGroupData, avatarImage);

      // Assert
      expect(result.isSuccess, true);
      verify(mockValidationService.validateGroupData(validGroupData)).called(1);
      verify(mockAvatarRepository.saveAvatar(group.id, avatarImage)).called(1);
      verify(mockGroupRepository.updateGroup(any)).called(1);
    });

    test('should return failure when repository update fails', () async {
      // Arrange
      when(mockValidationService.validateGroupData(validGroupData))
          .thenReturn(ValidationResult.valid());
      when(mockGroupRepository.updateGroup(any))
          .thenAnswer((_) async => Result.failure('Update failed'));

      // Act
      final result =
          await updateGroupUseCase.execute(group, validGroupData, null);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Update failed');
      verify(mockValidationService.validateGroupData(validGroupData)).called(1);
      verify(mockGroupRepository.updateGroup(any)).called(1);
    });
  });
}
