import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/repository/log_repository.dart';
import 'package:example_drift_with_bloc/utils/enums.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';

part 'logs_event.dart';
part 'logs_state.dart';

class LogsBloc extends Bloc<LogsEvent, LogsState> {
  LogsBloc() : super(LogsInitial()) {
    on<LogsStarted>((event, emit) async {
      emit(LogsLoadInProgress());
      try {
        final logs =
            await getIt<LogRepository>().getLogs(0, 100, level: LogLevel.info);
        emit(LogsLoadSuccess(logs));
      } catch (e) {
        emit(LogsLoadFailure(e.toString()));
      }
    });
  }
}
