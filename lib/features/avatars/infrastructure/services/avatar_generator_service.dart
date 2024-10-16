import 'package:coach_app/features/athletes/infrastructure/services/avatar_generator_service.dart';
import 'package:random_avatar/random_avatar.dart';

class FakeAvatarGeneratorService implements AvatarGeneratorService {
  @override
  String generateAvatar() {
    return RandomAvatarString(
      DateTime.now().toIso8601String(),
    );
  }
}
