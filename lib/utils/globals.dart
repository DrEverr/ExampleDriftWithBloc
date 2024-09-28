import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/provider/api_provider.dart';
import 'package:example_drift_with_bloc/repository/history_repository.dart';
import 'package:example_drift_with_bloc/repository/log_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:repo/repo.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton(AppDatabase());
  getIt.registerSingleton(Repo());
  getIt.registerSingleton(ApiProvider(getIt<AppDatabase>(), getIt<Repo>()));
  getIt.registerSingleton(LogRepository(getIt<AppDatabase>()));
  getIt.registerSingleton(HistoryRepository(getIt<AppDatabase>(), getIt<ApiProvider>()));
}
