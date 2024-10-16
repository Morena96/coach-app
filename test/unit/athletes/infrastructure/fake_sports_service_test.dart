import 'package:domain/features/athletes/entities/sport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/features/athletes/infrastructure/services/fake_sports_service.dart';

void main() {
  late FakeSportsService fakeSportsService;

  setUp(() {
    fakeSportsService = FakeSportsService();
  });

  group('FakeSportsService', () {
    test('getAllSports returns 50 sports', () async {
      final sports = await fakeSportsService.getAllSports();
      expect(sports.length, 25);
    });

    test('getSportsByIds returns correct sports', () async {
      final allSports = await fakeSportsService.getAllSports();
      final idsToRetrieve = [allSports[0].id, allSports[1].id];
      final retrievedSports =
          await fakeSportsService.getSportsByIds(idsToRetrieve);
      expect(retrievedSports.length, 2);
      expect(retrievedSports.map((s) => s.id), containsAll(idsToRetrieve));
    });

    test('createSport adds a new sport', () async {
      const newSport = Sport(id: 'new_id', name: 'New Sport');
      final createdSport = await fakeSportsService.createSport(newSport);
      expect(createdSport.id, 'new_id');
      expect(createdSport.name, 'New Sport');

      final allSports = await fakeSportsService.getAllSports();
      expect(allSports, contains(newSport));
    });

    test('deleteSport removes a sport', () async {
      final allSports = await fakeSportsService.getAllSports();
      final sportToDelete = allSports.first;
      await fakeSportsService.deleteSport(sportToDelete.id);

      final updatedSports = await fakeSportsService.getAllSports();
      expect(updatedSports, isNot(contains(sportToDelete)));
    });

    test('getSportById returns correct sport', () async {
      final allSports = await fakeSportsService.getAllSports();
      final sportToRetrieve = allSports.first;
      final retrievedSport =
          await fakeSportsService.getSportById(sportToRetrieve.id);
      expect(retrievedSport, equals(sportToRetrieve));
    });

    test('getSportById throws exception for non-existent sport', () async {
      expect(() => fakeSportsService.getSportById('non_existent_id'),
          throwsException);
    });

    test('updateSport modifies an existing sport', () async {
      final allSports = await fakeSportsService.getAllSports();
      final sportToUpdate = allSports.first;
      final updatedSport =
          Sport(id: sportToUpdate.id, name: 'Updated Sport Name');

      final result = await fakeSportsService.updateSport(updatedSport);
      expect(result.name, 'Updated Sport Name');

      final retrievedSport =
          await fakeSportsService.getSportById(sportToUpdate.id);
      expect(retrievedSport.name, 'Updated Sport Name');
    });

    test('updateSport throws exception for non-existent sport', () async {
      const nonExistentSport =
          Sport(id: 'non_existent_id', name: 'Non-existent Sport');
      expect(() => fakeSportsService.updateSport(nonExistentSport),
          throwsException);
    });
  });
}
