import 'package:example_drift_with_bloc/bloc/histories/histories_bloc.dart';
import 'package:example_drift_with_bloc/utils/routes.dart';
import 'package:example_drift_with_bloc/widgets/history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatefulWidget {
  const App({super.key, required this.title});

  final String title;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              onPressed: () {
                Navigator.of(context).pushNamed(Routes.logs);
              },
            ),
          ],
        ),
        body: BlocProvider(
          create: (_) => HistoriesBloc()..add(HistoriesStarted()),
          child: BlocConsumer<HistoriesBloc, HistoriesState>(
            listener: (context, state) {
              if (state is HistoriesLoadFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is HistoriesLoadInProgress) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is HistoriesLoadSuccess) {
                if (state.history.isEmpty) {
                  return _noData(context, state);
                }
                return ListView.builder(
                  itemCount: state.history.length,
                  itemBuilder: (context, index) {
                    final history = state.history[index];
                    return HistoryItem(history: history);
                  },
                );
              } else {
                return _noData(context, state);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _noData(BuildContext context, HistoriesState state) {
    return Center(
      child: Column(
        children: [
          const Text('No data'),
          ElevatedButton(
            onPressed: () {
              context.read<HistoriesBloc>().add(HistoriesDataRequested());
            },
            child: const Text('Fetch data from server'),
          ),
        ],
      ),
    );
  }
}
