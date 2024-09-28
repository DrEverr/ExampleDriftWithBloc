import 'package:example_drift_with_bloc/bloc/logs/logs_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LogsPage extends StatelessWidget {
  const LogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LogsBloc()..add(LogsStarted()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Logs'),
        ),
        body: BlocBuilder<LogsBloc, LogsState>(
          builder: (context, state) {
            if (state is LogsLoadInProgress) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is LogsLoadSuccess) {
              return ListView.builder(
                itemCount: state.logs.length,
                itemBuilder: (context, index) {
                  final log = state.logs[index];
                  return ListTile(
                    title: Text(
                      '${log.level.name.toUpperCase()}: ${log.message}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    subtitle: Text(
                      log.date.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  );
                },
              );
            } else if (state is LogsLoadFailure) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const Center(
                child: Text('No logs'),
              );
            }
          },
        ),
      ),
    );
  }
}
