import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetMemberCountForGroupUseCase {
  final Members _membersRepository;

  GetMemberCountForGroupUseCase(this._membersRepository);

  Future<Result<int>> execute(String groupId) async {
    return _membersRepository.getMemberCountForGroup(groupId);
  }
}