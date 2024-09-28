part of 'logs_bloc.dart';

sealed class LogsState extends Equatable {
  const LogsState();

  @override
  List<Object> get props => [];
}

final class LogsInitial extends LogsState {}

final class LogsLoadInProgress extends LogsState {}

final class LogsLoadSuccess extends LogsState {
  const LogsLoadSuccess(this.logs);

  final List<Log> logs;

  @override
  List<Object> get props => [logs];
}

final class LogsLoadFailure extends LogsState {
  const LogsLoadFailure(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
