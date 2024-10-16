import 'package:application/sessions/use_cases/get_session_by_id_use_case.dart';
import 'package:domain/features/sessions/entities/session.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'update_session_use_case_test.mocks.dart';

void main() {
  late GetSessionByIdUseCase useCase;
  late MockSessionsRepository mockRepository;

  setUp(() {
    mockRepository = MockSessionsRepository();
    useCase = GetSessionByIdUseCase(mockRepository);
  });

  group('GetSessionByIdUseCase', () {
    const testSessionId = '123';
    final testSession = Session.empty(id: testSessionId, title: 'Test Session');

    test('should return a session when successful', () async {
      // Arrange
      when(mockRepository.getSessionById(testSessionId))
          .thenAnswer((_) async => Result.success(testSession));

      // Act
      final result = await useCase.execute(testSessionId);

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, testSession);
      verify(mockRepository.getSessionById(testSessionId)).called(1);
    });

    test('should return null when session is not found', () async {
      // Arrange
      when(mockRepository.getSessionById(testSessionId))
          .thenAnswer((_) async => Result.success(null));

      // Act
      final result = await useCase.execute(testSessionId);

      // Assert
      expect(result.isSuccess, true);
      expect(result.value, null);
      verify(mockRepository.getSessionById(testSessionId)).called(1);
    });

    test('should return a failure when repository fails', () async {
      // Arrange
      when(mockRepository.getSessionById(testSessionId))
          .thenAnswer((_) async => Result.failure('Error fetching session'));

      // Act
      final result = await useCase.execute(testSessionId);

      // Assert
      expect(result.isFailure, true);
      expect(result.error, 'Error fetching session');
      verify(mockRepository.getSessionById(testSessionId)).called(1);
    });
  });
}
