import 'package:application/logging/use_cases/get_all_logs_by_page_use_case.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_all_logs_by_page_use_case_provider.g.dart';

@riverpod
GetAllLogsByPageUseCase getAllLogsByPageUseCase(GetAllLogsByPageUseCaseRef ref) {
  final logger = ref.watch(loggerProvider);
  return GetAllLogsByPageUseCase(logger);
}
