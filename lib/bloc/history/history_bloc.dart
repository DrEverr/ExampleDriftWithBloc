import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/repository/history_repository.dart';
import 'package:example_drift_with_bloc/repository/log_repository.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<HistoryStarted>((event, emit) async {
      emit(HistoryLoadInProgress());
      final history = await getIt<HistoryRepository>().getHistory(event.id);
      if (history != null) {
        emit(HistoryLoadSuccess(history));
      } else {
        getIt<LogRepository>()
            .logError('Failed to load history: ${event.id}', tag: 'History');
        emit(HistoryLoadFailure('Failed to load history'));
      }
    });

    on<HistoryFavoriteToggled>((event, emit) async {
      getIt<HistoryRepository>().toggleFavourite(event.history.id);
      emit(HistoryLoadSuccess(event.history));
    });
  }
}
