import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:domain/features/settings/repositories/settings.dart';
import 'package:application/settings/use_cases/get_setting_use_case.dart';

@GenerateMocks([SettingsRepository])

import 'get_setting_use_case_test.mocks.dart';

void main() {
  late GetSettingUseCase getSettingUseCase;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    getSettingUseCase = GetSettingUseCase(mockSettingsRepository);
  });

  group('GetSettingUseCase', () {
    test('should return a setting from the repository when it exists', () async {
      // Arrange
      const String testKey = 'test_key';
      // ignore: prefer_const_constructors
      final Setting testSetting = Setting(testKey, 'test_value');
      when(mockSettingsRepository.getSettingByKey(testKey))
          .thenAnswer((_) async => testSetting);

      // Act
      final result = await getSettingUseCase.execute(testKey);

      // Assert
      expect(result, equals(testSetting));
      verify(mockSettingsRepository.getSettingByKey(testKey)).called(1);
    });

    test('should return null when the setting does not exist', () async {
      // Arrange
      const String testKey = 'non_existent_key';
      when(mockSettingsRepository.getSettingByKey(testKey))
          .thenAnswer((_) async => null);

      // Act
      final result = await getSettingUseCase.execute(testKey);

      // Assert
      expect(result, isNull);
      verify(mockSettingsRepository.getSettingByKey(testKey)).called(1);
    });

    test('should throw an exception when repository throws', () async {
      // Arrange
      const String testKey = 'test_key';
      when(mockSettingsRepository.getSettingByKey(testKey))
          .thenThrow(Exception('Test error'));

      // Act & Assert
      expect(() => getSettingUseCase.execute(testKey), throwsException);
      verify(mockSettingsRepository.getSettingByKey(testKey)).called(1);
    });
  });
}
