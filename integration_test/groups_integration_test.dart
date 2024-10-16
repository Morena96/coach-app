import 'dart:io';

import 'package:application/athletes/use_cases/create_group_use_case.dart';
import 'package:application/athletes/use_cases/get_all_groups_use_case.dart';
import 'package:dio/dio.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:coach_app/features/athletes/infrastructure/adapters/form_validators_adapter.dart';
import 'package:coach_app/features/athletes/infrastructure/data/hive_groups_data_service.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_athlete.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_group.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_member.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_sport.dart';
import 'package:coach_app/features/athletes/infrastructure/data/uuid_id_generator.dart';
import 'package:coach_app/features/athletes/infrastructure/repositories/groups_impl.dart';
import 'package:coach_app/features/athletes/infrastructure/services/groups_validation_service_impl.dart';
import 'package:coach_app/features/athletes/infrastructure/services/in_memory_group_roles_service.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/hive_avatar.dart';
import 'package:coach_app/features/avatars/infrastructure/models/file_image_data.dart';
import 'package:coach_app/features/avatars/infrastructure/repositories/offline_first_avatar_repository.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_database_service.dart';
import 'package:coach_app/features/avatars/infrastructure/services/hive_avatar_database_service.dart';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_detector_impl.dart';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_service_impl.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/file_system.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/io_file_system_service.dart';

import '../test/unit/shared/logger/logger_test.dart';

void main() {
  late Box<HiveGroup> groupsBox;
  late HiveGroupsDataService groupsDataService;
  late GroupsImpl groupsRepository;
  late CreateGroupUseCase createGroupUseCase;
  late GetAllGroupsUseCase getAllGroupsUseCase;
  late Box<HiveAvatar> avatarsBox;
  late Dio dio;
  late Directory testDir;
  late FileSystemService fileSystem;

  setUpAll(() async {
    final tempDir = await getTemporaryDirectory();
    testDir = Directory(path.join(tempDir.path, 'groups_integration_test'));
    Hive.init(path.join(tempDir.path, 'hive_tests'));
    if (!await testDir.exists()) {
      await testDir.create(recursive: true);
    }
    Hive.registerAdapter(HiveGroupAdapter());
    Hive.registerAdapter(HiveMemberAdapter());
    Hive.registerAdapter(HiveAthleteAdapter());
    Hive.registerAdapter(HiveAvatarAdapter());
    Hive.registerAdapter(HiveSportAdapter());
    groupsBox = await Hive.openBox<HiveGroup>('groups_test');
    avatarsBox = await Hive.openBox<HiveAvatar>('avatars_test');
    var logger = MockLogger();
    dio = Dio();
    fileSystem = IoFileSystemService();

    groupsDataService = HiveGroupsDataService()
      ..groupsBox = groupsBox
      ..loggerRepository = logger;

    final idGenerator = UuidIdGenerator();

    final groupsRolesService = InMemoryGroupRolesService();

    groupsRepository =
        GroupsImpl(groupsDataService, logger, idGenerator, groupsRolesService);
    AvatarDatabaseService avatarDb = HiveAvatarDatabaseService(avatarsBox);

    AvatarRepository avatarRepository = OfflineFirstAvatarRepository(
        avatarDb,
        tempDir,
        dio,
        fileSystem,
        ImageFormatServiceImpl(ImageFormatDetectorImpl()));

    createGroupUseCase = CreateGroupUseCase(groupsRepository, avatarRepository,
        GroupsValidationServiceImpl(FormValidatorsAdapter()));
    getAllGroupsUseCase = GetAllGroupsUseCase(groupsRepository);
  });

  tearDownAll(() async {
    await groupsBox.clear();
    await groupsBox.close();
    await Hive.deleteFromDisk();
  });

  group('Group Feature Integration Tests', () {
    test('Add an athlete to a group', () async {
      const groupName = 'Athletes Group';
      final groupData = {
        'name': groupName,
        'description': 'A group for athletes',
        'sport': const Sport(id: '1', name: 'Running'),
      };
      final createdGroup = await createGroupUseCase.execute(
        groupData,
        groupName,
        'A group for athletes',
        const Sport(id: '1', name: 'Running'),
      );

      final updatedGroup =
          await groupsRepository.getGroupById(createdGroup.value!.id);

      expect(updatedGroup.isSuccess, isTrue);
    });

    test('Create multiple groups and retrieve them all', () async {
      await createGroupUseCase.execute(
        {'name': 'Group 1'},
        'Group 1',
        'Description for Group 1',
        const Sport(id: '1', name: 'Running'),
      );
      await createGroupUseCase.execute(
        {'name': 'Group 2'},
        'Group 2',
        'Description for Group 2',
        const Sport(id: '2', name: 'Swimming'),
      );
      await createGroupUseCase.execute(
        {'name': 'Group 3'},
        'Group 3',
        'Description for Group 3',
        const Sport(id: '3', name: 'Cycling'),
      );

      final allGroups = await getAllGroupsUseCase.execute();
      expect(allGroups.value!.length, greaterThanOrEqualTo(3));
      expect(allGroups.value!.map((g) => g.name),
          containsAll(['Group 1', 'Group 2', 'Group 3']));
    });

    test('Create a group with the same name', () async {
      const groupName = 'Duplicate Group';
      await createGroupUseCase.execute(
        {'name': groupName},
        groupName,
        'First duplicate group',
        const Sport(id: '1', name: 'Running'),
      );
      await createGroupUseCase.execute(
        {'name': groupName},
        groupName,
        'Second duplicate group',
        const Sport(id: '2', name: 'Swimming'),
      );

      final allGroups = await getAllGroupsUseCase.execute();
      final duplicateGroups =
          allGroups.value!.where((g) => g.name == groupName);
      expect(duplicateGroups.length, equals(2));
    });

    test('Can add avatar to a group', () async {
      final testImagePath = path.join(testDir.path, 'test_avatar.png');
      final testImageFile = File(testImagePath);
      testImageFile.create();
      final bytes = [
        0x89,
        0x50,
        0x4E,
        0x47,
        0x0D,
        0x0A,
        0x1A,
        0x0A,
        0x00,
        0x00,
        0x00,
        0x0D,
        0x49,
        0x48,
        0x44,
        0x52,
        0x00,
        0x00,
        0x00,
        0x01,
        0x00,
        0x00,
        0x00,
        0x01,
        0x08,
        0x04,
        0x00,
        0x00,
        0x00,
        0xB5,
        0x1C,
        0x0C,
        0x02,
        0x00,
        0x00,
        0x00,
        0x0B,
        0x49,
        0x44,
        0x41,
        0x54,
        0x78,
        0xDA,
        0x63,
        0x64,
        0xF8,
        0x0F,
        0x00,
        0x01,
        0x05,
        0x01,
        0x01,
        0x27,
        0x18,
        0xE3,
        0x66,
        0x00,
        0x00,
        0x00,
        0x00,
        0x49,
        0x45,
        0x4E,
        0x44,
        0xAE,
        0x42,
        0x60,
        0x82
      ];
      await testImageFile.writeAsBytes(bytes); // Dummy image data

      expect(testImageFile.existsSync(), isTrue,
          reason: 'Test image file was not created');

      final ImageData imageData = FileImageData(testImageFile);

      final group = await createGroupUseCase.execute(
        {'name': 'Group with Avatar'},
        'Group with Avatar',
        'A group with an avatar',
        const Sport(id: '1', name: 'Running'),
        avatarImage: imageData,
      );

      expect(group.isSuccess, isTrue);
      expect(group.value!.avatarId, isNotNull);
    });
  });
}
