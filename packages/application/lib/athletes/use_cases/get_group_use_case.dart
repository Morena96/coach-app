import 'package:domain/features/athletes/entities/group.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetGroupByIdUseCase {
  final Groups repository;

  GetGroupByIdUseCase(this.repository);

  Future<Result<Group>> execute(String groupId) {
    return repository.getGroupById(groupId);
  }
}
