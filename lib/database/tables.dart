part of 'database.dart';

@DataClassName('History')
class Histories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get article => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
}

class Favourites extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get historyId => integer().references(Histories, #id)();
}

class Logs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get level => intEnum<LogLevel>()();
  TextColumn get tag => text().nullable()();
  TextColumn get message => text()();
  DateTimeColumn get date => dateTime()();
}
