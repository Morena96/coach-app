import 'package:domain/features/settings/entities/setting.dart';
import 'package:domain/features/settings/repositories/settings.dart';

class GetSettingUseCase {
  final SettingsRepository _repository;

  GetSettingUseCase(this._repository);

  Future<Setting?> execute(String key) => _repository.getSettingByKey(key);
}