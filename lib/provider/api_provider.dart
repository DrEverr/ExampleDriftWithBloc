import 'dart:convert';

import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/repository/log_repository.dart';
import 'package:example_drift_with_bloc/utils/api/api.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';
import 'package:repo/repo.dart';

final class ApiProvider {
  final AppDatabase _database;
  final Repo _repo;

  ApiProvider(this._database, this._repo);

  Future<void> getHistories() async {
    getIt<LogRepository>().logInfo('Getting histories from API', tag: 'API');
    try {
      var response = await _repo.call(Api.historyUrl);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        var decoded = jsonDecode(response.body) as List<dynamic>;
        await _database.insertBatchHistories(decoded.map((e) {
            return History(
              id: e['id'] as String,
              title: e['title'] as String?,
              description: e['details'] as String?,
              article: e['links']['article'] as String?,
              date: e['event_date_utc'] != null
                ? DateTime.parse(e['event_date_utc'] as String)
                : null);
        }).toList());
      }
    } catch (e) {
      getIt<LogRepository>()
          .logError('Error getting histories from API: $e', tag: 'API');
    }
  }
}
