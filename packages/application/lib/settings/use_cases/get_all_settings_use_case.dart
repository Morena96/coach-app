import 'package:domain/features/settings/entities/setting.dart';
import 'package:domain/features/settings/repositories/settings.dart';

class GetAllSettingsUseCase {
  final SettingsRepository _repository;

  GetAllSettingsUseCase(this._repository);

  Future<List<Setting>> execute() => _repository.getAllSettings();
}