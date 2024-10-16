import 'package:coach_app/features/athletes/infrastructure/services/fake_athletes_service.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/shared/providers/directory_provider.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late FakeAthletesService fakeAthletesService;
  late MockSportsService mockSportsService;
  late MockAvatarGeneratorService mockAvatarGeneratorService;
  late MockAvatarRepository mockAvatarRepository;
  late MockDirectory mockDirectory;

  setUp(() {
    mockSportsService = MockSportsService();
    mockAvatarGeneratorService = MockAvatarGeneratorService();
    mockAvatarRepository = MockAvatarRepository();
    mockDirectory = MockDirectory();

    when(mockSportsService.getAllSports()).thenAnswer((_) async => [
          const Sport(id: '1', name: 'Football'),
          const Sport(id: '2', name: 'Basketball'),
          const Sport(id: '3', name: 'Tennis'),
        ]);
    when(mockDirectory.path).thenReturn('/test/path');
    when(mockAvatarGeneratorService.generateAvatar())
        .thenAnswer((_) => 'avatar');
    when(mockAvatarRepository.saveAvatar(any, any)).thenAnswer((_) async =>
        Avatar(
            id: 'avatar1',
            localPath: 'path',
            lastUpdated: DateTime.now(),
            syncStatus: SyncStatus.synced));
    fakeAthletesService = FakeAthletesService(
        mockSportsService, mockAvatarGeneratorService, mockAvatarRepository);
  });

  group('FakeAthletesService', () {
    test('athletesServiceProvider should return a FakeAthletesService',
        () async {
      final mockSportsService = MockSportsService();

      when(mockSportsService.getAllSports()).thenAnswer((_) async => [
            const Sport(id: '1', name: 'Football'),
            const Sport(id: '2', name: 'Basketball'),
            const Sport(id: '3', name: 'Tennis'),
          ]);

      final container = ProviderContainer(
        overrides: [
          sportsServiceProvider.overrideWithValue(mockSportsService),
          directoryProvider.overrideWithValue(mockDirectory),
        ],
      );
      addTearDown(container.dispose);

      final athletesService = container.read(athletesServiceProvider);

      expect(athletesService, isA<FakeAthletesService>());
    });

    test('should generate 100 fake athletes on initialization', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 100);
      final athletes = await fakeAthletesService.getAllAthletes();
      expect(athletes.length, 100);
    });

    test('should return paginated athletes', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 21);
      final page1 = await fakeAthletesService.getAthletesByPage(0, 10);
      expect(page1.length, 10);

      final page2 = await fakeAthletesService.getAthletesByPage(1, 10);
      expect(page2.length, 10);
      expect(page1, isNot(equals(page2)));
    });

    test('should filter athletes by name', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final filterCriteria = AthleteFilterCriteria(name: 'John');
      final filteredAthletes = await fakeAthletesService
          .getAthletesByPage(0, 100, filterCriteria: filterCriteria);
      expect(
          filteredAthletes
              .every((athlete) => athlete.name.toLowerCase().contains('john')),
          true);
    });

    test('should filter athletes by sport', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final filterCriteria =
          AthleteFilterCriteria(sports: const ['1']); // Football

      final filteredAthletes = await fakeAthletesService
          .getAthletesByPage(0, 100, filterCriteria: filterCriteria);
      expect(
          filteredAthletes.every(
              (athlete) => athlete.sports!.any((sport) => sport.id == '1')),
          true);
    });

    test('should sort athletes by name', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final sortCriteria =
          AthleteSortCriteria(field: 'name', order: SortOrder.ascending);
      final sortedAthletes = await fakeAthletesService.getAthletesByPage(0, 100,
          sortCriteria: sortCriteria);

      for (int i = 0; i < sortedAthletes.length - 1; i++) {
        expect(
          sortedAthletes[i].name.compareTo(sortedAthletes[i + 1].name) <= 0,
          isTrue,
          reason: 'Athletes should be sorted in ascending order by name',
        );
      }
    });

    test('should create a new athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 1);
      const newAthlete = Athlete(
          id: 'new_id',
          name: 'New Athlete',
          sports: [Sport(id: '1', name: 'Football')]);
      final createdAthlete =
          await fakeAthletesService.createAthlete(newAthlete);
      expect(createdAthlete.name, equals(newAthlete.name));
      expect(createdAthlete.id, isNot(equals(newAthlete.id)));
    });

    test('should update an existing athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 1);
      final athletes = await fakeAthletesService.getAllAthletes();
      final athleteToUpdate = athletes.first;
      final updatedAthlete = Athlete(
          id: athleteToUpdate.id,
          name: 'Updated Name',
          sports: athleteToUpdate.sports);

      final result = await fakeAthletesService.updateAthlete(updatedAthlete);
      expect(result, equals(updatedAthlete));

      final retrievedAthlete =
          await fakeAthletesService.getAthleteById(athleteToUpdate.id);
      expect(retrievedAthlete, equals(updatedAthlete));
    });

    test('should delete an athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 1);
      final athletes = await fakeAthletesService.getAllAthletes();

      final athleteToDelete = athletes.first;

      await fakeAthletesService.deleteAthlete(athleteToDelete.id);

      final updatedAthletes = await fakeAthletesService.getAllAthletes();
      expect(updatedAthletes.first.archived, true);
    });
  });
}
