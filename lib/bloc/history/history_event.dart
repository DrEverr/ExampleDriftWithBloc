part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

final class HistoryStarted extends HistoryEvent {
  final String id;

  const HistoryStarted(this.id);

  @override
  List<Object> get props => [id];
}

final class HistoryFavoriteToggled extends HistoryEvent {
  final History history;

  const HistoryFavoriteToggled(this.history);

  @override
  List<Object> get props => [history];
}
