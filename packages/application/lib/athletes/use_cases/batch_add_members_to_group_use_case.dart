import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class BatchAddMembersToGroupUseCase {
  final Members _membersRepository;

  BatchAddMembersToGroupUseCase(this._membersRepository);

  Future<Result<List<Member>>> execute(String groupId, List<String> athleteIds, GroupRole role) async {
    return _membersRepository.batchAddMembersToGroup(groupId, athleteIds, role);
  }
}