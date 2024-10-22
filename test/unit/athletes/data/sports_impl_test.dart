import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/infrastructure/repositories/sports_impl.dart';

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

    group('getSportsByPage', () {
      /// Test successful retrieval of sports with pagination
      test('returns success result when service succeeds with pagination',
          () async {
        const page = 1;
        const pageSize = 10;
        final sports = List.generate(
          pageSize,
          (index) => Sport(
            id: index.toString(),
            name: 'Sport $index',
          ),
        );

        when(
          mockSportsService.getSportsByPage(
            page,
            pageSize,
            filterCriteria: null,
          ),
        ).thenAnswer((_) async => sports);

        final result = await sportsImpl.getSportsByPage(page, pageSize);

        expect(result.isSuccess, true);
        expect(result.value, sports);
        expect(result.value?.length, pageSize);
        verify(
          mockSportsService.getSportsByPage(
            page,
            pageSize,
            filterCriteria: null,
          ),
        ).called(1);
      });

      /// Test successful retrieval with filter criteria

      /// Test handling of service failure
      test('returns failure result when service throws', () async {
        const page = 1;
        const pageSize = 10;

        when(
          mockSportsService.getSportsByPage(
            page,
            pageSize,
            filterCriteria: null,
          ),
        ).thenThrow(Exception('Failed to fetch sports page'));

        final result = await sportsImpl.getSportsByPage(page, pageSize);

        expect(result.isSuccess, false);
        expect(result.error, 'Exception: Failed to fetch sports page');
        verify(mockLoggerRepository.error(any)).called(1);
      });

      /// Test edge case with empty page
      test('handles empty page correctly', () async {
        const page = 1;
        const pageSize = 10;
        const emptySports = <Sport>[];

        when(
          mockSportsService.getSportsByPage(
            page,
            pageSize,
            filterCriteria: null,
          ),
        ).thenAnswer((_) async => emptySports);

        final result = await sportsImpl.getSportsByPage(page, pageSize);

        expect(result.isSuccess, true);
        expect(result.value, isEmpty);
        verify(
          mockSportsService.getSportsByPage(
            page,
            pageSize,
            filterCriteria: null,
          ),
        ).called(1);
      });

      /// Test edge case with invalid page parameters
      test('handles invalid page parameters gracefully', () async {
        const invalidPage = -1;
        const invalidPageSize = 0;

        when(
          mockSportsService.getSportsByPage(
            invalidPage,
            invalidPageSize,
            filterCriteria: null,
          ),
        ).thenThrow(ArgumentError('Invalid pagination parameters'));

        final result = await sportsImpl.getSportsByPage(
          invalidPage,
          invalidPageSize,
        );

        expect(result.isSuccess, false);
        verify(mockLoggerRepository.error(any)).called(1);
      });
    });
  });
}
