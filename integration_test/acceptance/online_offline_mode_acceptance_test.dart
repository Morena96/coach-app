import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

import 'package:coach_app/app.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_group.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_member.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_sport.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/hive_avatar.dart';
import 'package:coach_app/features/settings/infrastructure/models/hive_setting.dart';
import 'package:coach_app/shared/providers/avatar_box_provider.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:coach_app/shared/providers/riverpod_singletons.dart';
import 'package:coach_app/shared/providers/settings_box_provider.dart';

import 'fake_connectivity_repository.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HiveAvatarAdapter());
    Hive.registerAdapter(HiveSettingAdapter());
    Hive.registerAdapter(HiveGroupAdapter());
    Hive.registerAdapter(HiveMemberAdapter());
    Hive.registerAdapter(HiveSportAdapter());
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('Dashboard Acceptance Tests', () {
    var test = 'A user can see the internet indicator widget and when'
        'they disconnect they will see the modal and when they reconnect'
        'they see the modal again';

    testWidgets(test, (WidgetTester tester) async {
      final fakeConnectivityRepository = FakeConnectivityRepository();
      fakeConnectivityRepository.setConnectivityStatus(false);
      final directory = await getApplicationDocumentsDirectory();
      final avatarBox = await Hive.openBox<HiveAvatar>('avatars');
      final settingsBox = await Hive.openBox<HiveSetting>('settings');

      // Start the app
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            connectivityRepositoryProvider
                .overrideWithValue(fakeConnectivityRepository),
            directoryProvider.overrideWithValue(directory),
            avatarBoxProvider.overrideWithValue(avatarBox),
            settingsBoxProvider.overrideWithValue(settingsBox),
          ],
          child: const CoachApp(),
        ),
      );

      // Simulate a delay to see the app's initial state
      await tester.pumpAndSettle(const Duration(seconds: 10));

      expect(find.byType(Scaffold), findsAtLeast(1));

      // Add your expectations for the connected state here
      expect(find.text('Offline Mode'), findsOneWidget);

      // Final delay to observe the settings page
      await tester.pump(const Duration(seconds: 3));

      // Set the internet connection to false
      fakeConnectivityRepository.setConnectivityStatus(true);

      // Trigger a rebuild with the new state
      await tester.pumpAndSettle();

      // Expect that Online Mode is now visible and a dialog is
      // shown to the user
      expect(find.text('Online Mode'), findsOneWidget);
      expect(find.text('Online Mode Activated'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));

      // The user taps the confirm button
      await tester.tap(find.text('Got it, Continue'));

      // Wait for the dialog to close
      await tester.pumpAndSettle();

      fakeConnectivityRepository.setConnectivityStatus(false);

      // Trigger a rebuild with the new state
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // Expect that Offline Mode is now visible and a dialog is
      // shown to the user
      expect(find.text('Offline Mode Activated'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      // expect they can close the X button
      // SvgPicture.asset('assets/icons/close.svg')
      await tester.tap(find.byKey(const Key('dialog_close_button')));

      await tester.pump(const Duration(seconds: 1));

      // Wait for the dialog to close
      await tester.pumpAndSettle();

      // Final delay to observe the settings page
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Offline Mode Activated'), findsNothing);
    });
  });
}
