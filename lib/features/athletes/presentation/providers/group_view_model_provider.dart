import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/get_group_by_id_use_case_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/group_view_model.dart';

final groupViewViewModelProvider = StateNotifierProvider.autoDispose
    .family<GroupViewModel, AsyncValue<GroupView>, String>(
  (ref, groupId) {
    final getGroupByIdUseCase = ref.watch(getGroupByIdUseCaseProvider);
    return GroupViewModel(getGroupByIdUseCase)..fetchGroup(groupId);
  },
);
