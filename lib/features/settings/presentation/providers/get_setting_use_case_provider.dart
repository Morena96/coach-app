import 'package:application/settings/use_cases/get_setting_use_case.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_setting_use_case_provider.g.dart';

@riverpod
GetSettingUseCase getSettingUseCase(GetSettingUseCaseRef ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetSettingUseCase(repository);
}
