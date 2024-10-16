import 'package:coach_app/features/athletes/infrastructure/services/avatar_generator_service.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_athletes_service.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_sports_service.dart';
import 'package:coach_app/features/avatars/infrastructure/services/avatar_generator_service.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/avatars/entities/avatar.dart';
import 'package:domain/features/avatars/entities/sync_status.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  FakeSportsService,
  FakeAvatarGeneratorService,
  AvatarRepository,
  AvatarGeneratorService
])
import 'fake_athletes_service_test.mocks.dart';

void main() {
  late FakeAthletesService fakeAthletesService;
  late MockFakeSportsService mockFakeSportsService;
  late MockFakeAvatarGeneratorService avatarGeneratorService;
  late MockAvatarRepository mockAvatarRepository;

  setUp(() async {
    mockFakeSportsService = MockFakeSportsService();
    avatarGeneratorService = MockFakeAvatarGeneratorService();
    mockAvatarRepository = MockAvatarRepository();
    when(mockFakeSportsService.getAllSports()).thenAnswer((_) async => [
          const Sport(id: '1', name: 'Football'),
          const Sport(id: '2', name: 'Basketball'),
          const Sport(id: '3', name: 'Tennis'),
        ]);
    when(avatarGeneratorService.generateAvatar()).thenReturn('fake_avatar');
    when(mockAvatarRepository.saveAvatar(any, any)).thenAnswer((_) async =>
        Avatar(
            id: 'fake_avatar_id',
            lastUpdated: DateTime.now(),
            localPath: 'test',
            syncStatus: SyncStatus.synced));
    fakeAthletesService = FakeAthletesService(
        mockFakeSportsService, avatarGeneratorService, mockAvatarRepository);
  });

  group('FakeAthletesService', () {
    test('constructor generates 100 fake athletes', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 100);
      final athletes = await fakeAthletesService.getAllAthletes();
      expect(athletes.length, 100);
    });

    test('getAllAthletes returns all athletes', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 100);
      final athletes = await fakeAthletesService.getAllAthletes();
      expect(athletes.length, 100);
    });

    test('getAthletesByPage returns correct number of athletes', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final athletes = await fakeAthletesService.getAthletesByPage(0, 10);
      expect(athletes.length, 10);
    });

    test('getAthletesByPage with name filter returns filtered athletes',
        () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final filterCriteria = AthleteFilterCriteria(name: 'John');
      final athletes = await fakeAthletesService.getAthletesByPage(0, 10,
          filterCriteria: filterCriteria);
      for (var athlete in athletes) {
        expect(athlete.name.toLowerCase(), contains('john'));
      }
    });

    test('getAthletesByPage with sports filter returns filtered athletes',
        () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final filterCriteria = AthleteFilterCriteria(
          sports: const ['1']); // Assuming '1' is the ID for Football
      final athletes = await fakeAthletesService.getAthletesByPage(0, 10,
          filterCriteria: filterCriteria);
      for (var athlete in athletes) {
        expect(athlete.sports!.any((sport) => sport.id == '1'), isTrue);
      }
    });

    test('getAthletesByPage with sort criteria returns sorted athletes',
        () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final sortCriteria =
          AthleteSortCriteria(field: 'name', order: SortOrder.ascending);
      final athletes = await fakeAthletesService.getAthletesByPage(0, 10,
          sortCriteria: sortCriteria);
      for (int i = 0; i < athletes.length - 1; i++) {
        expect(athletes[i].name.compareTo(athletes[i + 1].name),
            lessThanOrEqualTo(0));
      }
    });

    test(
        'getAthletesByPage with descending sort order returns correctly sorted athletes',
        () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final sortCriteria =
          AthleteSortCriteria(field: 'name', order: SortOrder.descending);
      final athletes = await fakeAthletesService.getAthletesByPage(0, 10,
          sortCriteria: sortCriteria);
      for (int i = 0; i < athletes.length - 1; i++) {
        expect(athletes[i].name.compareTo(athletes[i + 1].name),
            greaterThanOrEqualTo(0));
      }
    });

    test('getAthletesByPage with invalid sort field does not throw error',
        () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final sortCriteria = AthleteSortCriteria(
          field: 'invalidField', order: SortOrder.ascending);
      expect(
          fakeAthletesService.getAthletesByPage(0, 10,
              sortCriteria: sortCriteria),
          completes);
    });

    test(
        'getAthletesByPage with isArchived filter returns only archived athletes',
        () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 20);

      final allAthletes = await fakeAthletesService.getAllAthletes();
      final archivedAthletes =
          allAthletes.where((athlete) => athlete.archived).toList();

      final filterCriteria = AthleteFilterCriteria(isArchived: true);
      final athletes = await fakeAthletesService.getAthletesByPage(0, 20,
          filterCriteria: filterCriteria);

      expect(athletes.length, equals(archivedAthletes.length));
      for (var athlete in athletes) {
        expect(athlete.archived, isTrue);
      }
    });

    test(
        'getAthletesByPage with isArchived false filter returns only non-archived athletes',
        () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 100);

      final allAthletes = await fakeAthletesService.getAllAthletes();
      final nonArchivedAthletes =
          allAthletes.where((athlete) => !athlete.archived).toList();

      final filterCriteria = AthleteFilterCriteria(isArchived: false);
      final athletes = await fakeAthletesService.getAthletesByPage(0, 100,
          filterCriteria: filterCriteria);

      expect(athletes.length, equals(nonArchivedAthletes.length));
      for (var athlete in athletes) {
        expect(athlete.archived, isFalse);
      }
    });

    test(
        'getAthletesByPage with combined filters (name, sports, isArchived) returns correct athletes',
        () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 50);

      // Manually set up some athletes with specific conditions
      final allAthletes = await fakeAthletesService.getAllAthletes();
      for (var i = 0; i < 10; i++) {
        final athlete = allAthletes[i];
        final updatedAthlete = athlete.copyWith(
            name: 'Test Athlete $i',
            sports: [const Sport(id: '1', name: 'Football')],
            archived: i < 5 // Archive first 5
            );
        await fakeAthletesService.updateAthlete(updatedAthlete);
      }

      final filterCriteria =
          AthleteFilterCriteria(name: 'Test', sports: const ['1'], isArchived: true);
      final athletes = await fakeAthletesService.getAthletesByPage(0, 10,
          filterCriteria: filterCriteria);

      expect(athletes.length, 5);
      for (var athlete in athletes) {
        expect(athlete.name, startsWith('Test'));
        expect(athlete.sports!.any((sport) => sport.id == '1'), isTrue);
        expect(athlete.archived, isTrue);
      }
    });

    test('getAthletesByFilterCriteria returns all athletes', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 100);
      final athletes = await fakeAthletesService
          .getAthletesByFilterCriteria(AthleteFilterCriteria());
      expect(athletes.length, 100);
    });

    test('getAthleteById returns correct athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 3);
      final allAthletes = await fakeAthletesService.getAllAthletes();
      final targetAthlete = allAthletes.first;
      final retrievedAthlete =
          await fakeAthletesService.getAthleteById(targetAthlete.id);
      expect(retrievedAthlete.id, equals(targetAthlete.id));
      expect(retrievedAthlete.name, equals(targetAthlete.name));
    });

    test('getAthleteById throws exception for non-existent ID', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 1);
      expect(() => fakeAthletesService.getAthleteById('non_existent_id'),
          throwsA(isA<StateError>()));
    });

    test('createAthlete adds a new athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 1);
      const newAthlete = Athlete(id: 'new_id', name: 'New Athlete');
      final createdAthlete =
          await fakeAthletesService.createAthlete(newAthlete);
      final retrievedAthlete =
          await fakeAthletesService.getAthleteById(createdAthlete.id);
      expect(retrievedAthlete.id, equals(createdAthlete.id));
      expect(retrievedAthlete.name, equals(newAthlete.name));
    });

    test('updateAthlete modifies an existing athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 1);
      final allAthletes = await fakeAthletesService.getAllAthletes();
      final targetAthlete = allAthletes.first;
      final updatedAthlete =
          Athlete(id: targetAthlete.id, name: 'Updated Name');
      await fakeAthletesService.updateAthlete(updatedAthlete);
      final retrievedAthlete =
          await fakeAthletesService.getAthleteById(targetAthlete.id);
      expect(retrievedAthlete.name, equals('Updated Name'));
    });

    test('updateAthlete throws exception for non-existent athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      const nonExistentAthlete =
          Athlete(id: 'non_existent_id', name: 'Non-existent Athlete');
      expect(() => fakeAthletesService.updateAthlete(nonExistentAthlete),
          throwsA(isA<Exception>()));
    });

    test('deleteAthlete archives an athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final allAthletes = await fakeAthletesService.getAllAthletes();
      final targetAthlete = allAthletes.first;
      await fakeAthletesService.deleteAthlete(targetAthlete.id);
      final archivedAthlete =
          await fakeAthletesService.getAthleteById(targetAthlete.id);
      expect(archivedAthlete.archived, isTrue);
    });

    test('restoreAthlete unarchives an athlete', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 11);
      final allAthletes = await fakeAthletesService.getAllAthletes();
      final targetAthlete = allAthletes.first;
      await fakeAthletesService.deleteAthlete(targetAthlete.id);
      await fakeAthletesService.restoreAthlete(targetAthlete.id);
      final restoredAthlete =
          await fakeAthletesService.getAthleteById(targetAthlete.id);
      expect(restoredAthlete.archived, isFalse);
    });

    test('_getRandomSports returns correct number of sports', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 1);
      final allSports = await mockFakeSportsService.getAllSports();
      final randomSports = fakeAthletesService.getRandomSports(allSports, 2);
      expect(randomSports.length, 2);
    });

    test('_getRandomSports returns sorted sports', () async {
      await fakeAthletesService.resetAndRefreshDatabase(count: 1);
      final allSports = await mockFakeSportsService.getAllSports();
      final randomSports = fakeAthletesService.getRandomSports(allSports, 3);
      for (int i = 0; i < randomSports.length - 1; i++) {
        expect(randomSports[i].name.compareTo(randomSports[i + 1].name),
            lessThanOrEqualTo(0));
      }
    });
  });
}
