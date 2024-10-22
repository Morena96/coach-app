import 'dart:async';

import 'package:domain/features/logging/entities/log_entry.dart' as domain_logs;
import 'package:domain/features/logging/repositories/log_persistence_manager.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TalkerLogger implements LoggerRepository {
  final Talker _talker;
  final LogPersistenceManager _persistenceManager;
  final ReplaySubject<domain_logs.LogEntry> _logSubject;
  StreamSubscription<TalkerData>? _talkerSubscription;

  TalkerLogger(this._talker, this._persistenceManager, {int maxLogSize = 100}) 
      : _logSubject = ReplaySubject<domain_logs.LogEntry>(maxSize: maxLogSize) {
    _talkerSubscription = _talker.stream.listen(_handleTalkerLog);
  }

  @override
  void debug(String message) => _talker.debug(message);

  @override
  void info(String message) => _talker.info(message);

  @override
  void warning(String message) => _talker.warning(message);

  @override
  void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      _talker.error(message, error, stackTrace);

   @override
  Stream<domain_logs.LogEntry> get logStream => _logSubject.stream;

  @override
  Future<List<domain_logs.LogEntry>> getLogsByPage(int page, int pageSize) async =>
      _persistenceManager.readLogsByPage(page, pageSize);

  void _handleTalkerLog(TalkerData log) {
    final level = _mapTalkerLogLevelToLogLevel(log.logLevel);
    final logEntry = domain_logs.LogEntry(
      level: level,
      message: log.message ?? '',
      error: log.error,
      stackTrace: log.stackTrace,
    );
    _persistenceManager.writeLog(logEntry);
    _logSubject.add(logEntry);
  }

  domain_logs.LogLevel _mapTalkerLogLevelToLogLevel(LogLevel? talkerLogLevel) {
    switch (talkerLogLevel) {
      case LogLevel.debug:
        return domain_logs.LogLevel.debug;
      case LogLevel.info:
        return domain_logs.LogLevel.info;
      case LogLevel.warning:
        return domain_logs.LogLevel.warning;
      case LogLevel.error:
      case LogLevel.critical:
        return domain_logs.LogLevel.error;
      case LogLevel.verbose:
        return domain_logs.LogLevel.verbose;
      default:
        return domain_logs.LogLevel.info;
    }
  }

  void dispose() {
    _talkerSubscription?.cancel();
    _logSubject.close();
  }
}
