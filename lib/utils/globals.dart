import 'package:example_drift_with_bloc/database/database.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton(AppDatabase());
}
