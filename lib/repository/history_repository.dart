import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/provider/api_provider.dart';
import 'package:example_drift_with_bloc/repository/log_repository.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';

final class HistoryRepository {
  final AppDatabase _database;
  final ApiProvider _apiProvider;

  // ToDo: Add Streams

  HistoryRepository(this._database, this._apiProvider);

  Future<void> fetchHistories() async {
    getIt<LogRepository>().logInfo('Fetch histories', tag: 'History');
    await _apiProvider.getHistories();
  }

  Future<void> clearHistories() async {
    getIt<LogRepository>().logInfo('Clear histories', tag: 'History');
    await _database.clearHistories();
  }

  Future<History?> getHistory(int id) async {
    getIt<LogRepository>().logInfo('Get history: $id', tag: 'History');
    return await _database.getHistory(id);
  }

  Future<List<History>> getHistories(int page, int limit) async {
    getIt<LogRepository>()
        .logInfo('Get histories: page: $page, limit: $limit', tag: 'History');
    var histories =
        await _database.getHistories(limit: limit, offset: page * limit);
    getIt<LogRepository>().logDebug(
        'Get histories: ${histories.length} ${histories.map((h) => h.id)}',
        tag: 'History');
    return histories;
  }

  Future<List<History>> getFavourites(int page, int limit) async {
    getIt<LogRepository>().logInfo('Get favourites: page: $page, limit: $limit',
        tag: 'Favourite');
    var histories = await _database.getHistories(
        limit: limit, offset: page * limit, isFavourite: true);
    getIt<LogRepository>().logDebug(
        'Get favourites: ${histories.length} ${histories.map((h) => h.id)}',
        tag: 'Favourite');
    return histories;
  }

  Future<void> toggleFavourite(History history) async {
    if (history.isFavourite) {
      getIt<LogRepository>()
          .logInfo('Removed from favourites: ${history.id}', tag: 'Favourite');
    } else {
      getIt<LogRepository>()
          .logInfo('Added to favourites: ${history.id}', tag: 'Favourite');
    }
    await _database.updateFavourite(history, !history.isFavourite);
  }
}
