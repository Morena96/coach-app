import 'package:coach_app/features/sessions/presentation/providers/sessions_data_service_provider.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/features/sessions/infrastructure/data/fake_sessions_data_service.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/sports_service.dart';

@GenerateMocks([AthletesService, GroupsService, SportsService])
import 'sessions_data_service_provider_test.mocks.dart';

void main() {
  late MockAthletesService mockAthletesService;
  late MockGroupsService mockGroupsService;
  late MockSportsService mockSportsService;
  late ProviderContainer container;

  setUp(() {
    mockAthletesService = MockAthletesService();
    mockGroupsService = MockGroupsService();
    mockSportsService = MockSportsService();

    // Stub the getAllSports method with mock sports
    when(mockSportsService.getAllSports(
            filterCriteria: anyNamed('filterCriteria')))
        .thenAnswer((_) async => [
              const Sport(id: '1', name: 'Football'),
              const Sport(id: '2', name: 'Basketball'),
            ]);

    when(mockGroupsService.getAllGroups()).thenAnswer((_) async => []);

    when(mockAthletesService.getAllAthletes()).thenAnswer((_) async => []);

    container = ProviderContainer(
      overrides: [
        athletesServiceProvider.overrideWithValue(mockAthletesService),
        groupsServiceProvider.overrideWithValue(mockGroupsService),
        sportsServiceProvider.overrideWithValue(mockSportsService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('sessionsDataService should return a FakeSessionsDataService', () {
    final dataService = container.read(sessionsDataServiceProvider);
    expect(dataService, isA<FakeSessionsDataService>());
  });

  test('sessionsDataService should be a singleton', () {
    final dataService1 = container.read(sessionsDataServiceProvider);
    final dataService2 = container.read(sessionsDataServiceProvider);
    expect(identical(dataService1, dataService2), isTrue);
  });
}
