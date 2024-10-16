import 'package:domain/features/athletes/entities/athlete.dart';

class PaginatedAthletes {
  final List<Athlete> athletes;
  final int totalCount;
  final int currentPage;
  final int pageSize;

  PaginatedAthletes({
    required this.athletes,
    required this.totalCount,
    required this.currentPage,
    required this.pageSize,
  });
}
