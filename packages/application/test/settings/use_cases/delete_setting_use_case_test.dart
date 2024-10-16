import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:application/settings/use_cases/delete_setting_use_case.dart';
import 'package:domain/features/settings/repositories/settings.dart';

@GenerateMocks([SettingsRepository])

import 'delete_setting_use_case_test.mocks.dart';


void main() {
  late DeleteSettingUseCase deleteSettingUseCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    deleteSettingUseCase = DeleteSettingUseCase(mockRepository);
  });

  group('DeleteSettingUseCase', () {
    test('should call deleteSetting on the repository', () async {
      // Arrange
      const String testKey = 'test_key';
      when(mockRepository.deleteSetting(any)).thenAnswer((_) async {});

      // Act
      await deleteSettingUseCase.execute(testKey);

      // Assert
      verify(mockRepository.deleteSetting(testKey)).called(1);
    });

    test('should throw an exception when repository throws', () async {
      // Arrange
      const String testKey = 'test_key';
      when(mockRepository.deleteSetting(any)).thenThrow(Exception('Test error'));

      // Act & Assert
      expect(() => deleteSettingUseCase.execute(testKey), throwsException);
    });
  });
}
