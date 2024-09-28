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
  int page = 0;
  HistoriesBloc() : super(HistoriesInitial()) {
    on<HistoriesStarted>((event, emit) async {
      emit(HistoriesLoadInProgress());
      try {
        page = 0;
        final histories =
            await getIt<HistoryRepository>().getHistories(page, 10);
        emit(HistoriesLoadSuccess(histories));
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
                    DateTime.now().subtract(const Duration(minutes: 1))) <=
                0) {
          await getIt<ApiProvider>().getHistories();
        } else {
          emit(const HistoriesLoadFailure(
              'Data has already been updated within the last hour.'));
        }
        final histories = await getIt<HistoryRepository>().getHistories(0, 10);
        emit(HistoriesLoadSuccess(histories));
      } catch (e) {
        emit(HistoriesLoadFailure(e.toString()));
      }
    });

    on<HistoriesChangedNextPage>((event, emit) async {
      emit(HistoriesLoadInProgress());
      try {
        page++;
        final histories =
            await getIt<HistoryRepository>().getHistories(page, 10);
        emit(HistoriesLoadSuccess(histories));
      } catch (e) {
        emit(HistoriesLoadFailure(e.toString()));
      }
    });

    on<HistoriesChangedPreviousPage>((event, emit) async {
      emit(HistoriesLoadInProgress());
      try {
        page--;
        final histories =
            await getIt<HistoryRepository>().getHistories(page, 10);
        emit(HistoriesLoadSuccess(histories));
      } catch (e) {
        emit(HistoriesLoadFailure(e.toString()));
      }
    });

    on<HistoriesToggledFavourite>((event, emit) async {
      emit(HistoriesLoadInProgress());
      try {
        await getIt<HistoryRepository>().toggleFavourite(event.history);
        final histories =
            await getIt<HistoryRepository>().getHistories(page, 10);
        emit(HistoriesLoadSuccess(histories));
      } catch (e) {
        emit(HistoriesLoadFailure(e.toString()));
      }
    });
  }
}
