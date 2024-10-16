import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/features/sessions/repositories/sessions_repository.dart';
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart';
import 'package:domain/features/shared/utilities/result.dart';
import 'package:application/sessions/use_cases/get_all_sessions_by_page_use_case.dart';

import '../session_factory.dart';
@GenerateMocks([SessionsRepository])
import 'get_all_sessions_by_page_use_case_test.mocks.dart';

void main() {
  late GetAllSessionsByPageUseCase useCase;
  late MockSessionsRepository mockRepository;

  setUp(() {
    mockRepository = MockSessionsRepository();
    useCase = GetAllSessionsByPageUseCase(mockRepository); 
  });

  group('GetAllSessionsByPageUseCase', () {
    final testSessions = [SessionFactory.create(id: '1'), SessionFactory.create(id: '2')];
    const testPage = 1;
    const testPageSize = 10;
    final testFilterCriteria = SessionsFilterCriteria();

    test('should return a list of sessions when successful', () async {
      when(mockRepository.getSessionsByPage(testPage, testPageSize, filterCriteria: testFilterCriteria))
          .thenAnswer((_) async => Result.success(testSessions));

      final result = await useCase.execute(testPage, testPageSize, filterCriteria: testFilterCriteria);

      expect(result.isSuccess, true);
      expect(result.value, testSessions);
      verify(mockRepository.getSessionsByPage(testPage, testPageSize, filterCriteria: testFilterCriteria)).called(1);
    });

    test('should return a failure when repository fails', () async {
      when(mockRepository.getSessionsByPage(testPage, testPageSize, filterCriteria: testFilterCriteria))
          .thenAnswer((_) async => Result.failure('Error fetching sessions'));

      final result = await useCase.execute(testPage, testPageSize, filterCriteria: testFilterCriteria);

      expect(result.isFailure, true);
      expect(result.error, 'Error fetching sessions');
      verify(mockRepository.getSessionsByPage(testPage, testPageSize, filterCriteria: testFilterCriteria)).called(1);
    });
  });
}

