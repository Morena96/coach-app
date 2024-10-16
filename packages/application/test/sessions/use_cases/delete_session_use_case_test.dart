import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:application/sessions/use_cases/delete_session_use_case.dart';

@GenerateMocks([SessionsRepository])
import 'delete_session_use_case_test.mocks.dart';

void main() {
  late DeleteSessionUseCase useCase;
  late MockSessionsRepository mockRepository;

  setUp(() {
    mockRepository = MockSessionsRepository();
    useCase = DeleteSessionUseCase(mockRepository);
  });

  group('DeleteSessionUseCase', () {
    const testSessionId = '1';

    test('should return success when session is deleted', () async {
      when(mockRepository.deleteSession(testSessionId))
          .thenAnswer((_) async => Result.success(null));

      final result = await useCase.execute(testSessionId);

      expect(result.isSuccess, true);
      verify(mockRepository.deleteSession(testSessionId)).called(1);
    });

    test('should return failure when repository fails', () async {
      when(mockRepository.deleteSession(testSessionId))
          .thenAnswer((_) async => Result.failure('Error deleting session'));

      final result = await useCase.execute(testSessionId);

      expect(result.isFailure, true);
      expect(result.error, 'Error deleting session');
      verify(mockRepository.deleteSession(testSessionId)).called(1);
    });
  });
}