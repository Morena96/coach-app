import 'package:domain/features/avatars/entities/avatar_status.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';

part 'group_form_provider.g.dart';

@riverpod
class GroupForm extends _$GroupForm {
  @override
  GroupFormState build() {
    return GroupFormState();
  }

  bool shouldUpdateAvatar = false;

  /// Sets the selected avatar image without uploading
  void setAvatar(ImageData avatarImage, {bool shouldUpdate = false}) {
    state = state.copyWith(
      avatar: avatarImage,
      avatarStatus: AvatarStatus.selected,
    );
    if (shouldUpdate) shouldUpdateAvatar = true;
  }

  /// Deletes the selected avatar image
  void deleteAvatar() {
    state = state.copyWith(
      clearAvatar: true,
      avatarStatus: AvatarStatus.initial,
    );
  }

  void setSport(SportView sport) {
    state = state.copyWith(sport: sport);
  }

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setDescription(String? description) {
    state = state.copyWith(description: description);
  }

  /// Sets the created group after successful creation
  void setCreatedGroup(GroupView group) {
    state = state.copyWith(createdGroup: group);
  }

  Future<Result<void>> save() async {
    final groupsViewModel = ref.read(groupsViewModelProvider.notifier);

    final groupData = {
      'name': state.name,
      'description': state.description,
    };

    final result = await groupsViewModel.addGroup(
      groupData,
      state.name ?? '',
      state.description,
      state.sport,
      state.avatar,
    );

    if (result.isSuccess) {
      final createdGroup = GroupView.fromDomain(result.value!);
      setCreatedGroup(createdGroup);
    }

    return result;
  }

  Future<Result<void>> update(GroupView group) async {
    final groupsViewModel = ref.read(groupsViewModelProvider.notifier);
    final groupData = {
      'name': state.name,
      'sport': state.sport,
    };

    if (state.avatar != null) {
      groupData['avatar'] = state.avatar;
    }
    final result = await groupsViewModel.updateGroup(
      GroupView(
        id: group.id,
        name: state.name ?? group.name,
        sport: state.sport,
        description: state.description,
        avatarId: group.avatarId,
        members: const [],
      ),
      groupData,
      shouldUpdateAvatar ? state.avatar : null,
    );

    return result;
  }
}

class GroupFormState {
  final String? name;
  final String? description;
  final ImageData? avatar;
  final AvatarStatus avatarStatus;
  final SportView? sport;
  final GroupView? createdGroup;

  GroupFormState({
    this.name,
    this.description,
    this.avatar,
    this.avatarStatus = AvatarStatus.initial,
    this.sport,
    this.createdGroup,
  });

  bool isValid() => (name ?? '').isNotEmpty && sport != null;

  GroupFormState copyWith({
    String? name,
    String? description,
    ImageData? avatar,
    SportView? sport,
    AvatarStatus? avatarStatus,
    GroupView? createdGroup,
    bool clearAvatar = false,
  }) {
    return GroupFormState(
      name: name ?? this.name,
      description: description ?? this.description,
      avatar: clearAvatar ? null : (avatar ?? this.avatar),
      sport: sport ?? this.sport,
      avatarStatus: avatarStatus ?? this.avatarStatus,
      createdGroup: createdGroup ?? this.createdGroup,
    );
  }
}
