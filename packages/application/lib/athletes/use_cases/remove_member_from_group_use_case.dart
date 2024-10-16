import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class RemoveMemberFromGroupUseCase {
  final Members _membersRepository;

  RemoveMemberFromGroupUseCase(this._membersRepository);

  Future<Result<void>> execute(String groupId, String memberIds) async {
    return _membersRepository.removeMemberFromGroup(groupId, memberIds);
  }
}
