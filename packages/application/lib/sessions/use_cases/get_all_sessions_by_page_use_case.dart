import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:domain/features/sessions/value_objects/sessions_sort_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetAllSessionsByPageUseCase {
  final SessionsRepository _sessionsRepository;

  GetAllSessionsByPageUseCase(this._sessionsRepository);

  Future<Result<List<Session>>> execute(
    int page,
    int pageSize, {
    SessionsFilterCriteria? filterCriteria,
    SessionsSortCriteria? sortCriteria,
  }) async {
    return await _sessionsRepository.getSessionsByPage(page, pageSize,
        filterCriteria: filterCriteria, sortCriteria: sortCriteria);
  }
}
