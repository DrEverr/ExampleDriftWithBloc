part of 'database.dart';

@DataClassName('History')
class Histories extends Table {
  TextColumn get id => text().unique()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get article => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  BoolColumn get isFavourite => boolean().withDefault(const Constant(false))();
}

class Logs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get level => intEnum<LogLevel>()();
  TextColumn get tag => text().nullable()();
  TextColumn get message => text()();
  DateTimeColumn get date => dateTime()();
}
