import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class SearchMembersInGroupUseCase {
  final Members _membersRepository;

  SearchMembersInGroupUseCase(this._membersRepository);

  Future<Result<List<Member>>> execute(String groupId, String searchTerm) async {
    return _membersRepository.searchMembersInGroup(groupId, searchTerm);
  }
}