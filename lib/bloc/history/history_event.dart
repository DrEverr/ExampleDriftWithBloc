part of 'history_bloc.dart';

@immutable
sealed class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object> get props => [];
}

final class HistoryFavoriteToggled extends HistoryEvent {
  final History history;

  const HistoryFavoriteToggled(this.history);

  @override
  List<Object> get props => [history];
}
