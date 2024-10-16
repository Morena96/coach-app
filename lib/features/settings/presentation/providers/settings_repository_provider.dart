import 'package:coach_app/features/settings/infrastructure/repositories/settings_repository_impl.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_data_source_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_repository_provider.g.dart';

@riverpod
SettingsRepositoryImpl settingsRepository(SettingsRepositoryRef ref) {
  final dataSource = ref.watch(settingsDataSourceProvider);
  return SettingsRepositoryImpl(dataSource);
}
