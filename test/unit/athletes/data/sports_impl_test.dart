import 'package:coach_app/features/athletes/infrastructure/repositories/sports_impl.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([SportsService, LoggerRepository])
import 'sports_impl_test.mocks.dart';

void main() {
  late SportsImpl sportsImpl;
  late MockSportsService mockSportsService;
  late MockLoggerRepository mockLoggerRepository;

  setUp(() {
    mockSportsService = MockSportsService();
    mockLoggerRepository = MockLoggerRepository();
    sportsImpl = SportsImpl(mockSportsService, mockLoggerRepository);
  });

  group('SportsImpl', () {
    test('getAllSports returns success result when service succeeds', () async {
      final sports = [
        const Sport(id: '1', name: 'Football'),
        const Sport(id: '2', name: 'Basketball')
      ];
      when(mockSportsService.getAllSports()).thenAnswer((_) async => sports);

      final result = await sportsImpl.getAllSports();

      expect(result.isSuccess, true);
      expect(result.value, sports);
      verify(mockSportsService.getAllSports()).called(1);
    });

    test('getAllSports returns failure result when service throws', () async {
      when(mockSportsService.getAllSports())
          .thenThrow(Exception('Failed to get sports'));

      final result = await sportsImpl.getAllSports();

      expect(result.isSuccess, false);
      expect(result.error, 'Exception: Failed to get sports');
      verify(mockSportsService.getAllSports()).called(1);
      verify(mockLoggerRepository.error(any)).called(1);
    });

    // Similar tests for getSportsByIds
    test('getSportsByIds returns success result when service succeeds',
        () async {
      final ids = ['1', '2'];
      final sports = [
        const Sport(id: '1', name: 'Football'),
        const Sport(id: '2', name: 'Basketball')
      ];
      when(mockSportsService.getSportsByIds(ids))
          .thenAnswer((_) async => sports);

      final result = await sportsImpl.getSportsByIds(ids);

      expect(result.isSuccess, true);
      expect(result.value, sports);
      verify(mockSportsService.getSportsByIds(ids)).called(1);
    });

    // Test for createSport
    test('createSport returns success result when service succeeds', () async {
      const sport = Sport(id: '1', name: 'Football');
      when(mockSportsService.createSport(sport)).thenAnswer((_) async => sport);

      final result = await sportsImpl.createSport(sport);

      expect(result.isSuccess, true);
      expect(result.value, sport);
      verify(mockSportsService.createSport(sport)).called(1);
    });

    // Test for deleteSport
    test('deleteSport returns success result when service succeeds', () async {
      const id = '1';
      when(mockSportsService.deleteSport(id)).thenAnswer((_) async {});

      final result = await sportsImpl.deleteSport(id);

      expect(result.isSuccess, true);
      verify(mockSportsService.deleteSport(id)).called(1);
    });

    // Test for getSportById
    test('getSportById returns success result when service succeeds', () async {
      const id = '1';
      const sport = Sport(id: '1', name: 'Football');
      when(mockSportsService.getSportById(id)).thenAnswer((_) async => sport);

      final result = await sportsImpl.getSportById(id);

      expect(result.isSuccess, true);
      expect(result.value, sport);
      verify(mockSportsService.getSportById(id)).called(1);
    });

    // Test for updateSport
    test('updateSport returns success result when service succeeds', () async {
      const sport = Sport(id: '1', name: 'Updated Football');
      when(mockSportsService.updateSport(sport)).thenAnswer((_) async => sport);

      final result = await sportsImpl.updateSport(sport);

      expect(result.isSuccess, true);
      expect(result.value, sport);
      verify(mockSportsService.updateSport(sport)).called(1);
    });

    // Add failure cases for each method similar to the getAllSports failure case
  });
}
