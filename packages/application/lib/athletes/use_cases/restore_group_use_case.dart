import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/shared/utilities/result.dart';

class RestoreGroupUseCase {
  final Groups repository;

  RestoreGroupUseCase(this.repository);

  Future<Result<void>> execute(String groupId) {
    return repository.restoreGroup(groupId);
  }
}
