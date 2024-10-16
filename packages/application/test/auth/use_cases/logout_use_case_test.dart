import 'package:test/test.dart';
import 'package:application/auth/use_cases/logout_use_case.dart';
import 'package:domain/features/auth/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthRepository])
import 'logout_use_case_test.mocks.dart';

void main() {
  late LogoutUseCase logoutUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    logoutUseCase = LogoutUseCase(mockAuthRepository);
  });

  group('LogoutUseCase', () {
    test('execute completes successfully when logout is successful', () async {
      // Arrange
      when(mockAuthRepository.logout()).thenAnswer((_) async {});

      // Act & Assert
      expect(logoutUseCase.execute(), completes);
      verify(mockAuthRepository.logout()).called(1);
    });

    test('execute throws an exception when repository throws', () async {
      // Arrange
      when(mockAuthRepository.logout())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(() => logoutUseCase.execute(), throwsException);
    });
  });
}
