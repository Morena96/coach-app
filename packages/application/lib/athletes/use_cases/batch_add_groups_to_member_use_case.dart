import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class BatchAddGroupsToMemberUseCase {
  final Members _membersRepository;

  BatchAddGroupsToMemberUseCase(this._membersRepository);

  Future<Result<List<Member>>> execute(
      String athleteId, List<String> groupIds, GroupRole role) async {
    return _membersRepository.batchAddGroupsToMember(athleteId, groupIds, role);
  }
}
