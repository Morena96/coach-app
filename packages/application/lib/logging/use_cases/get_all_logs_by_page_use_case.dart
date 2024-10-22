import 'package:domain/features/logging/entities/log_entry.dart';
import 'package:domain/features/logging/repositories/logger.dart';

class GetAllLogsByPageUseCase {
  final LoggerRepository _logger;

  GetAllLogsByPageUseCase(this._logger);

  Future<List<LogEntry>> execute(int page, int pageSize) async {
    return await _logger.getLogsByPage(page, pageSize);
  }
}
