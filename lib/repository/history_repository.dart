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

  Future<History?> getHistory(String id) async {
    getIt<LogRepository>().logInfo('Get history: $id', tag: 'History');
    return await _database.getHistory(id);
  }

  Future<List<History>> getHistories(int page, int limit) async {
    getIt<LogRepository>().logInfo('Get histories: page: $page, limit: $limit', tag: 'History');
    var histories = await _database.getHistories(limit: limit, offset: page * limit);
    getIt<LogRepository>().logDebug('Get histories: ${histories.length} ${histories.map((h) => h.id)}', tag: 'History');
    return histories;
  }

  Future<List<History>> getFavourites(int page, int limit) async {
    getIt<LogRepository>().logInfo('Get favourites: page: $page, limit: $limit', tag: 'Favourite');
    var histories =  await _database.getHistories(
        limit: limit, offset: page * limit, isFavourite: true);
    getIt<LogRepository>().logDebug('Get favourites: ${histories.length} ${histories.map((h) => h.id)}', tag: 'Favourite');
    return histories;
  }

  Future<void> toggleFavourite(String id) async {
    var favourite = await _database.getFavourite(id);
    if (favourite != null) {
      getIt<LogRepository>().logInfo('Removed from favourites: $id', tag: 'Favourite');
      await _database.deleteFavourite(id);
    } else {
      getIt<LogRepository>().logInfo('Added to favourites: $id', tag: 'Favourite');
      await _database.insertFavourite(id);
    }
  }
}
