import 'package:application/settings/use_cases/get_all_settings_use_case.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_all_settings_use_case_provider.g.dart';

@riverpod
GetAllSettingsUseCase getAllSettingsUseCase(GetAllSettingsUseCaseRef ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetAllSettingsUseCase(repository);
}
