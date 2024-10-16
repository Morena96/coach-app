import 'package:test/test.dart';
import 'package:application/auth/use_cases/auth_status_use_case.dart';
import 'package:domain/features/auth/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthRepository])
import 'auth_status_use_case_test.mocks.dart';

void main() {
  late AuthStatusUseCase authStatusUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authStatusUseCase = AuthStatusUseCase(mockAuthRepository);
  });

  group('AuthStatusUseCase', () {
    test('execute returns true when user is logged in', () async {
      // Arrange
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => true);

      // Act
      final result = await authStatusUseCase.execute();

      // Assert
      expect(result, isTrue);
      verify(mockAuthRepository.isLoggedIn()).called(1);
    });

    test('execute returns false when user is not logged in', () async {
      // Arrange
      when(mockAuthRepository.isLoggedIn()).thenAnswer((_) async => false);

      // Act
      final result = await authStatusUseCase.execute();

      // Assert
      expect(result, isFalse);
      verify(mockAuthRepository.isLoggedIn()).called(1);
    });

    test('execute throws an exception when repository throws', () async {
      // Arrange
      when(mockAuthRepository.isLoggedIn())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => authStatusUseCase.execute(), throwsException);

    });
  });
}
