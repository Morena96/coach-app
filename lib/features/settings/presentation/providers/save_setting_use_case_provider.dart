import 'package:application/settings/use_cases/save_setting_use_case.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'save_setting_use_case_provider.g.dart';

@riverpod
Future<void> saveSettingUseCase(SaveSettingUseCaseRef ref, Setting setting) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return SaveSettingUseCase(settingsRepository).execute(setting);
}