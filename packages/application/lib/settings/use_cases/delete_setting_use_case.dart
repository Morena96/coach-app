import 'package:domain/features/settings/repositories/settings.dart';

class DeleteSettingUseCase {
  final SettingsRepository _repository;

  DeleteSettingUseCase(this._repository);

  Future<void> execute(String key) => _repository.deleteSetting(key);
}