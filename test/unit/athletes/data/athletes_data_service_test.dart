import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/infrastructure/data/hive_athletes_data_service.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_athlete.dart';

import 'package:mockito/annotations.dart';
import 'package:hive/hive.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/logging/repositories/logger.dart';

@GenerateMocks([
  Box<HiveAthlete>,
  SportsService,
  LoggerRepository,
], customMocks: [
  MockSpec<Box>(as: #MockAthleteBox),
])

import 'athletes_data_service_test.mocks.dart';

void main() {
  late HiveAthletesDataService dataService;
  late MockBox<HiveAthlete> mockBox;
  late MockLoggerRepository mockLoggerRepository;
  late MockSportsService mockSportsService;

  setUp(() {
    mockBox = MockBox<HiveAthlete>();
    mockLoggerRepository = MockLoggerRepository();
    mockSportsService = MockSportsService();

    dataService = HiveAthletesDataService(
        mockBox as Box<HiveAthlete>, mockSportsService, mockLoggerRepository);
  });

  group('AthletesDataService', () {
    test('createAthlete should add athlete to the box', () async {
      final hiveAthlete = HiveAthlete(id: '1', name: 'John Doe');

      when(mockBox.put('1', any)).thenAnswer((_) => Future.value());

      await dataService.createAthlete(hiveAthlete.toDomain([]));

      // verify that the put method was called with the correct athlete
      // note that the HiveAthlete instance is created from the Athlete instance
      // and won't be equal to the original HiveAthlete instance
      verify(mockBox.put('1', any)).called(1);
    });

    test('deleteAthlete should archive the athlete', () async {
      final athlete = HiveAthlete(id: '1', name: 'John Doe', archived: false);
      when(mockBox.get('1')).thenReturn(athlete);
      when(mockBox.put('1', any)).thenAnswer((_) => Future.value());
      when(mockSportsService.getSportsByIds(any)).thenAnswer((_) async => []);

      await dataService.deleteAthlete('1');

      verify(mockBox.put('1', argThat(predicate((HiveAthlete a) => a.archived == true)))).called(1);
    });

    test('restoreAthlete should unarchive the athlete', () async {
      final athlete = HiveAthlete(id: '1', name: 'John Doe', archived: true);
      when(mockBox.get('1')).thenReturn(athlete);
      when(mockBox.put('1', any)).thenAnswer((_) => Future.value());
      when(mockSportsService.getSportsByIds(any)).thenAnswer((_) async => []);

      await dataService.restoreAthlete('1');

      verify(mockBox.put('1', argThat(predicate((HiveAthlete a) => a.archived == false)))).called(1);
    });

    test('getAllAthletes should return all athletes from the box', () async {
      final athletes = [
        HiveAthlete(id: '1', name: 'John Doe'),
        HiveAthlete(id: '2', name: 'Jane Doe'),
      ];
      when(mockBox.values).thenReturn(athletes);
      when(mockSportsService.getAllSports()).thenAnswer((_) async => []);

      final result = await dataService.getAllAthletes();

      final domainAthletes = athletes.map((e) => e.toDomain([])).toList();

      expect(result, equals(domainAthletes));
    });

    test('getAllAthletes should return all athletes with corresponding sports',
        () async {
      final sports = [
        const Sport(id: 'sport1', name: 'Football'),
        const Sport(id: 'sport2', name: 'Basketball'),
      ];
      final hiveAthletes = [
        HiveAthlete(id: '1', name: 'John Doe', sportIds: ['sport1']),
        HiveAthlete(id: '2', name: 'Jane Doe', sportIds: ['sport2']),
      ];

      when(mockBox.values).thenReturn(hiveAthletes);
      when(mockSportsService.getAllSports()).thenAnswer((_) async => sports);

      final result = await dataService.getAllAthletes();

      expect(result.length, equals(2));
      expect(result[0].id, equals('1'));
      expect(result[0].name, equals('John Doe'));
      expect(result[0].sports?.length, equals(1));
      expect(result[0].sports?[0].id, equals('sport1'));
      expect(result[0].sports?[0].name, equals('Football'));
      expect(result[1].id, equals('2'));
      expect(result[1].name, equals('Jane Doe'));
      expect(result[1].sports?.length, equals(1));
      expect(result[1].sports?[0].id, equals('sport2'));
      expect(result[1].sports?[0].name, equals('Basketball'));

      verify(mockSportsService.getAllSports()).called(1);
    });

    test('getAthletesByFilterCriteria should return all athletes from the box',
        () async {
      final athletes = [
        HiveAthlete(id: '1', name: 'John Doe'),
        HiveAthlete(id: '2', name: 'Jane Doe'),
      ];
      when(mockBox.values).thenReturn(athletes);
      when(mockSportsService.getAllSports()).thenAnswer((_) async => []);

      final result = await dataService
          .getAthletesByFilterCriteria(AthleteFilterCriteria());

      final domainAthletes = athletes.map((e) => e.toDomain([])).toList();

      expect(result, equals(domainAthletes));
    });

    test(
        'getAthletesByFilterCriteria should return all athletes when restrictions are present',
        () async {
      var athlete1 = HiveAthlete(id: '1', name: 'John Doe');
      var athlete2 = HiveAthlete(id: '2', name: 'Jane Doe');
      final athletes = [
        athlete1,
        athlete2,
      ];
      when(mockSportsService.getAllSports()).thenAnswer((_) async => []);
      when(mockBox.values).thenReturn(athletes);

      final result = await dataService
          .getAthletesByFilterCriteria(AthleteFilterCriteria(name: 'John'));

      final filteredAthletes = [athlete1];

      final filteredDomainAthletes =
          filteredAthletes.map((e) => e.toDomain([])).toList();

      expect(result, equals(filteredDomainAthletes));
    });

    test('getAthleteById should return the correct athlete', () async {
      final athlete = HiveAthlete(id: '1', name: 'John Doe');
      when(mockBox.get('1')).thenReturn(athlete);
      when(mockSportsService.getSportsByIds([])).thenAnswer((_) async => []);


      final result = await dataService.getAthleteById('1');

      expect(result, equals(athlete.toDomain([])));
    });

    test('getAthleteById should throw exception when athlete not found',
        () async {
      when(mockBox.get('1')).thenReturn(null);

      expect(() => dataService.getAthleteById('1'), throwsException);
    });

    test('getAthletesByPage should return correct page of athletes', () async {
      final athletes = List.generate(
        20,
        (index) => HiveAthlete(id: index.toString(), name: 'Athlete $index'),
      );
      when(mockBox.values).thenReturn(athletes);
      when(mockSportsService.getAllSports()).thenAnswer((_) async => []);

      final result = await dataService.getAthletesByPage(2, 5);

      expect(result.length, equals(5));
      expect(result.first.id, equals('5'));
      expect(result.last.id, equals('9'));
    });

    test('getAthletesByPage should return empty list for out of range page',
        () async {
      final athletes = List.generate(
        5,
        (index) => HiveAthlete(id: index.toString(), name: 'Athlete $index'),
      );
      when(mockBox.values).thenReturn(athletes);
      when(mockSportsService.getAllSports()).thenAnswer((_) async => []);

      final result = await dataService.getAthletesByPage(3, 5);

      expect(result, isEmpty);
    });

    test(
        'getAthletesByPage with filter criteria should return filtered athletes',
        () async {
      final athletes = [
        HiveAthlete(id: '1', name: 'John Doe'),
        HiveAthlete(id: '2', name: 'Jane Doe'),
        HiveAthlete(id: '3', name: 'Bob Smith'),
      ];
      when(mockBox.values).thenReturn(athletes);
      when(mockSportsService.getAllSports(filterCriteria: null))
          .thenAnswer((_) async => []);

      final filterCriteria = AthleteFilterCriteria(name: 'Doe');
      final result = await dataService.getAthletesByPage(1, 10,
          filterCriteria: filterCriteria);

      expect(result.length, equals(2));
      expect(result.every((athlete) => athlete.name.contains('Doe')), isTrue);
    });

    test('getAthletesByPage with sort criteria should return sorted athletes',
        () async {
      final athletes = [
        HiveAthlete(id: '1', name: 'John Doe'),
        HiveAthlete(id: '2', name: 'Alice Smith'),
        HiveAthlete(id: '3', name: 'Bob Johnson'),
      ];
      when(mockBox.values).thenReturn(athletes);
      when(mockSportsService.getAllSports()).thenAnswer((_) async => []);
      final sortCriteria =
          AthleteSortCriteria(field: 'name', order: SortOrder.ascending);
      final result = await dataService.getAthletesByPage(1, 10,
          sortCriteria: sortCriteria);

      expect(result.length, equals(3));
      expect(result[0].name, equals('Alice Smith'));
      expect(result[1].name, equals('Bob Johnson'));
      expect(result[2].name, equals('John Doe'));
    });

    test(
        'getAthletesByPage with filter and sort criteria should return filtered and sorted athletes',
        () async {
      final athletes = [
        HiveAthlete(id: '1', name: 'John Doe'),
        HiveAthlete(id: '2', name: 'Jane Doe'),
        HiveAthlete(id: '3', name: 'Bob Smith'),
        HiveAthlete(id: '4', name: 'Alice Johnson'),
      ];
      when(mockBox.values).thenReturn(athletes);
      when(mockSportsService.getAllSports()).thenAnswer((_) async => []);

      final filterCriteria = AthleteFilterCriteria(name: 'j');
      final sortCriteria =
          AthleteSortCriteria(field: 'name', order: SortOrder.descending);
      final result = await dataService.getAthletesByPage(1, 10,
          filterCriteria: filterCriteria, sortCriteria: sortCriteria);

      expect(result.length, equals(3));
      expect(result[0].name, equals('John Doe'));
      expect(result[1].name, equals('Jane Doe'));
      expect(result[2].name, equals('Alice Johnson'));
    });

    test('updateAthlete should update the athlete in the box', () async {
      final athlete = HiveAthlete(id: '1', name: 'John Doe Updated');
      when(mockBox.put('1', any)).thenAnswer((_) => Future.value());

      await dataService.updateAthlete(athlete.toDomain([]));

      verify(mockBox.put('1', any)).called(1);
    });
  });
}
