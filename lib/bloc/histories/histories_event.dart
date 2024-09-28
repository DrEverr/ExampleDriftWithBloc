part of 'histories_bloc.dart';

@immutable
sealed class HistoriesEvent extends Equatable {
  const HistoriesEvent();

  @override
  List<Object> get props => [];
}

final class HistoriesStarted extends HistoriesEvent {}

final class HistoriesDataRequested extends HistoriesEvent {}

final class HistoriesChangedNextPage extends HistoriesEvent {}

final class HistoriesChangedPreviousPage extends HistoriesEvent {}

final class HistoriesToggledFavourite extends HistoriesEvent {
  final History history;

  const HistoriesToggledFavourite(this.history);

  @override
  List<Object> get props => [history];
}
