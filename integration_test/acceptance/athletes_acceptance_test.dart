import 'dart:io';

import 'package:coach_app/features/athletes/infrastructure/data/models/hive_athlete.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_group.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_member.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_sport.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_groups_service.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_members_service_impl.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_sports_service.dart';
import 'package:coach_app/features/athletes/infrastructure/services/in_memory_group_roles_service.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/hive_avatar.dart';
import 'package:coach_app/features/avatars/infrastructure/repositories/offline_first_avatar_repository.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_generator_service.dart';
import 'package:coach_app/features/avatars/infrastructure/services/hive_avatar_database_service.dart';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_detector_impl.dart';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_service_impl.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';
import 'package:coach_app/features/shared/infrastructure/file_system/memory_file_system_service.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:coach_app/shared/providers/settings_box_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;

import 'package:coach_app/app.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_athletes_service.dart';
import 'package:coach_app/features/athletes/infrastructure/repositories/athletes_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_list_view.dart';
import 'package:coach_app/shared/services/logging/mock_logger.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveAvatarAdapter());
    Hive.registerAdapter(HiveAthleteAdapter());
    Hive.registerAdapter(HiveSettingAdapter());
    Hive.registerAdapter(HiveGroupAdapter());
    Hive.registerAdapter(HiveMemberAdapter());
    Hive.registerAdapter(HiveSportAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('Athletes Acceptance Tests', () {
    testWidgets('User can visit athletes page and delete an athlete',
        (WidgetTester tester) async {
      final avatarBox = await Hive.openBox<HiveAvatar>('avatars');
      final settingsBox = await Hive.openBox<HiveSetting>('settings');
      final fakeSportsService = FakeSportsService();
      final avatarGenerator = FakeAvatarGeneratorService();
      
      final fileSystem = MemoryFileSystemService();
      // Get a directory that's safe to use in the app's sandbox
      final appSupportDir = await getApplicationSupportDirectory();
      final testDir =
          Directory(path.join(appSupportDir.path, 'integration_test'));

      // Ensure the test directory exists
      if (!await testDir.exists()) {
        await testDir.create(recursive: true);
      }
      final dio = Dio();
      final hiveDatabaseService =
          HiveAvatarDatabaseService(avatarBox);
      final avatarRepository = OfflineFirstAvatarRepository(
          hiveDatabaseService,
          testDir,
          dio,
          fileSystem,
          ImageFormatServiceImpl(ImageFormatDetectorImpl()));
      final fakeAthletesService = FakeAthletesService(
          fakeSportsService, avatarGenerator, avatarRepository);
      
      final fakeGroupRolesService = InMemoryGroupRolesService();
      final fakeGroupsService = FakeGroupsService(avatarGenerator, avatarRepository, fakeSportsService);
      final fakeMembersService = FakeMembersServiceImpl(fakeAthletesService, fakeGroupsService, fakeGroupRolesService);
      await fakeAthletesService.resetAndRefreshDatabase();
      final fakeLogger = MockLogger();
      final athletesImpl = AthletesImpl(fakeAthletesService, fakeLogger, fakeMembersService);

      // Start the app
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            athletesProvider.overrideWithValue(athletesImpl),
            directoryProvider.overrideWithValue(appSupportDir),
            settingsBoxProvider.overrideWithValue(settingsBox),
          ],
          child: const CoachApp(),
        ),
      );

      // Simulate a delay to see the app's initial state
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byType(Scaffold), findsAtLeast(1));

      // Navigate to the athletes page
      await tester.tap(find.byKey(const Key('navigation_athletes')));

      await tester.pump(const Duration(seconds: 4));

      // Verify that we're on the athletes page
      expect(find.text('Athletes'), findsOneWidget);

      // Verify that the athlete list is displayed
      expect(find.byType(AthleteListView), findsOneWidget);
    });
  });
}
