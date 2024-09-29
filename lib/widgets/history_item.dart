import 'package:example_drift_with_bloc/bloc/histories/histories_bloc.dart';
import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/utils/routes.dart';
import 'package:example_drift_with_bloc/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class HistoryItem extends StatelessWidget {
  final History history;

  const HistoryItem({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.0,
        ),
      ),
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        trailing: IconButton(
          icon: Icon(
            history.isFavourite ? Icons.star : Icons.star_border,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            context.read<HistoriesBloc>().add(
                  HistoriesToggledFavourite(history),
                );
          },
        ),
        title: Text(
          history.title ?? 'No title',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          Tools.shortenString(history.description ?? 'No description',
              length: 200),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.history,
            arguments: history,
          );
        },
      ),
    );
  }
}
