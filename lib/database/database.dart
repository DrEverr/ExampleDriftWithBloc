import 'dart:async';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:example_drift_with_bloc/utils/enums.dart';

part 'database.g.dart';

part 'tables.dart';

@DriftDatabase(tables: [Histories, Favourites, Logs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'example_drift_with_bloc.db'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {},
      );

  Future<void> clearLogs() async {
    await delete(logs).go();
  }

  Future<void> clearFavourites() async {
    await delete(favourites).go();
  }

  Future<void> clearHistories() async {
    await delete(histories).go();
  }

  Future<void> clearAll() async {
    await clearLogs();
    await clearFavourites();
    await clearHistories();
  }

  Future<void> insertLog(LogLevel level, String message, {String? tag}) async {
    await into(logs).insert(LogsCompanion(
      level: Value(level),
      tag: Value(tag),
      message: Value(message),
      date: Value(DateTime.now()),
    ));
  }

  Future<void> insertHistory(String? title, String? description,
      String? article, String? dateTime) async {
    var history = HistoriesCompanion(
        title: Value(title),
        description: Value(description),
        article: Value(article),
        date: Value(dateTime != null ? DateTime.parse(dateTime) : null));
    await into(histories).insert(history,
        onConflict: DoUpdate((_) => history, target: [histories.id]));
  }

  Future<void> insertBatchHistories(List<History> historiesToInput) async {
    await batch((batch) {
      for (var history in historiesToInput) {
        batch.insert(
          histories,
          history,
          onConflict: DoUpdate((_) => history, target: [histories.id]),
        );
      }
    });
  }

  Future<void> insertFavourite(String historyId) async {
    await into(favourites).insert(FavouritesCompanion(
      historyId: Value(historyId),
    ));
  }

  Future<void> deleteFavourite(String historyId) async {
    await (delete(favourites)..where((tbl) => tbl.historyId.equals(historyId)))
        .go();
  }

  Future<void> deleteHistory(String historyId) async {
    await (delete(histories)..where((tbl) => tbl.id.equals(historyId))).go();
    deleteFavourite(historyId);
  }

  Future<List<History>> getAllHistories() async {
    return await select(histories).get();
  }

  Future<History?> getHistory(String id) async {
    return await (select(histories)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<History>> getAllFavourites() async {
    return await (select(histories)
          ..join([
            innerJoin(favourites, favourites.historyId.equalsExp(histories.id))
          ])
          ..get())
        .get();
  }

  Future<Favourite?> getFavourite(String historyId) async {
    return await (select(favourites)
          ..where((tbl) => tbl.historyId.equals(historyId)))
        .getSingleOrNull();
  }

  Future<List<Log>> getAllLogs() async {
    return await select(logs).get();
  }

  Future<List<Log>> getLogsByLevel(LogLevel level) async {
    return await (select(logs)..where((tbl) => tbl.level.equals(level.index)))
        .get();
  }

  Future<List<Log>> getLogsByTag(String tag) async {
    return await (select(logs)..where((tbl) => tbl.tag.equals(tag))).get();
  }

  Future<Log?> getLastError() async {
    return await (select(logs)
          ..where((tbl) =>
              tbl.level.equals(LogLevel.error.index) |
              tbl.level.equals(LogLevel.fatal.index))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<Log?> getLastUpdate() async {
    return await (select(logs)
          ..where((tbl) => tbl.tag.equals('API'))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<Log>> getLogs(
      {int limit = 10,
      LogLevel level = LogLevel.warning,
      int offset = 0}) async {
    return await (select(logs)
          ..where((tbl) => tbl.level.isBiggerOrEqualValue(level.index))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
          ..limit(limit, offset: offset))
        .get();
  }

  Future<int> getLogsCount(LogLevel level) async {
    return await (select(logs)..where((tbl) => tbl.level.equals(level.index)))
        .get()
        .then((value) => value.length);
  }

  Future<int> getLogsCountAll() async {
    return await (select(logs)).get().then((value) => value.length);
  }

  FutureOr<List<String?>> getTags() async {
    return await (select(logs)
          ..addColumns([logs.tag])
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.tag)]))
        .get()
        .then((value) => value.map((e) => e.tag).toList())
        .then((value) => value.toSet().toList());
  }

  Future<List<History>> getHistories(
      {int limit = 10, int offset = 0, bool isFavourite = false}) async {
    if (isFavourite) {
      return await (select(histories)
            ..join([
              innerJoin(
                  favourites, favourites.historyId.equalsExp(histories.id))
            ])
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
            ..limit(limit, offset: offset))
          .get();
    } else {
      return await (select(histories)
            ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)])
            ..limit(limit, offset: offset))
          .get();
    }
  }
}
