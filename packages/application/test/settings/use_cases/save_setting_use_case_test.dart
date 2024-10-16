import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:domain/features/settings/repositories/settings.dart';
import 'package:application/settings/use_cases/save_setting_use_case.dart';

@GenerateMocks([SettingsRepository])

import 'save_setting_use_case_test.mocks.dart';

void main() {
  late SaveSettingUseCase saveSettingUseCase;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    saveSettingUseCase = SaveSettingUseCase(mockSettingsRepository);
  });

  group('SaveSettingUseCase', () {
    test('should call saveSetting on the repository', () async {
      // Arrange
      const Setting testSetting = Setting('test_key', 'test_value');
      when(mockSettingsRepository.saveSetting(any)).thenAnswer((_) async {});

      // Act
      await saveSettingUseCase.execute(testSetting);

      // Assert
      verify(mockSettingsRepository.saveSetting(testSetting)).called(1);
    });

    test('should throw an exception when repository throws', () async {
      // Arrange
      const Setting testSetting = Setting('test_key', 'test_value');
      when(mockSettingsRepository.saveSetting(any)).thenThrow(Exception('Test error'));

      // Act & Assert
      expect(() => saveSettingUseCase.execute(testSetting), throwsException);
    });
  });
}
