import 'package:application/athletes/use_cases/create_new_athlete_use_case.dart';
import 'package:application/athletes/use_cases/delete_athlete_use_case.dart';
import 'package:application/athletes/use_cases/get_all_athletes_by_page_use_case.dart';
import 'package:application/athletes/use_cases/get_athlete_use_case.dart';
import 'package:application/athletes/use_cases/restore_athlete_use_case.dart';
import 'package:application/athletes/use_cases/update_athlete_use_case.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/avatars/infrastructure/adapters/image_data_factory_impl.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model.dart';

@GenerateMocks([
  Athletes,
  GetAllAthletesByPageUseCase,
  DeleteAthleteUseCase,
  RestoreAthleteUseCase,
  CreateNewAthleteUseCase,
  GetAthleteByIdUseCase,
  UpdateAthleteUseCase,
])
import 'athletes_view_model_test.mocks.dart';

void main() {
  late MockGetAllAthletesByPageUseCase mockGetAllAthletesByPageUseCase;
  late MockDeleteAthleteUseCase mockDeleteAthleteUseCase;
  late MockRestoreAthleteUseCase mockRestoreAthleteUseCase;
  late MockCreateNewAthleteUseCase mockCreateNewAthleteUseCase;
  late MockGetAthleteByIdUseCase mockGetAthleteByIdUseCase;
  late MockUpdateAthleteUseCase mockUpdateAthleteUseCase;
  late AthletesViewModel athletesViewModel;
  late ProviderContainer container;
  late ImageDataFactoryImpl imageDataFactory;

  setUp(() {
    mockGetAllAthletesByPageUseCase = MockGetAllAthletesByPageUseCase();
    mockDeleteAthleteUseCase = MockDeleteAthleteUseCase();
    mockRestoreAthleteUseCase = MockRestoreAthleteUseCase();
    mockCreateNewAthleteUseCase = MockCreateNewAthleteUseCase();
    mockGetAthleteByIdUseCase = MockGetAthleteByIdUseCase();
    mockUpdateAthleteUseCase = MockUpdateAthleteUseCase();
    imageDataFactory = ImageDataFactoryImpl();

    when(mockGetAllAthletesByPageUseCase.execute(any, any))
        .thenAnswer((_) async => Result.success([]));

    athletesViewModel = AthletesViewModel(
      mockGetAllAthletesByPageUseCase,
      mockDeleteAthleteUseCase,
      mockRestoreAthleteUseCase,
      mockCreateNewAthleteUseCase,
      mockGetAthleteByIdUseCase,
      mockUpdateAthleteUseCase,
    );

    container = ProviderContainer(
      overrides: [
        athletesViewModelProvider.overrideWith((ref) => athletesViewModel),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AthletesViewModel', () {
    test('initializes with correct default values', () {
      expect(athletesViewModel.pagingController.firstPageKey, 0);
      expect(athletesViewModel.pagingController.itemList, isNull);
      expect(athletesViewModel.currentNameFilter, isEmpty);
      expect(athletesViewModel.currentSportsFilter, isEmpty);
      expect(athletesViewModel.currentSort.order, SortOrder.ascending);
    });

    test('fetchItems calls getAllAthletesByPageUseCase with correct parameters',
        () async {
      when(mockGetAllAthletesByPageUseCase.execute(any, any,
              filterCriteria: anyNamed('filterCriteria'),
              sortCriteria: anyNamed('sortCriteria')))
          .thenAnswer((_) async => Result.success([]));

      await athletesViewModel.fetchItems(1, 50);

      verify(mockGetAllAthletesByPageUseCase.execute(1, 50,
              filterCriteria: anyNamed('filterCriteria'),
              sortCriteria: anyNamed('sortCriteria')))
          .called(1);
    });

    test('convertItem correctly converts Athlete to AthleteView', () {
      const athlete = Athlete(
          id: '1',
          name: 'John Doe',
          sports: [Sport(id: '1', name: 'Football')]);
      final athleteView = athletesViewModel.convertItem(athlete);

      expect(athleteView, isA<AthleteView>());
      expect(athleteView.id, athlete.id);
      expect(athleteView.name, athlete.name);
      expect(athleteView.sports?.first.name, 'Football');
    });

    test('deleteItemFromService calls deleteAthleteUseCase with correct id',
        () async {
      const athleteView = AthleteView(
          id: '1', name: 'John Doe', avatarPath: '', sports: [], groups: []);
      when(mockDeleteAthleteUseCase.execute(any))
          .thenAnswer((_) async => Result.success(null));

      await athletesViewModel.deleteItemFromService(athleteView);

      verify(mockDeleteAthleteUseCase.execute('1')).called(1);
    });

    test('updateNameFilter updates filter and applies criteria', () {
      athletesViewModel.updateNameFilter('John');
      expect(athletesViewModel.currentNameFilter, 'John');
    });

    test('updateSort changes sort order for same field', () {
      athletesViewModel.updateSort('name');
      expect(athletesViewModel.currentSort.field, 'name');
      expect(athletesViewModel.currentSort.order, SortOrder.descending);

      athletesViewModel.updateSort('name');
      expect(athletesViewModel.currentSort.field, 'name');
      expect(athletesViewModel.currentSort.order, SortOrder.ascending);
    });

    test('updateSort changes field and resets order to ascending', () {
      athletesViewModel.updateSort('name');
      athletesViewModel.updateSort('age');
      expect(athletesViewModel.currentSort.field, 'age');
      expect(athletesViewModel.currentSort.order, SortOrder.ascending);
    });

    test('addAthlete calls createNewAthleteUseCase', () async {
      final athleteData = {'name': 'John Doe'};
      final sportIds = ['1', '2'];
      final avatar = imageDataFactory.createFromBytes([1, 2, 3]);

      when(mockCreateNewAthleteUseCase.execute(any, any, any))
          .thenAnswer((_) async => Result.success(Athlete.empty()));

      await athletesViewModel.addAthlete(athleteData, sportIds, avatar);

      verify(mockCreateNewAthleteUseCase.execute(athleteData, sportIds, avatar))
          .called(1);
    });

    test('updateAthlete calls updateAthleteUseCase', () async {
      const athlete = Athlete(id: '1', name: 'John Doe');
      final athleteData = {'name': 'John Updated'};

      when(mockUpdateAthleteUseCase.execute(any, any, any))
          .thenAnswer((_) async => Result.success(null));

      await athletesViewModel.updateAthlete(athlete, athleteData, null);

      verify(mockUpdateAthleteUseCase.execute(athlete, athleteData, null))
          .called(1);
    });

    test('getAthleteById calls getAthleteByIdUseCase', () async {
      when(mockGetAthleteByIdUseCase.execute(any)).thenAnswer((_) async =>
          Result.success(const Athlete(id: '1', name: 'John Doe')));

      await athletesViewModel.getAthleteById('1');

      verify(mockGetAthleteByIdUseCase.execute('1')).called(1);
    });
  });
}
