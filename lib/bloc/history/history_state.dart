part of 'history_bloc.dart';

@immutable
sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

final class HistoryLoadInProgress extends HistoryState {}

final class HistoryLoadSuccess extends HistoryState {
  final History history;

  HistoryLoadSuccess(this.history);
}

final class HistoryLoadFailure extends HistoryState {
  final String message;

  HistoryLoadFailure(this.message);
}
