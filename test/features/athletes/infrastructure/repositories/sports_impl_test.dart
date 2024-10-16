import 'package:domain/features/athletes/entities/sport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/infrastructure/repositories/sports_impl.dart';

import '../../../../mocks.mocks.dart';

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
    test('getAllSports returns success result when operation succeeds',
        () async {
      final sports = [
        const Sport(id: '1', name: 'Football'),
        const Sport(id: '2', name: 'Basketball')
      ];
      when(mockSportsService.getAllSports()).thenAnswer((_) async => sports);

      final result = await sportsImpl.getAllSports();

      expect(result.isSuccess, true);
      expect(result.value, sports);
    });

    test(
        'getAllSports returns failure result and logs error when operation fails',
        () async {
      when(mockSportsService.getAllSports())
          .thenThrow(Exception('Failed to get sports'));

      final result = await sportsImpl.getAllSports();

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Failed to get sports');
      verify(mockLoggerRepository.error('Exception: Failed to get sports'))
          .called(1);
    });

    test('getSportsByIds returns success result when operation succeeds',
        () async {
      final sports = [
        const Sport(id: '1', name: 'Football'),
        const Sport(id: '2', name: 'Basketball')
      ];
      when(mockSportsService.getSportsByIds(['1', '2']))
          .thenAnswer((_) async => sports);

      final result = await sportsImpl.getSportsByIds(['1', '2']);

      expect(result.isSuccess, true);
      expect(result.value, sports);
    });

    test(
        'getSportsByIds returns failure result and logs error when operation fails',
        () async {
      when(mockSportsService.getSportsByIds(['1', '2']))
          .thenThrow(Exception('Failed to get sports'));

      final result = await sportsImpl.getSportsByIds(['1', '2']);

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Failed to get sports');
      verify(mockLoggerRepository.error('Exception: Failed to get sports'))
          .called(1);
    });

    test('createSport returns success result when operation succeeds',
        () async {
      const sport = Sport(id: '1', name: 'Football');
      when(mockSportsService.createSport(sport)).thenAnswer((_) async => sport);

      final result = await sportsImpl.createSport(sport);

      expect(result.isSuccess, true);
      expect(result.value, sport);
    });

    test(
        'createSport returns failure result and logs error when operation fails',
        () async {
      const sport = Sport(id: '1', name: 'Football');
      when(mockSportsService.createSport(sport))
          .thenThrow(Exception('Failed to create sport'));

      final result = await sportsImpl.createSport(sport);

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Failed to create sport');
      verify(mockLoggerRepository.error('Exception: Failed to create sport'))
          .called(1);
    });

    test('deleteSport returns success result when operation succeeds',
        () async {
      when(mockSportsService.deleteSport('1')).thenAnswer((_) async {});

      final result = await sportsImpl.deleteSport('1');

      expect(result.isSuccess, true);
    });

    test(
        'deleteSport returns failure result and logs error when operation fails',
        () async {
      when(mockSportsService.deleteSport('1'))
          .thenThrow(Exception('Failed to delete sport'));

      final result = await sportsImpl.deleteSport('1');

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Failed to delete sport');
      verify(mockLoggerRepository.error('Exception: Failed to delete sport'))
          .called(1);
    });

    test('getSportById returns success result when operation succeeds',
        () async {
      const sport = Sport(id: '1', name: 'Football');
      when(mockSportsService.getSportById('1')).thenAnswer((_) async => sport);

      final result = await sportsImpl.getSportById('1');

      expect(result.isSuccess, true);
      expect(result.value, sport);
    });

    test(
        'getSportById returns failure result and logs error when operation fails',
        () async {
      when(mockSportsService.getSportById('1'))
          .thenThrow(Exception('Failed to get sport'));

      final result = await sportsImpl.getSportById('1');

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Failed to get sport');
      verify(mockLoggerRepository.error('Exception: Failed to get sport'))
          .called(1);
    });

    test('updateSport returns success result when operation succeeds',
        () async {
      const sport = Sport(id: '1', name: 'Football');
      when(mockSportsService.updateSport(sport)).thenAnswer((_) async => sport);

      final result = await sportsImpl.updateSport(sport);

      expect(result.isSuccess, true);
      expect(result.value, sport);
    });

    test(
        'updateSport returns failure result and logs error when operation fails',
        () async {
      const sport = Sport(id: '1', name: 'Football');
      when(mockSportsService.updateSport(sport))
          .thenThrow(Exception('Failed to update sport'));

      final result = await sportsImpl.updateSport(sport);

      expect(result.isFailure, true);
      expect(result.error, 'Exception: Failed to update sport');
      verify(mockLoggerRepository.error('Exception: Failed to update sport'))
          .called(1);
    });
  });
}
