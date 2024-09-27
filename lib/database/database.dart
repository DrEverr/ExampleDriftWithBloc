import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

part 'tables.dart';

@DriftDatabase(tables: [History, Favorite])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'sqlite.db'));

  @override
  int get schemaVersion => 1;
}
