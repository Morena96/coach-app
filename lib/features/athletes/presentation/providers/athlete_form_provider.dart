import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/avatars/entities/avatar_status.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';

part 'athlete_form_provider.g.dart';

@riverpod
class AthleteForm extends _$AthleteForm {
  @override
  AthleteFormState build() {
    return AthleteFormState();
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

  /// Adds a sport to the list
  void addSport(SportView sport) {
    final updatedSports = [...state.sports, sport];
    state = state.copyWith(sports: updatedSports);
  }

  /// Removes a sport from the list
  void removeSport(SportView sport) {
    final updatedSports = state.sports.where((s) => s != sport).toList();
    state = state.copyWith(sports: updatedSports);
  }

  void setFullName(String name) {
    state = state.copyWith(fullName: name);
  }

  /// Sets the sports list
  void setSports(List<SportView> sports) {
    state = state.copyWith(sports: sports);
  }

  Future<Result<AthleteView>> saveAthlete() async {
    final athletesViewModel = ref.read(athletesViewModelProvider.notifier);

    final athleteData = {
      'name': state.fullName,
    };

    return athletesViewModel.addAthlete(
      athleteData,
      state.sports.map((sport) => sport.id).toList(),
      state.avatar,
    );
  }

  Future<Result<void>> updateAthlete(AthleteView athlete) async {
    final athletesViewModel = ref.read(athletesViewModelProvider.notifier);
    final athleteData = {
      'name': state.fullName,
      'sports': state.sports.map((sport) => sport.id).toList(),
    };

    if (state.avatar != null) {
      athleteData['avatar'] = state.avatar;
    }

    final result = await athletesViewModel.updateAthlete(
      Athlete(
        id: athlete.id,
        name: athlete.name,
        sports: state.sports
            .map((sport) => Sport(id: sport.id, name: sport.name))
            .toList(),
        avatarId: athlete.avatarPath,
      ),
      athleteData,
      shouldUpdateAvatar ? state.avatar : null,
    );

    return result;
  }
}

class AthleteFormState {
  final String? fullName;
  final ImageData? avatar;
  final AvatarStatus avatarStatus;
  final List<SportView> sports;

  AthleteFormState({
    this.fullName,
    this.avatar,
    this.avatarStatus = AvatarStatus.initial,
    this.sports = const [],
  });

  bool isValid() => (fullName ?? '').isNotEmpty && sports.isNotEmpty;

  AthleteFormState copyWith({
    String? fullName,
    ImageData? avatar,
    List<SportView>? sports,
    AvatarStatus? avatarStatus,
    bool clearAvatar = false,
  }) {
    return AthleteFormState(
      fullName: fullName ?? this.fullName,
      avatar: clearAvatar ? null : (avatar ?? this.avatar),
      sports: sports ?? this.sports,
      avatarStatus: avatarStatus ?? this.avatarStatus,
    );
  }
}
