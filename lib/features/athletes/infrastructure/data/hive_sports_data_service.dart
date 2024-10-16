import 'dart:async';

import 'package:coach_app/features/athletes/infrastructure/data/models/hive_sport.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveSportsDataService extends SportsService {
  late Box<HiveSport> sportsBox;
  late LoggerRepository loggerRepository;
  List<Sport>? _cachedSports;
  Timer? _cacheTimer;
  final Duration _cacheDuration = const Duration(seconds: 10);

  HiveSportsDataService(
    this.sportsBox,
    this.loggerRepository,
  );

  Future<List<Sport>> _getCachedSports() async {
    if (_cachedSports == null) {
      _cachedSports = sportsBox.values.map((e) => e.toDomain()).toList();
      _resetCacheTimer();
    }
    return _cachedSports!;
  }

  void _resetCacheTimer() {
    _cacheTimer?.cancel();
    _cacheTimer = Timer(_cacheDuration, () {
      _cachedSports = null;
    });
  }

  @override
  Future<List<Sport>> getAllSports(
      {SportFilterCriteria? filterCriteria}) async {
    return _getCachedSports();
  }

  @override
  Future<List<Sport>> getSportsByIds(List<String> ids) async {
    return sportsBox.values
        .where((e) => ids.contains(e.id))
        .map((e) => e.toDomain())
        .toList();
  }

  @override
  Future<List<Sport>> getSportsByPage(
    int page,
    int pageSize, {
    SportFilterCriteria? filterCriteria,
  }) async {
    List<Sport> allSports = await _getCachedSports();

    // Apply filter criteria
    if (filterCriteria != null && filterCriteria.name != null) {
      allSports = allSports
          .where((sport) => sport.name
              .toLowerCase()
              .contains(filterCriteria.name!.toLowerCase()))
          .toList();
    }

    // Sort sports by name
    allSports.sort((a, b) => a.name.compareTo(b.name));

    // Calculate pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    // Return paginated results
    if (startIndex >= allSports.length) {
      return [];
    }

    return allSports.sublist(startIndex, endIndex.clamp(0, allSports.length));
  }

  @override
  Future<Sport> createSport(Sport sport) async {
    HiveSport hiveSport = HiveSport.fromDomain(sport);
    await sportsBox.put(sport.id, hiveSport);
    _cachedSports = null;
    return sport;
  }

  @override
  Future<void> deleteSport(String id) async {
    await sportsBox.delete(id);
    _cachedSports = null;
  }

  @override
  Future<Sport> getSportById(String id) async {
    final sport = sportsBox.get(id);
    if (sport == null) {
      throw Exception('Sport not found');
    }
    return sport.toDomain();
  }

  @override
  Future<Sport> updateSport(Sport sport) async {
    await sportsBox.put(sport.id, HiveSport.fromDomain(sport));
    _cachedSports = null;
    return sport;
  }

  void dispose() {
    _cacheTimer?.cancel();
  }
}
