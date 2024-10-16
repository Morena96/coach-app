import 'package:coach_app/features/avatars/infrastructure/services/avatar_generator_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FakeAvatarGeneratorService', () {
    late FakeAvatarGeneratorService service;

    setUp(() {
      service = FakeAvatarGeneratorService();
    });

    test('generateAvatar should return a non-empty string', () {
      final avatar = service.generateAvatar();
      expect(avatar, isNotEmpty);
    });

    test('generateAvatar should return different values on successive calls',
        () {
      final avatar1 = service.generateAvatar();

      // Wait a millisecond to ensure a different timestamp
      Future.delayed(const Duration(milliseconds: 1));

      final avatar2 = service.generateAvatar();
      expect(avatar1, isNot(equals(avatar2)));
    });
  });
}
