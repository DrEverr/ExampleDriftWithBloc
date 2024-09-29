import 'package:example_drift_with_bloc/database/database.dart';
import 'package:example_drift_with_bloc/repository/history_repository.dart';
import 'package:example_drift_with_bloc/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key, required this.history});

  final History history;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: Icon(
              _isFavourite ? Icons.star : Icons.star_border,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              getIt<HistoryRepository>().toggleFavourite(widget.history);
              setState(() {
                _isFavourite = !_isFavourite;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.history.title ?? 'No title',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.history.description ?? 'No description',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.history.date?.toString() ?? 'No date',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  if (widget.history.article != null) {
                    _launchUrl(Uri.parse(widget.history.article!));
                  }
                },
                child: Text(
                  widget.history.article ?? 'No article',
                  style: widget.history.article != null
                      ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            decoration: TextDecoration.underline,
                          )
                      : Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
