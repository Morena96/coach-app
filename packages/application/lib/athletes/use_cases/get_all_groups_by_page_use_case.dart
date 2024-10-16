import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetAllGroupsByPageUseCase {
  final Groups _groupsRepository;

  GetAllGroupsByPageUseCase(this._groupsRepository);

  Future<Result<List<Group>>> execute(
    int page,
    int pageSize, {
    GroupsFilterCriteria? filterCriteria,
  }) async {
    return _groupsRepository.getGroupsByPage(
      page,
      pageSize,
      filterCriteria: filterCriteria,
    );
  }
}
