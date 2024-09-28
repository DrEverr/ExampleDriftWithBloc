import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/repository/history_repository.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';
import 'package:meta/meta.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<HistoryFavoriteToggled>((event, emit) async {
      getIt<HistoryRepository>().toggleFavourite(event.history);
      emit(HistoryLoadSuccess(event.history));
    });
  }
}
