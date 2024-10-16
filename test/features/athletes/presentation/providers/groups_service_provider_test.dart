import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/athletes/infrastructure/services/fake_groups_service.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/provider/avatar_repository_provider.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late MockAvatarRepository mockAvatarRepository;
  late MockSportsService mockSportsService;

  setUp(() {
    mockAvatarRepository = MockAvatarRepository();
    mockSportsService = MockSportsService();

    // Stub the getAllSports method with mock sports
    when(mockSportsService.getAllSports(
            filterCriteria: anyNamed('filterCriteria')))
        .thenAnswer((_) async => [
              const Sport(id: '1', name: 'Football'),
              const Sport(id: '2', name: 'Basketball'),
            ]);

    // Stub the saveAvatar method
    when(mockAvatarRepository.saveAvatar(any, any)).thenAnswer((_) async =>
        Avatar(
            id: 'mock_avatar_id',
            localPath: '',
            lastUpdated: DateTime.now(),
            syncStatus: SyncStatus.synced));
  });

  test(
      'groupsServiceProvider creates FakeGroupsService with correct dependencies',
      () async {
    final container = ProviderContainer(
      overrides: [
        avatarRepositoryProvider.overrideWithValue(mockAvatarRepository),
        sportsServiceProvider.overrideWithValue(mockSportsService),
      ],
    );

    final groupsService = container.read(groupsServiceProvider);

    expect(groupsService, isA<FakeGroupsService>());

    // Wait for any asynchronous operations to complete
    await Future.delayed(Duration.zero);

    // Verify that getAllSports was called
    verify(mockSportsService.getAllSports(
            filterCriteria: anyNamed('filterCriteria')))
        .called(1);

    // Verify that saveAvatar was called at least once
    verify(mockAvatarRepository.saveAvatar(any, any)).called(greaterThan(0));
  });

  // ... rest of the test ...
}
