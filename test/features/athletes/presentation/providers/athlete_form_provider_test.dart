import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:domain/features/avatars/entities/avatar_status.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/athletes/presentation/models/sport_view.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_form_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';

import '../../../../mocks.mocks.dart';

// Generate mocks

void main() {
  late MockAthletesViewModel mockAthletesViewModel;
  late ProviderContainer container;

  setUp(() {
    mockAthletesViewModel = MockAthletesViewModel();
    container = ProviderContainer(
      overrides: [
        athletesViewModelProvider.overrideWith((ref) => mockAthletesViewModel),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('setAvatar updates state correctly', () {
    final athleteForm = container.read(athleteFormProvider.notifier);
    final mockImageData = MockImageData();

    athleteForm.setAvatar(mockImageData);

    expect(athleteForm.state.avatar, mockImageData);
    expect(athleteForm.state.avatarStatus, AvatarStatus.selected);
  });

  test('deleteAvatar updates state correctly', () {
    final athleteForm = container.read(athleteFormProvider.notifier);

    athleteForm.deleteAvatar();

    expect(athleteForm.state.avatar, null);
    expect(athleteForm.state.avatarStatus, AvatarStatus.initial);
  });

  test('addSport adds sport to the list', () {
    final athleteForm = container.read(athleteFormProvider.notifier);
    const sport = SportView(id: '1', name: 'Football');

    athleteForm.addSport(sport);

    expect(athleteForm.state.sports, contains(sport));
  });

  test('removeSport removes sport from the list', () {
    final athleteForm = container.read(athleteFormProvider.notifier);
    const sport = SportView(id: '1', name: 'Football');

    athleteForm.addSport(sport);
    athleteForm.removeSport(sport);

    expect(athleteForm.state.sports, isEmpty);
  });

  test('setFullName updates state correctly', () {
    final athleteForm = container.read(athleteFormProvider.notifier);

    athleteForm.setFullName('John Doe');

    expect(athleteForm.state.fullName, 'John Doe');
  });

  test('saveAthlete calls addAthlete on AthletesViewModel', () async {
    final athleteForm = container.read(athleteFormProvider.notifier);
    athleteForm.setFullName('John Doe');
    const sport = SportView(id: '1', name: 'Football');
    athleteForm.addSport(sport);

    when(mockAthletesViewModel.addAthlete(any, any, any))
        .thenAnswer((_) async => Result<AthleteView>.success(null));

    await athleteForm.saveAthlete();

    verify(mockAthletesViewModel.addAthlete(
      {'name': 'John Doe'},
      ['1'],
      null,
    )).called(1);
  });

  test('isValid returns true when form is valid', () {
    final athleteForm = container.read(athleteFormProvider.notifier);
    athleteForm.setFullName('John Doe');
    athleteForm.addSport(const SportView(id: '1', name: 'Football'));

    expect(athleteForm.state.isValid(), true);
  });

  test('isValid returns false when form is invalid', () {
    final athleteForm = container.read(athleteFormProvider.notifier);

    expect(athleteForm.state.isValid(), false);
  });
}

class MockImageData extends Mock implements ImageData {}
