import 'package:domain/features/settings/entities/setting.dart';
import 'package:domain/features/settings/repositories/settings.dart';

class SaveSettingUseCase {
  final SettingsRepository _repository;

  SaveSettingUseCase(this._repository);

  Future<void> execute(Setting setting) => _repository.saveSetting(setting);
}