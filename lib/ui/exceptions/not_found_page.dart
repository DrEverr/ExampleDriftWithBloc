import 'package:flutter/material.dart';

final class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not found'),
      ),
      body: const Center(
        child: Text('Not found page'),
      ),
    );
  }
}