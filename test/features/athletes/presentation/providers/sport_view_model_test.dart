import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/sport_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_provider.dart';

import '../../../../mocks.mocks.dart';

@GenerateMocks([Sports])
void main() {
  late ProviderContainer container;
  late MockSports mockSports;
  late AutoDisposeStateNotifierProvider<SportViewModel,
      AsyncValue<List<SportView>>> sportsViewModelProvider;

  setUp(() {
    mockSports = MockSports();
    container = ProviderContainer(
      overrides: [
        sportsProvider.overrideWithValue(mockSports),
      ],
    );
    sportsViewModelProvider = StateNotifierProvider.autoDispose<SportViewModel,
        AsyncValue<List<SportView>>>((ref) {
      return SportViewModel(ref.watch(sportsProvider));
    });
  });

  tearDown(() {
    container.dispose();
  });

  group('SportsViewModel', () {
    test('initial state should be loading', () {
      final initialState = container.read(sportsViewModelProvider);
      expect(initialState, const AsyncValue<List<SportView>>.loading());
    });

    test('fetchAllSports should update state with sports on success', () async {
      final sports = [
        const Sport(id: '1', name: 'Football'),
        const Sport(id: '2', name: 'Basketball'),
      ];
      when(mockSports.getAllSports())
          .thenAnswer((_) async => Result.success(sports));

      await container.read(sportsViewModelProvider.notifier).fetchSports();

      final updatedState = container.read(sportsViewModelProvider);
      expect(updatedState, isA<AsyncData<List<SportView>>>());
      expect(updatedState.value, sports.map(SportView.fromDomain).toList());
    });

    test('fetchAllSports should update state with error on failure', () async {
      when(mockSports.getAllSports())
          .thenAnswer((_) async => Result.failure('Error fetching sports'));

      await container.read(sportsViewModelProvider.notifier).fetchSports();

      final updatedState = container.read(sportsViewModelProvider);
      expect(updatedState, isA<AsyncError<List<SportView>>>());
      expect(updatedState.error, 'Error fetching sports');
    });

    test('addSport should call createSport on Sports', () async {
      const sport = Sport(id: '3', name: 'Tennis');
      when(mockSports.createSport(sport))
          .thenAnswer((_) async => Result.success(sport));

      final result = await container
          .read(sportsViewModelProvider.notifier)
          .addSport(sport);

      expect(result.isSuccess, true);
      expect(result.value, sport);
      verify(mockSports.createSport(sport)).called(1);
    });

    test('updateSport should call updateSport on Sports', () async {
      const sport = Sport(id: '1', name: 'American Football');
      when(mockSports.updateSport(sport))
          .thenAnswer((_) async => Result.success(sport));

      final result = await container
          .read(sportsViewModelProvider.notifier)
          .updateSport(sport);

      expect(result.isSuccess, true);
      expect(result.value, sport);
      verify(mockSports.updateSport(sport)).called(1);
    });

    test('getSportById should call getSportById on Sports', () async {
      const sport = Sport(id: '1', name: 'Football');
      when(mockSports.getSportById('1'))
          .thenAnswer((_) async => Result.success(sport));

      final result = await container
          .read(sportsViewModelProvider.notifier)
          .getSportById('1');

      expect(result.isSuccess, true);
      expect(result.value, sport);
      verify(mockSports.getSportById('1')).called(1);
    });

    test('getSportsByIds should call getSportsByIds on Sports', () async {
      final sports = [
        const Sport(id: '1', name: 'Football'),
        const Sport(id: '2', name: 'Basketball'),
      ];
      when(mockSports.getSportsByIds(['1', '2']))
          .thenAnswer((_) async => Result.success(sports));

      final result = await container
          .read(sportsViewModelProvider.notifier)
          .getSportsByIds(['1', '2']);

      expect(result.isSuccess, true);
      expect(result.value, sports);
      verify(mockSports.getSportsByIds(['1', '2'])).called(1);
    });
  });

  group('sportsViewModelProvider', () {
    test('should create SportsViewModel', () {
      final viewModel = container.read(sportsViewModelProvider.notifier);
      expect(viewModel, isA<SportViewModel>());
    });
  });
}
