import 'package:domain/features/athletes/entities/sport.dart' as domain;
import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_sports_service.dart';

void main() {
  late FakeSportsService fakeSportsService;

  setUp(() {
    fakeSportsService = FakeSportsService();
  });

  group('FakeSportsService', () {
    test('should generate 50 fake sports on initialization', () async {
      final sports = await fakeSportsService.getAllSports();
      expect(sports.length, 25);
    });

    test('should return all sports', () async {
      final sports = await fakeSportsService.getAllSports();
      expect(sports, isA<List<domain.Sport>>());
      expect(sports.length, 25);
      expect(sports, isNotEmpty);
    });

    test('should get sports by ids', () async {
      final allSports = await fakeSportsService.getAllSports();
      final ids = allSports.take(3).map((s) => s.id).toList();

      final sports = await fakeSportsService.getSportsByIds(ids);

      expect(sports.length, 3);
      expect(sports.every((s) => ids.contains(s.id)), isTrue);
    });

    test('should create a new sport', () async {
      const newSport = domain.Sport(id: 'new_id', name: 'New Sport');

      final createdSport = await fakeSportsService.createSport(newSport);

      expect(createdSport, equals(newSport));

      final allSports = await fakeSportsService.getAllSports();
      expect(allSports, contains(newSport));
    });

    test('should delete a sport', () async {
      final allSports = await fakeSportsService.getAllSports();
      final sportToDelete = allSports.first;

      await fakeSportsService.deleteSport(sportToDelete.id);

      final updatedSports = await fakeSportsService.getAllSports();
      expect(updatedSports, isNot(contains(sportToDelete)));
    });

    test('should get sport by id', () async {
      final allSports = await fakeSportsService.getAllSports();
      final sportToFind = allSports.first;

      final foundSport = await fakeSportsService.getSportById(sportToFind.id);

      expect(foundSport, equals(sportToFind));
    });

    test('should throw exception when getting non-existent sport by id',
        () async {
      expect(() => fakeSportsService.getSportById('non_existent_id'),
          throwsException);
    });

    test('should update a sport', () async {
      final allSports = await fakeSportsService.getAllSports();
      final sportToUpdate = allSports.first;
      final updatedSport =
          domain.Sport(id: sportToUpdate.id, name: 'Updated Sport');

      final result = await fakeSportsService.updateSport(updatedSport);

      expect(result, equals(updatedSport));

      final foundSport = await fakeSportsService.getSportById(sportToUpdate.id);
      expect(foundSport, equals(updatedSport));
    });

    test('should throw exception when updating non-existent sport', () async {
      const nonExistentSport =
          domain.Sport(id: 'non_existent_id', name: 'Non-existent Sport');
      expect(() => fakeSportsService.updateSport(nonExistentSport),
          throwsException);
    });

    test('should return sports in alphabetical order', () async {
      final sports = await fakeSportsService.getAllSports();

      for (int i = 0; i < sports.length - 1; i++) {
        expect(sports[i].name.compareTo(sports[i + 1].name) <= 0, isTrue);
      }
    });

    test('should simulate delay for all operations', () async {
      final stopwatch = Stopwatch()..start();

      await fakeSportsService.getAllSports();
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(300));

      stopwatch.reset();
      await fakeSportsService.getSportsByIds(['some_id']);
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(300));

      stopwatch.reset();
      await fakeSportsService
          .createSport(const domain.Sport(id: 'new_id', name: 'New Sport'));
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(300));

      stopwatch.reset();
      await fakeSportsService.deleteSport('some_id');
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(300));

      stopwatch.reset();
      try {
        await fakeSportsService.getSportById('some_id');
      } catch (_) {}
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(300));

      stopwatch.reset();
      try {
        await fakeSportsService.updateSport(
            const domain.Sport(id: 'some_id', name: 'Updated Sport'));
      } catch (_) {}
      expect(stopwatch.elapsedMilliseconds, greaterThanOrEqualTo(300));
    });
  });
}
