import 'package:coach_app/features/athletes/infrastructure/data/hive_sports_data_service.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_sport.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([Box<HiveSport>, LoggerRepository])
import 'sports_data_service_test.mocks.dart';

void main() {
  late HiveSportsDataService dataService;
  late MockBox<HiveSport> mockBox;
  late MockLoggerRepository mockLoggerRepository;

  setUp(() {
    mockBox = MockBox<HiveSport>();
    mockLoggerRepository = MockLoggerRepository();
    dataService = HiveSportsDataService(mockBox, mockLoggerRepository);
  });

  group('HiveSportsDataService', () {
    test('getAllSports should return all sports from the box', () async {
      final sports = [
        HiveSport(id: '1', name: 'Football'),
        HiveSport(id: '2', name: 'Basketball'),
      ];
      when(mockBox.values).thenReturn(sports);

      final result = await dataService.getAllSports();

      final domainSports = sports.map((e) => e.toDomain()).toList();
      expect(result, equals(domainSports));
    });

    test('createSport should add sport to the box', () async {
      const sport = Sport(id: '1', name: 'Football');
      when(mockBox.put('1', any)).thenAnswer((_) => Future.value());

      await dataService.createSport(sport);

      verify(mockBox.put('1', any)).called(1);
    });

    test('deleteSport should remove sport from the box', () async {
      when(mockBox.delete('1')).thenAnswer((_) => Future.value());

      await dataService.deleteSport('1');

      verify(mockBox.delete('1')).called(1);
    });

    test('getSportById should return the correct sport', () async {
      final sport = HiveSport(id: '1', name: 'Football');
      when(mockBox.get('1')).thenReturn(sport);

      final result = await dataService.getSportById('1');

      expect(result, equals(sport.toDomain()));
    });

    test('getSportById should throw exception when sport not found', () async {
      when(mockBox.get('1')).thenReturn(null);

      expect(() => dataService.getSportById('1'), throwsException);
    });

    test('updateSport should update the sport in the box', () async {
      const sport = Sport(id: '1', name: 'Football Updated');
      when(mockBox.put('1', any)).thenAnswer((_) => Future.value());

      await dataService.updateSport(sport);

      verify(mockBox.put('1', any)).called(1);
    });

    test('dispose should cancel the cache timer', () {
      dataService.dispose();
      // This test is a bit tricky to verify directly,
      // as _cacheTimer is private. We might need to expose it or its state for testing.
    });

    test('_getCachedSports should cache sports and reset timer', () async {
      final sports = [
        HiveSport(id: '1', name: 'Football'),
        HiveSport(id: '2', name: 'Basketball'),
      ];
      when(mockBox.values).thenReturn(sports);

      // Call twice to test caching
      await dataService.getAllSports();
      await dataService.getAllSports();

      // Verify that values are only accessed once due to caching
      verify(mockBox.values).called(1);
    });
  });
}
