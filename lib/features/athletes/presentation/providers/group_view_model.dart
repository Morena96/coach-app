import 'package:application/athletes/use_cases/get_group_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/models/group_view.dart';

/// ViewModel for managing the state of the AthleteViewPage.
class GroupViewModel extends StateNotifier<AsyncValue<GroupView>> {
  final GetGroupByIdUseCase _getGroupByIdUseCase;

  GroupViewModel(this._getGroupByIdUseCase) : super(const AsyncValue.loading());

  /// Fetches the group data by ID.
  Future<void> fetchGroup(String groupId) async {
    state = const AsyncValue.loading();
    final result = await _getGroupByIdUseCase.execute(groupId);
    if (result.isSuccess) {
      state = AsyncValue.data(GroupView.fromDomain(result.value!));
    } else {
      state = AsyncValue.error(
        result.error ?? 'Unknown error',
        StackTrace.current,
      );
    }
  }
}
