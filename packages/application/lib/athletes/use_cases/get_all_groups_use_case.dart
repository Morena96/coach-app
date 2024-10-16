import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetAllGroupsUseCase {
  final Groups _groupsRepository;

  GetAllGroupsUseCase(this._groupsRepository);

  Future<Result<List<Group>>> execute() async {
    return _groupsRepository.getAllGroups();
  }
}
