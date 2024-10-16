import 'package:test/test.dart';
import 'package:application/auth/use_cases/login_use_case.dart';
import 'package:domain/features/auth/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthRepository])
import 'login_use_case_test.mocks.dart';

void main() {
  late LoginUseCase loginUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    loginUseCase = LoginUseCase(mockAuthRepository);
  });

  group('LoginUseCase', () {
    test('execute returns true when login is successful', () async {
      // Arrange
      const username = 'testuser';
      const password = 'testpassword';
      when(mockAuthRepository.login(username, password)).thenAnswer((_) async => true);

      // Act
      final result = await loginUseCase.execute(username, password);

      // Assert
      expect(result, isTrue);
      verify(mockAuthRepository.login(username, password)).called(1);
    });

    test('execute returns false when login fails', () async {
      // Arrange
      const username = 'testuser';
      const password = 'wrongpassword';
      when(mockAuthRepository.login(username, password)).thenAnswer((_) async => false);

      // Act
      final result = await loginUseCase.execute(username, password);

      // Assert
      expect(result, isFalse);
      verify(mockAuthRepository.login(username, password)).called(1);
    });

    test('execute throws an exception when repository throws', () async {
      // Arrange
      const username = 'testuser';
      const password = 'testpassword';
      when(mockAuthRepository.login(username, password))
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => loginUseCase.execute(username, password), throwsException);
    });
  });
}
