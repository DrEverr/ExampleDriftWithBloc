part of 'logs_bloc.dart';

sealed class LogsEvent extends Equatable {
  const LogsEvent();

  @override
  List<Object> get props => [];
}

class LogsStarted extends LogsEvent {}
