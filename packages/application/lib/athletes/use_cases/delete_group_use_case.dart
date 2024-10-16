import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/shared/utilities/result.dart';

class DeleteGroupUseCase {
  final Groups repository;

  DeleteGroupUseCase(this.repository);

  Future<Result<void>> execute(String groupId) {
    return repository.deleteGroup(groupId);
  }
}
