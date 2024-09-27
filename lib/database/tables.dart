part of 'database.dart';

class History extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get article => text().nullable()();
}

class Favorite extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get historyId => integer().references(History, #id)();
}
