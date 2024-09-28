import 'package:example_drift_with_bloc/database/database.dart';
import 'package:flutter/material.dart';

final class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key, required this.history});

  final History history;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(history.title ?? 'No title'),
            Text(history.description ?? 'No description'),
            Text(history.date?.toString() ?? 'No date'),
            Text(history.article ?? 'No article'),
          ],
        ),
      ),
    );
  }
}