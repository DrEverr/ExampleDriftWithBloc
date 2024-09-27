import 'package:bloc/bloc.dart';
import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/utils/enums.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    getIt<AppDatabase>().insertLog(LogLevel.info, event.toString(), tag: bloc.runtimeType.toString());
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    getIt<AppDatabase>().insertLog(LogLevel.error, '${error.toString()} $stackTrace', tag: bloc.runtimeType.toString());
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    getIt<AppDatabase>().insertLog(LogLevel.debug, transition.toString(), tag: bloc.runtimeType.toString());
    super.onTransition(bloc, transition);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    getIt<AppDatabase>().insertLog(LogLevel.debug, change.toString(), tag: bloc.runtimeType.toString());
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    getIt<AppDatabase>().insertLog(LogLevel.debug, 'Closed', tag: bloc.runtimeType.toString());
    super.onClose(bloc);
  }

  @override
  void onCreate(BlocBase bloc) {
    getIt<AppDatabase>().insertLog(LogLevel.debug, 'Created', tag: bloc.runtimeType.toString());
    super.onCreate(bloc);
  }
}