import 'package:application/athletes/use_cases/create_group_use_case.dart';
import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/entities/sport.dart';
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

@GenerateMocks([Groups, AvatarRepository, GroupValidationService])
import 'create_group_use_case_test.mocks.dart';
import 'image_mocks.dart';

void main() {
  late CreateGroupUseCase useCase;
  late MockGroups mockRepository;
  late MockGroupValidationService mockValidationService;
  late MockAvatarRepository mockAvatarRepository;

  setUp(() {
    mockRepository = MockGroups();
    mockValidationService = MockGroupValidationService();
    mockAvatarRepository = MockAvatarRepository();
    useCase = CreateGroupUseCase(
      mockRepository,
      mockAvatarRepository,
      mockValidationService,
    );
  });

  group('CreateGroupUseCase', () {
    final validGroupData = {
      'name': 'Test Group',
      'description': 'Test Description',
      'sport': const Sport(id: '1', name: 'Football'),
    };

    test('should create a new group when data is valid', () async {
      // Arrange
      final group = Group(
        id: '1',
        name: validGroupData['name'] as String,
        description: validGroupData['description'] as String,
        sport: validGroupData['sport'] as Sport,
      );

      when(mockValidationService.validateGroupData(validGroupData))
          .thenReturn(ValidationResult.valid());
      when(mockRepository.createGroup(
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
      )).thenAnswer((_) async => Result.success(group));

      // Act
      final result = await useCase.execute(
        validGroupData,
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
      );

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, group);
      verify(mockValidationService.validateGroupData(validGroupData)).called(1);
      verify(mockRepository.createGroup(
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
      )).called(1);
    });

    test('should return failure when group data is invalid', () async {
      // Arrange
      final invalidGroupData = {
        'name': '',
        'description': 'Test Description',
        'sport': const Sport(id: '1', name: 'Football'),
      };
      final validationErrors = [
        ValidationError('name', 'Group name cannot be empty')
      ];

      when(mockValidationService.validateGroupData(invalidGroupData))
          .thenReturn(ValidationResult.invalid(validationErrors));

      // Act
      final result = await useCase.execute(
        invalidGroupData,
        invalidGroupData['name'] as String,
        invalidGroupData['description'] as String,
        invalidGroupData['sport'] as Sport,
      );

      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Group name cannot be empty');
      verify(mockValidationService.validateGroupData(invalidGroupData))
          .called(1);
      verifyNever(mockRepository.createGroup(any, any, any));
    });

    test('should return failure when repository fails', () async {
      // Arrange
      when(mockValidationService.validateGroupData(validGroupData))
          .thenReturn(ValidationResult.valid());
      when(mockRepository.createGroup(
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
      )).thenAnswer((_) async => Result.failure('Database error'));

      // Act
      final result = await useCase.execute(
        validGroupData,
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
      );

      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Database error');
      verify(mockValidationService.validateGroupData(validGroupData)).called(1);
      verify(mockRepository.createGroup(
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
      )).called(1);
    });

    test('should create group with avatar when avatar is provided', () async {
      // Arrange
      final group = Group(
        id: '1',
        name: validGroupData['name'] as String,
        description: validGroupData['description'] as String,
        sport: validGroupData['sport'] as Sport,
      );
      final avatar = Avatar(
        id: 'avatar1',
        localPath: 'path/to/avatar.jpg',
        syncStatus: SyncStatus.synced,
        lastUpdated: DateTime.now(),
      );
      var imageDataFactory = MockImageDataFactory();
      var avatarImage = imageDataFactory.createFromBytes([1, 2, 3]);

      when(mockValidationService.validateGroupData(validGroupData))
          .thenReturn(ValidationResult.valid());
      when(mockRepository.createGroup(
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
      )).thenAnswer((_) async => Result.success(group));
      when(mockAvatarRepository.saveAvatar(group.id, avatarImage))
          .thenAnswer((_) async => avatar);
      when(mockRepository.updateGroup(any)).thenAnswer(
          (_) async => Result.success(group.copyWith(avatarId: avatar.id)));

      // Act
      final result = await useCase.execute(
        validGroupData,
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
        avatarImage: avatarImage,
      );

      // Assert
      expect(result.isSuccess, true);
      expect(result.value?.avatarId, avatar.id);
      verify(mockValidationService.validateGroupData(validGroupData)).called(1);
      verify(mockRepository.createGroup(
        validGroupData['name'] as String,
        validGroupData['description'] as String,
        validGroupData['sport'] as Sport,
      )).called(1);
      verify(mockAvatarRepository.saveAvatar(group.id, avatarImage)).called(1);
      verify(mockRepository.updateGroup(any)).called(1);
    });
  });
}
