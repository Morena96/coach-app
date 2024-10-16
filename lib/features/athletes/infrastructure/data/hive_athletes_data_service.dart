import 'dart:async';

import 'package:coach_app/features/athletes/infrastructure/data/models/hive_athlete.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveAthletesDataService extends AthletesService {
  late Box<HiveAthlete> athletesBox;
  late LoggerRepository loggerRepository;
  List<Athlete>? _cachedAthletes;
  Timer? _cacheTimer;
  final Duration _cacheDuration = const Duration(seconds: 10);
  final SportsService sportsService;

  HiveAthletesDataService(
    this.athletesBox,
    this.sportsService,
    this.loggerRepository,
  );

  Future<List<Athlete>> _getCachedAthletes() async {
    if (_cachedAthletes == null) {
      final sports = await sportsService.getAllSports();
      _cachedAthletes =
          athletesBox.values.map((e) => e.toDomain(sports)).toList();
      _resetCacheTimer();
    }
    return _cachedAthletes!;
  }

  void _resetCacheTimer() {
    _cacheTimer?.cancel();
    _cacheTimer = Timer(_cacheDuration, () {
      _cachedAthletes = null;
    });
  }

  @override
  Future<void> initializeDatabase() async {
  }

  @override
  Future<void> resetAndRefreshDatabase() async {
    await athletesBox.clear();
    _cachedAthletes = null;
    _resetCacheTimer();
    loggerRepository.info('Database reset and refreshed');
  }

  @override
  Future<Athlete> createAthlete(Athlete athlete) async {
    HiveAthlete hiveAthlete = HiveAthlete.fromDomain(athlete);
    await athletesBox.put(athlete.id, hiveAthlete);
    _cachedAthletes = null;
    return athlete;
  }

  @override
  Future<void> deleteAthlete(String id) async {
    final athlete = await getAthleteById(id);
    final updatedAthlete = athlete.copyWith(archived: true);
    await updateAthlete(updatedAthlete);
    _cachedAthletes = null;
  }

  @override
  Future<Athlete> restoreAthlete(String id) async {
    final athlete = await getAthleteById(id);
    final restoredAthlete = athlete.copyWith(archived: false);
    await updateAthlete(restoredAthlete);
    _cachedAthletes = null;
    return restoredAthlete;
  }

  @override
  Future<List<Athlete>> getAllAthletes() async {
    return _getCachedAthletes();
  }

  @override
  Future<List<Athlete>> getAthletesByIds(List<String> ids) async {
    var allAthletes = await _getCachedAthletes();
    return allAthletes.where((athlete) => ids.contains(athlete.id)).toList();
  }

  @override
  Future<Athlete> getAthleteById(String id) async {
    final athlete = athletesBox.get(id);
    if (athlete == null) {
      throw Exception('Athlete not found');
    }
    final sports = await sportsService.getSportsByIds(athlete.sportIds ?? []);
    return athlete.toDomain(sports);
  }

  @override
  Future<List<Athlete>> getAthletesByPage(
    int page,
    int pageSize, {
    AthleteFilterCriteria? filterCriteria,
    AthleteSortCriteria? sortCriteria,
  }) async {
    var allAthletes = await _getCachedAthletes();

    // Apply filter criteria
    if (filterCriteria != null) {
      allAthletes = allAthletes.where((athlete) {
        if (filterCriteria.name != null &&
            !athlete.name
                .toLowerCase()
                .contains(filterCriteria.name!.toLowerCase())) {
          return false;
        }
        if (filterCriteria.isArchived != null &&
            athlete.archived != filterCriteria.isArchived) {
          return false;
        }
        return true;
      }).toList();
    }

    // Apply sort criteria
    if (sortCriteria != null) {
      allAthletes.sort((a, b) {
        int comparison;
        if (sortCriteria.field == 'name') {
          comparison = a.name.compareTo(b.name);
        } else {
          // Default to sorting by name if field is not recognized
          comparison = a.name.compareTo(b.name);
        }
        return sortCriteria.order == SortOrder.ascending
            ? comparison
            : -comparison;
      });
    }

    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    if (startIndex >= allAthletes.length) {
      return [];
    }

    return allAthletes.sublist(
        startIndex, endIndex.clamp(0, allAthletes.length));
  }

  @override
  Future<Athlete> updateAthlete(Athlete athlete) async {
    await athletesBox.put(athlete.id, HiveAthlete.fromDomain(athlete));
    _cachedAthletes = null;
    return athlete;
  }

  @override
  Future<List<Athlete>> getAthletesByFilterCriteria(
      FilterCriteria filterCriteria) async {
    final allAthletes = await _getCachedAthletes();
    return allAthletes.where((athlete) {
      var criteria = filterCriteria.toMap();

      if (criteria['name'] != null) {
        if (!athlete.name
            .toLowerCase()
            .contains(criteria['name'].toLowerCase())) {
          return false;
        }
      }

      if (criteria['isArchived'] != null) {
        if (athlete.archived != criteria['isArchived']) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  void dispose() {
    _cacheTimer?.cancel();
  }
}
