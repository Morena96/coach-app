import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:application/sessions/use_cases/update_session_use_case.dart';

import '../session_factory.dart';
@GenerateMocks([SessionsRepository])
import 'update_session_use_case_test.mocks.dart';

void main() {
  late UpdateSessionUseCase useCase;
  late MockSessionsRepository mockRepository;

  setUp(() {
    mockRepository = MockSessionsRepository();
    useCase = UpdateSessionUseCase(mockRepository);
  });

  group('UpdateSessionUseCase', () {
    final testSession = SessionFactory.create(id: '1', title: 'Updated Session');

    test('should return success when session is updated', () async {
      when(mockRepository.updateSession(testSession))
          .thenAnswer((_) async => Result.success(null));

      final result = await useCase.execute(testSession);

      expect(result.isSuccess, true);
      verify(mockRepository.updateSession(testSession)).called(1);
    });

    test('should return failure when repository fails', () async {
      when(mockRepository.updateSession(testSession))
          .thenAnswer((_) async => Result.failure('Error updating session'));

      final result = await useCase.execute(testSession);

      expect(result.isFailure, true);
      expect(result.error, 'Error updating session');
      verify(mockRepository.updateSession(testSession)).called(1);
    });
  });
}