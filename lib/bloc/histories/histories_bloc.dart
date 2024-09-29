import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/provider/api_provider.dart';
import 'package:example_drift_with_bloc/repository/history_repository.dart';
import 'package:example_drift_with_bloc/repository/log_repository.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'histories_event.dart';
part 'histories_state.dart';

class HistoriesBloc extends Bloc<HistoriesEvent, HistoriesState> {
  int _page = 0;

  List<History> _histories = [];
  final _historiesStreamController = StreamController<List<History>>();
  Stream<List<History>> get historiesStream =>
      _historiesStreamController.stream;

  Stream<int> get totalHistoriesStream =>
      getIt<HistoryRepository>().watchHistoriesCount();

  dispose() {
    _historiesStreamController.close();
  }

  HistoriesBloc() : super(HistoriesInitial()) {
    on<HistoriesStarted>((event, emit) async {
      try {
        _page = 0;
        _histories = await getIt<HistoryRepository>().getHistories(_page, 10);
        _historiesStreamController.sink.add(_histories);
      } catch (e) {
        emit(HistoriesLoadFailure(e.toString()));
      }
    });

    on<HistoriesDataRequested>((event, emit) async {
      emit(HistoriesLoadInProgress());
      try {
        var lastUpdate = await getIt<LogRepository>().getLastUpdate();
        if (lastUpdate == null ||
            lastUpdate.compareTo(
                    DateTime.now().subtract(const Duration(hours: 1))) <=
                0) {
          await getIt<ApiProvider>().getHistories();
        } else {
          emit(const HistoriesLoadFailure(
              'Data has already been updated within the last hour.'));
        }
        add(HistoriesStarted());
      } catch (e) {
        emit(HistoriesLoadFailure(e.toString()));
      }
    });

    on<HistoriesLoadedMore>((event, emit) async {
      if ((_page + 1) * 10 >=
          await getIt<HistoryRepository>().getHistoriesCount()) {
        return;
      }
      try {
        _page++;
        _histories
            .addAll(await getIt<HistoryRepository>().getHistories(_page, 10));
        _historiesStreamController.sink.add(_histories);
      } catch (e) {
        emit(HistoriesLoadFailure(e.toString()));
      }
    });

    on<HistoriesToggledFavourite>((event, emit) async {
      try {
        await getIt<HistoryRepository>().toggleFavourite(event.history);
        var updatedHistory =
            event.history.copyWith(isFavourite: !event.history.isFavourite);
        var index = _histories.indexWhere((h) => h.id == updatedHistory.id);
        _histories[index] = updatedHistory;
        _historiesStreamController.sink.add(_histories);
      } catch (e) {
        emit(HistoriesLoadFailure(e.toString()));
      }
    });
  }
}
