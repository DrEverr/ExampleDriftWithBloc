part of 'histories_bloc.dart';

@immutable
sealed class HistoriesState extends Equatable{
  const HistoriesState();

  @override
  List<Object> get props => [];
}

final class HistoriesInitial extends HistoriesState {}

final class HistoriesLoadInProgress extends HistoriesState {}

final class HistoriesLoadSuccess extends HistoriesState {
  final List<History> history;

  const HistoriesLoadSuccess(this.history);

  @override
  List<Object> get props => [history];
}

final class HistoriesLoadFailure extends HistoriesState {
  final String message;

  const HistoriesLoadFailure(this.message);

  @override
  List<Object> get props => [message];
}
