import 'dart:io';

import 'package:application/avatars/use_cases/upload_avatar_use_case.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/hive_avatar.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/image_data_factory_impl.dart';
import 'package:coach_app/features/avatars/infrastructure/repositories/offline_first_avatar_repository.dart';
import 'package:coach_app/features/avatars/infrastructure/services/hive_avatar_database_service.dart';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_detector_impl.dart';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_service_impl.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/memory_file_system_service.dart';
import 'package:dio/dio.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late UploadAvatarUseCase uploadAvatarUseCase;
  late AvatarRepository avatarRepository;
  late Directory testDir;

  setUpAll(() async {
    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(HiveAvatarAdapter());

    // Get a directory that's safe to use in the app's sandbox
    final appSupportDir = await getApplicationSupportDirectory();
    testDir = Directory(path.join(appSupportDir.path, 'integration_test'));

    // Ensure the test directory exists
    if (!await testDir.exists()) {
      await testDir.create(recursive: true);
    }

    // Initialize the avatar repository and use case
    final hiveDatabaseService =
        HiveAvatarDatabaseService(await Hive.openBox('avatars_test'));
    final fileSystem = MemoryFileSystemService();
    final dio = Dio();
    final imageFormatService =
        ImageFormatServiceImpl(ImageFormatDetectorImpl());

    avatarRepository = OfflineFirstAvatarRepository(
        hiveDatabaseService, testDir, dio, fileSystem, imageFormatService);

    final imageDataFactory = ImageDataFactoryImpl();

    uploadAvatarUseCase =
        UploadAvatarUseCase(avatarRepository, imageDataFactory);
  });

  tearDownAll(() async {
    // Clean up: delete test data and close Hive
    await Hive.deleteFromDisk();
  });

  testWidgets('Upload avatar integration test', (WidgetTester tester) async {
    // Create a test image file
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

    // Verify that the test image file was created successfully
    expect(testImageFile.existsSync(), isTrue,
        reason: 'Test image file was not created');
    // Execute the use case
    const userId = 'test_user_123';
    final avatar = await uploadAvatarUseCase.execute(userId, testImageFile);
    // Verify the result
    expect(avatar, isNotNull);
    expect(avatar.id, equals(userId));
    expect(avatar.localPath, isNotEmpty);
    expect(avatar.lastUpdated, isNotNull);

    // Verify that the avatar was saved in the repository
    final savedImageData = await avatarRepository.getAvatarImage(avatar.id);
    expect(savedImageData, isNotNull);

    // Clean up: delete the test image file
    testImageFile.deleteSync();
  });
}
