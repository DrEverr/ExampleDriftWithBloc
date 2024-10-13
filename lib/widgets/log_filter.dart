import 'package:flutter/material.dart';

class LogFilter extends StatelessWidget {
  final Function(String) onFilter;

  const LogFilter({super.key, required this.onFilter});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter logs'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              onFilter('all');
              Navigator.pop(context);
            },
            child: const Text('All'),
          ),
          ElevatedButton(
            onPressed: () {
              onFilter('info');
              Navigator.pop(context);
            },
            child: const Text('Info'),
          ),
          ElevatedButton(
            onPressed: () {
              onFilter('warning');
              Navigator.pop(context);
            },
            child: const Text('Warning'),
          ),
          ElevatedButton(
            onPressed: () {
              onFilter('error');
              Navigator.pop(context);
            },
            child: const Text('Error'),
          ),
        ],
      ),
    );
  }
}