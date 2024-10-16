import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class IsAthleteMemberOfGroupUseCase {
  final Members _membersRepository;

  IsAthleteMemberOfGroupUseCase(this._membersRepository);

  Future<Result<bool>> execute(String athleteId, String groupId) async {
    return _membersRepository.isAthleteMemberOfGroup(athleteId, groupId);
  }
}