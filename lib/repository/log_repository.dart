import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/utils/enums.dart';

class LogRepository {
  final AppDatabase _database;

  LogRepository(this._database);

  Future<void> logFatal(String message, {String? tag}) async {
    await _database.insertLog(LogLevel.fatal, message, tag: tag);
  }

  Future<void> logError(String message, {String? tag}) async {
    await _database.insertLog(LogLevel.error, message, tag: tag);
  }

  Future<void> logWarning(String message, {String? tag}) async {
    await _database.insertLog(LogLevel.warning, message, tag: tag);
  }

  Future<void> logInfo(String message, {String? tag}) async {
    await _database.insertLog(LogLevel.info, message, tag: tag);
  }

  Future<void> logDebug(String message, {String? tag}) async {
    await _database.insertLog(LogLevel.debug, message, tag: tag);
  }

  Future<void> logTrace(String message, {String? tag}) async {
    await _database.insertLog(LogLevel.trace, message, tag: tag);
  }

  Future<void> clearLogs() async {
    await _database.clearLogs();
  }

  Future<List<Log>> getLogs(int page, int limit,
      {LogLevel level = LogLevel.warning}) async {
    return await _database.getLogs(
        limit: limit, offset: page * limit, level: level);
  }

  Future<int> getLogsCount(LogLevel level) async {
    return await _database.getLogsCount(level);
  }

  Future<int> getAllLogsCount() async {
    return await _database.getLogsCountAll();
  }

  Future<List<String?>> getTags() async {
    return await _database.getTags();
  }

  Future<DateTime?> getLastUpdate() async {
    var log = await _database.getLastUpdate();
    return log?.date;
  }
}
