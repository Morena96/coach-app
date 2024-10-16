import 'package:domain/features/athletes/repositories/members.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/features/athletes/infrastructure/repositories/members_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/members_service_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';

part 'members_provider.g.dart';

@Riverpod(keepAlive: true)
Members members(MembersRef ref) {
  final membersService = ref.watch(membersServiceProvider);
  final logger = ref.watch(loggerProvider);

  return MembersImpl(
    membersService,
    logger,
  );
}
