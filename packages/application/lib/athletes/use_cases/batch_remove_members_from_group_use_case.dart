import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class BatchRemoveMembersFromGroupUseCase {
  final Members _membersRepository;

  BatchRemoveMembersFromGroupUseCase(this._membersRepository);

  Future<Result<void>> execute(String groupId, List<String> memberIds) async {
    return _membersRepository.batchRemoveMembersFromGroup(groupId, memberIds);
  }
}