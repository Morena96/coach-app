import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:domain/features/settings/entities/setting.dart';
import 'package:domain/features/settings/repositories/settings.dart';
import 'package:application/settings/use_cases/get_all_settings_use_case.dart';


@GenerateMocks([SettingsRepository])

import 'get_all_settings_use_case_test.mocks.dart';

void main() {
  late GetAllSettingsUseCase getAllSettingsUseCase;
  late MockSettingsRepository mockSettingsRepository;

  setUp(() {
    mockSettingsRepository = MockSettingsRepository();
    getAllSettingsUseCase = GetAllSettingsUseCase(mockSettingsRepository);
  });

  group('GetAllSettingsUseCase', () {
    test('should return a list of settings from the repository', () async {
      // Arrange
      final List<Setting> testSettings = [
        const Setting('test_key1', 'test_value1'),
        const Setting('test_key2', 'test_value2'),
      ];
      when(mockSettingsRepository.getAllSettings())
          .thenAnswer((_) async => testSettings);

      // Act
      final result = await getAllSettingsUseCase.execute();

      // Assert
      expect(result, equals(testSettings));
      verify(mockSettingsRepository.getAllSettings()).called(1);
    });

    test('should return an empty list when repository returns empty', () async {
      // Arrange
      when(mockSettingsRepository.getAllSettings())
          .thenAnswer((_) async => []);

      // Act
      final result = await getAllSettingsUseCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(mockSettingsRepository.getAllSettings()).called(1);
    });

    test('should throw an exception when repository throws', () async {
      // Arrange
      final testException = Exception('Test error');
      when(mockSettingsRepository.getAllSettings())
          .thenThrow(testException);

      // Act & Assert
      expect(() => getAllSettingsUseCase.execute(), throwsA(testException));
      verify(mockSettingsRepository.getAllSettings()).called(1);
    });
  });
}
